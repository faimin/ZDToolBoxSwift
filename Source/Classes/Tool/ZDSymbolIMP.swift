//
//  ZDSymbolIMP.swift
//  ZDSwiftToolKit
//
//  Created by Zero.D.Saber on 2022/9/26.
//

import Foundation
import MachO

public func FindSymbolAddress(_ symbol: String) -> UnsafeRawPointer? {
    var symbolMap = [String: UnsafeRawPointer]()
    for i in 0..<_dyld_image_count() {
        let pathArr = String(cString: _dyld_get_image_name(i)).split(separator: "/")
        guard pathArr.first != "Applications", pathArr.first != "usr" else {
            continue
        }

        if let handle = dlopen(_dyld_get_image_name(i), RTLD_NOW), let pointer = dlsym(handle, symbol) {
            let fun = UnsafeRawPointer(pointer)
            symbolMap[symbol] = fun
            continue
        }
        
        if let targetFunc = FindExportedSwiftSymbol(
            symbol,
            _dyld_get_image_header(i),
            _dyld_get_image_vmaddr_slide(i)
        ) {
            symbolMap[symbol] = targetFunc
            continue
        }
    }
    
    return symbolMap[symbol]
}

private func FindExportedSwiftSymbol(_ symbol: String, _ imageHeader: UnsafePointer<mach_header>, _ slide: Int) -> UnsafeRawPointer? {
    
    let linkEditName = SEG_LINKEDIT.cString(using: .utf8)!
    var linkEditCMD: UnsafeMutablePointer<segment_command_64>?
    var dynamicLoadInfoCMD: UnsafeMutablePointer<dyld_info_command>?
    
    var currentCMD = UnsafeMutableRawPointer(mutating: imageHeader).advanced(by: MemoryLayout<mach_header_64>.size).assumingMemoryBound(to: segment_command_64.self)
    
    for _ in 0..<imageHeader.pointee.ncmds {
        if currentCMD.pointee.cmd == LC_DYLD_INFO_ONLY || currentCMD.pointee.cmd == LC_DYLD_INFO {
            dynamicLoadInfoCMD = currentCMD.withMemoryRebound(to: dyld_info_command.self, capacity: 1, { $0 })
        }
        else if currentCMD.pointee.cmd == LC_SEGMENT_64 {
            let segmentName = currentCMD.pointee.segname
            if segmentName.0 == linkEditName[0]
                && segmentName.1 == linkEditName[1]
                && segmentName.2 == linkEditName[2]
                && segmentName.3 == linkEditName[3]
                && segmentName.4 == linkEditName[4]
                && segmentName.5 == linkEditName[5]
                && segmentName.6 == linkEditName[6]
                && segmentName.7 == linkEditName[7]
                && segmentName.8 == linkEditName[8]
                && segmentName.9 == linkEditName[9]
            {
                linkEditCMD = currentCMD
            }
        }
        
        let currentCMDSize = Int(currentCMD.pointee.cmdsize)
        let nextCMD = currentCMD.withMemoryRebound(to: Int8.self, capacity: 1, { $0 }).advanced(by: currentCMDSize)
        currentCMD = nextCMD.withMemoryRebound(to: segment_command_64.self, capacity: 1, { $0 })
    }
    
    guard let linkEditCMD = linkEditCMD, let dynamicLoadInfoCMD = dynamicLoadInfoCMD else {
        return nil
    }
    
    let linkEditSegmentBase = Int(linkEditCMD.pointee.vmaddr) - Int(linkEditCMD.pointee.fileoff) + slide
    guard let exportedInfo = UnsafeMutableRawPointer(bitPattern: linkEditSegmentBase + Int(dynamicLoadInfoCMD.pointee.export_off))?.assumingMemoryBound(to: UInt8.self) else {
        return nil
    }
    let exportedInfoSize = Int(dynamicLoadInfoCMD.pointee.export_size)
    
    let start = exportedInfo, end = exportedInfo + exportedInfoSize
    
    guard var symbolLocation = trieWalk(symbol: symbol, start: start, end: end, currentLocation: start, currentSymbol: "") else {
        return nil
    }
    
    let returnSymbolAddress = { () -> UnsafeRawPointer in
        let macho = imageHeader.withMemoryRebound(to: Int8.self, capacity: 1, { $0 })
        let advance = readUleb128(p: &symbolLocation, end: end)
        let symbolAddr = macho.advanced(by: Int(advance))
        return UnsafeRawPointer(symbolAddr)
    }
    
    let flags = readUleb128(p: &symbolLocation, end: end)
    
    switch flags & UInt64(EXPORT_SYMBOL_FLAGS_KIND_MASK) {
    case UInt64(EXPORT_SYMBOL_FLAGS_KIND_REGULAR):
        return returnSymbolAddress()
    case UInt64(EXPORT_SYMBOL_FLAGS_KIND_THREAD_LOCAL):
        if (flags & UInt64(EXPORT_SYMBOL_FLAGS_STUB_AND_RESOLVER)) != 0 {
            return nil
        }
        return returnSymbolAddress()
    case UInt64(EXPORT_SYMBOL_FLAGS_KIND_ABSOLUTE):
        if (flags & UInt64(EXPORT_SYMBOL_FLAGS_STUB_AND_RESOLVER)) != 0 {
            return nil
        }
        let advance = readUleb128(p: &symbolLocation, end: end)
        return UnsafeRawPointer(bitPattern: Int(advance))
    default:
        break
    }
    
    return nil
}

private func readUleb128(
    p: inout UnsafeMutablePointer<UInt8>,
    end: UnsafeMutablePointer<UInt8>
) -> UInt64 {
    var result: UInt64 = 0
    var bit = 0
    var read_next = true
    
    repeat {
        if p == end {
            assert(false, "malformed uleb128")
        }
        
        let slice = UInt64(p.pointee & 0x7f)
        
        if bit > 63 {
            assert(false, "uleb128 too big for uint64")
        }
        else {
            result |= (slice << bit)
            bit += 7
        }
        
        read_next = (p.pointee & 0x80) != 0  // = 128
        p += 1
    } while (read_next)
    
    return result
}

// trieWalk ExportedSymbol Trie (深度先序遍历)
func trieWalk(
    symbol: String,
    start: UnsafeMutablePointer<UInt8>,
    end: UnsafeMutablePointer<UInt8>,
    currentLocation location: UnsafeMutablePointer<UInt8>,
    currentSymbol: String
) -> UnsafeMutablePointer<UInt8>? {
    var p = location
    
    while p <= end {
        // 1. terminalSize
        var terminalSize = UInt64(p.pointee)
        p += 1
        if terminalSize > 127 {
            p -= 1
            terminalSize = readUleb128(p: &p, end: end)
        }
        if terminalSize != 0 {
            // debug SwiftSymbol, print all exported Symbol and you can find symbolName
            let sym = swift_demangle(currentSymbol)
            print("demangle symbol = \(sym ?? "xxxx")")
            return sym == symbol ? p : nil
        }
        
        // 2. children
        let children = p.advanced(by: Int(terminalSize))
        if children > end {
            // end
            return nil
        }
        let childrenCount = children.pointee
        p = children + 1
        
        // 3. nodes
        for _ in 0..<childrenCount {
            let nodeLabel = p.withMemoryRebound(to: CChar.self, capacity: 1, { $0 })
            
            // node offset
            while p.pointee != 0 {  // != "\0"
                p += 1
            }
            p += 1  // = "\0"
            let nodeOffset = Int(readUleb128(p: &p, end: end))
            
            // node
            if let partOfSymbol = String(cString: nodeLabel, encoding: .utf8) {    // end with c '\0'
                let _currentSymbol = currentSymbol + partOfSymbol
                // print(partOfSymbol, _currentSymbol, nodeOffset)    // for debug
                if nodeOffset != 0 && (start + nodeOffset <= end) {
                    if let symbolLocation = trieWalk(symbol: symbol, start: start, end: end, currentLocation: start.advanced(by: nodeOffset), currentSymbol: _currentSymbol) {
                        return symbolLocation
                    }
                }
            }
        }
    }
    return nil
}


// MARK: Swift Runtime

// Swift Type Metadata https://github.com/apple/swift/blob/master/docs/ABI/TypeMetadata.rst#nominal-type-descriptor
func isFunction(_ type: Any.Type) -> Bool {
    assert(MemoryLayout.size(ofValue: type) == MemoryLayout<UnsafeMutablePointer<Int>>.size)
    
    let typePointer = unsafeBitCast(type, to: UnsafeMutablePointer<Int>.self)
    return typePointer.pointee == (2 | 0x100 | 0x200)
}

func swift_demangle(_ mangledName: String) -> String? {
    let cname = mangledName.withCString({ $0 })
    if let demangledName = get_swift_demangle(mangledName: cname, mangledNameLength: UInt(mangledName.utf8.count), outputBuffer: nil, outputBufferSize: nil, flags: 0) {
        return String(cString: demangledName)
    }
    return nil
}

// swift_demangle: Swift/Swift libraries/SwiftDemangling/Header Files/Demangle.h
@_silgen_name("swift_demangle")
private func get_swift_demangle(mangledName: UnsafePointer<CChar>?,
                                mangledNameLength: UInt,
                                outputBuffer: UnsafeMutablePointer<UInt8>?,
                                outputBufferSize: UnsafeMutablePointer<Int>?,
                                flags: UInt32
                                ) -> UnsafeMutablePointer<CChar>?
