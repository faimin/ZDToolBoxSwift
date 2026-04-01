//
//  ZDNSObjectCombineTests.swift
//  ZDToolBoxSwiftDemoTests
//
//  Created by Zero_D_Saber on 2026/3/31.
//

import Combine
import CoreLocation
import Foundation
import Testing
@testable import ZDToolBoxSwift

struct NSObjectCombineTests {

    @Test("Test dispose bag persistence across multiple accesses")
	func testDisposeBagPersistence() {
        let object = NSObject()
        let cancellable = AnyCancellable {}
        
        // Initial state
        #expect(object.zd.disposeBag.isEmpty)
        
        // Store
        object.zd.store(cancellable)
        #expect(object.zd.disposeBag.count == 1)
        
        // Verify persistent through multiple accesses
        let bag = object.zd.disposeBag
        #expect(bag.count == 1)
    }

    @Test("Test cancelling all subscriptions manually") 
    func testCancelAllCancellables() {
        let object = NSObject()
        var cancelledCount = 0
        
        let c1 = AnyCancellable { cancelledCount += 1 }
        let c2 = AnyCancellable { cancelledCount += 1 }
        
        object.zd.store(c1)
        object.zd.store(c2)
        #expect(object.zd.disposeBag.count == 2)
        
        object.zd.cancelAllCancellables()
        #expect(object.zd.disposeBag.isEmpty)
        #expect(cancelledCount == 2)
    }

    @Test("Test AnyCancellable.store(in:) extension") 
    func testAnyCancellableStoreInObject() {
        let object = NSObject()
        var cancelled = false
        let cancellable = AnyCancellable { cancelled = true }
        
        cancellable.store(in: object)
        #expect(object.zd.disposeBag.count == 1)
        
        object.zd.cancelAllCancellables()
        #expect(cancelled == true)
    }

    @Test("Test Publisher.sink(in:) convenience extension") 
    func testPublisherSinkInObject() {
        let object = NSObject()
        let subject = PassthroughSubject<Int, Never>()
        var receivedValue: Int?
        
        // Using convenience extension
        subject.sink(in: object) { value in
            receivedValue = value
        }
        
        subject.send(10)
        #expect(receivedValue == 10)
        #expect(object.zd.disposeBag.count == 1)
        
        object.zd.cancelAllCancellables()
        subject.send(20)
        #expect(receivedValue == 10) // Subscription should have been cancelled
    }
    
    @Test("Test Publisher.zd.store(in:) extension") 
    func testPublisherStoreInObject() {
        let object = NSObject()
        let subject = PassthroughSubject<String, Never>()
        var receivedValues: [String] = []
        
        // Using zd namespace extension
		subject.zd.store(in: object) { value in
            receivedValues.append(value)
        }
        
        subject.send("A")
        subject.send("B")
        
        #expect(receivedValues == ["A", "B"])
        #expect(object.zd.disposeBag.count == 1)
    }
    
    @Test("Test multiple subscriptions generate cancellables in one object")
    func testMultipleSubscriptionsInOneObject() {
        let object = NSObject()
        let intSubject = PassthroughSubject<Int, Never>()
        let stringSubject = PassthroughSubject<String, Never>()
        
        var intValues: [Int] = []
        var stringValues: [String] = []
        
        let c1 = intSubject.sink(in: object) { value in
            intValues.append(value)
        }
        let c2 = stringSubject.sink(in: object) { value in
            stringValues.append(value)
        }
        
        #expect(ObjectIdentifier(c1) != ObjectIdentifier(c2))
        #expect(object.zd.disposeBag.count == 2)
        
        intSubject.send(1)
        stringSubject.send("A")
        intSubject.send(2)
        
        #expect(intValues == [1, 2])
        #expect(stringValues == ["A"])
        
        object.zd.cancelAllCancellables()
        
        intSubject.send(3)
        stringSubject.send("B")
        
        #expect(intValues == [1, 2])
        #expect(stringValues == ["A"])
    }

    @Test("Test thread-safe insertion into dispose bag") 
    func testThreadSafety() async {
        nonisolated(unsafe) let object = NSObject()
        let iterations = 1000
        
        await withTaskGroup(of: Void.self) { group in
            for _ in 0..<iterations {
                group.addTask {
                    let cancellable = AnyCancellable {}
                    object.zd.store(cancellable)
                }
            }
        }
        
        // We use .count which is also synchronized in our implementation
        #expect(object.zd.disposeBag.count == iterations)
    }
    
    @Test("Test automatic cancellation upon object deallocation") 
    func testDeallocationCancellation() {
        var cancelled = false
        var object: NSObject? = NSObject()
        let cancellable = AnyCancellable { cancelled = true }
        
        cancellable.store(in: object!)
        
        // When object is deallocated, the associated box should be deallocated, 
        // which in turn should drop the Set of AnyCancellable, triggering cancellation.
        object = nil
        
        #expect(cancelled == true)
    }

    @Test("AES round-trip should decode from Base64 ciphertext")
    func testAesEncryptDecryptRoundTrip() throws {
        let plaintext = "hello-zd-toolbox"
        let key = "1234567890123456"

        let encrypted = try ZDCrypto.aesEncrypt(plaintext: plaintext, key: key)
        let decrypted = try ZDCrypto.aesDecrypt(encodedText: encrypted, key: key)

        #expect(decrypted == plaintext)
    }
}

// MARK: - ZDLocationManager Tests

@available(iOS 15.0, *)
@MainActor
private final class FakeLocationProvider: ZDLocationProvider {
    var authorizationStatus: CLAuthorizationStatus
    var onAuthorizationChange: ((CLAuthorizationStatus) -> Void)?
    var onLocationUpdate: (([CLLocation]) -> Void)?
    var onLocationError: ((Error) -> Void)?

    var didRequestWhenInUseAuthorization = false
    var didStartUpdatingLocation = false
    var didStopUpdatingLocation = false
    var didRequestLocation = false

    var authorizationAfterRequest: CLAuthorizationStatus?
    var locationsOnRequest: [CLLocation] = []
    var errorOnRequest: Error?

    init(status: CLAuthorizationStatus) {
        authorizationStatus = status
    }

    func requestWhenInUseAuthorization() {
        didRequestWhenInUseAuthorization = true
        guard let status = authorizationAfterRequest else { return }
        authorizationStatus = status
        onAuthorizationChange?(status)
    }

    func startUpdatingLocation() {
        didStartUpdatingLocation = true
    }

    func stopUpdatingLocation() {
        didStopUpdatingLocation = true
    }

    func requestLocation() {
        didRequestLocation = true
        if let error = errorOnRequest {
            onLocationError?(error)
            return
        }
        if !locationsOnRequest.isEmpty {
            onLocationUpdate?(locationsOnRequest)
        }
    }
}

@available(iOS 15.0, *)
@MainActor
struct ZDLocationManagerTests {
    @Test("requestPermissionIfNeeded async should return updated status")
    func requestPermissionIfNeededAsync() async {
        let provider = FakeLocationProvider(status: .notDetermined)
        provider.authorizationAfterRequest = .authorizedWhenInUse
        let sut = ZDLocationManager(locationProvider: provider)

        let status = await sut.requestPermissionIfNeeded()

        #expect(provider.didRequestWhenInUseAuthorization == true)
        #expect(status == .authorizedWhenInUse)
    }

    @Test("detectLocation should return first emitted location")
    func detectLocationReturnsFirstLocation() async throws {
        let provider = FakeLocationProvider(status: .authorizedWhenInUse)
        let first = CLLocation(latitude: 30.0, longitude: 120.0)
        let second = CLLocation(latitude: 31.0, longitude: 121.0)
        provider.locationsOnRequest = [first, second]
        let sut = ZDLocationManager(locationProvider: provider)

        let location = try await sut.detectLocation()

        #expect(provider.didRequestLocation == true)
        #expect(location?.coordinate.latitude == first.coordinate.latitude)
        #expect(location?.coordinate.longitude == first.coordinate.longitude)
    }

    @Test("detectLocation should throw authorizationDenied when permission is denied")
    func detectLocationDenied() async {
        let provider = FakeLocationProvider(status: .denied)
        let sut = ZDLocationManager(locationProvider: provider)

        do {
            _ = try await sut.detectLocation()
            Issue.record("Expected detectLocation() to throw authorizationDenied")
        } catch let error as ZDLocationManager.LocationError {
            switch error {
            case let .authorizationDenied(status):
                #expect(status == .denied)
            default:
                Issue.record("Expected authorizationDenied, got \(error)")
            }
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }

    @Test("currentLocationPublisher should start and stop updates")
    func currentLocationPublisherStartStop() async {
        let provider = FakeLocationProvider(status: .authorizedWhenInUse)
        let sut = ZDLocationManager(locationProvider: provider)

        let stream = await sut.currentLocationPublisher()
        #expect(provider.didStartUpdatingLocation == true)

        let expected = CLLocation(latitude: 22.0, longitude: 113.0)
        let reader = Task { () -> CLLocation? in
            do {
                for try await location in stream {
                    return location
                }
            } catch {
                return nil
            }
            return nil
        }

        provider.onLocationUpdate?([expected])
        let location = await reader.value
        #expect(location?.coordinate.latitude == expected.coordinate.latitude)
        #expect(location?.coordinate.longitude == expected.coordinate.longitude)

        sut.stopLocationUpdates()
        #expect(provider.didStopUpdatingLocation == true)
    }
}
