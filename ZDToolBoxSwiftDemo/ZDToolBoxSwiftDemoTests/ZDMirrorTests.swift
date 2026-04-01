//
//  ZDMirrorTests.swift
//  ZDToolBoxSwiftDemo
//
//  Created by Zero_D_Saber on 2026/1/21.
//

import Testing
import ZDToolBoxSwift

struct ZDMirrorTests {
    class Animal {
        let name: String
        private let age: Int
        
        init(name: String, age: Int) {
            self.name = name
            self.age = age
        }
    }
    
    class Dog: Animal {
        let sex: String
        
        init(sex: String, name: String, age: Int) {
            self.sex = sex
            super.init(name: name, age: age)
        }
    }
    
    @Test
    func getMirror() {
        let dog = Dog(sex: "M", name: "小狗", age: 1)
        
        let kv = ZDMirror.properties(dog)
        for item in kv {
            print("label: \(item.key), value = \(item.value)")
        }
        #expect(kv.count == 3)
    }
}
