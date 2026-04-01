//
//  ZDLocationManager.swift
//  Pods
//
//  Created by Zero_D_Saber on 2025/12/8.
//
//  Ref: https://www.vbutko.com/articles/swift-async-await-location-manager/

import CoreLocation
import Combine

// MARK: - ZDLocationManager

@available(iOS 13.0, *)
@MainActor
public final class ZDLocationManager: NSObject {
    // MARK: Nested Types

    enum LocationError: Error {
        case authorizationDenied(CLAuthorizationStatus)
        case locationProviderError(Error)
        case missingOutput
    }

    // MARK: Properties

    private let currentLocation = PassthroughSubject<CLLocation, LocationError>()
    private let currentAuthorization = CurrentValueSubject<CLAuthorizationStatus?, Never>(nil)

    private let locationProvider = CLLocationManager()

    // MARK: Lifecycle

    public override init() {
        super.init()
        locationProvider.delegate = self
        currentAuthorization.send(currentAuthorizationStatus())
    }
}

@available(iOS 13.0, *)
public extension ZDLocationManager {
    @MainActor
    func requestPermissionIfNeeded() {
        guard currentAuthorizationStatus() == .notDetermined else {
            return
        }

        locationProvider.requestWhenInUseAuthorization()
    }

    @discardableResult
    @MainActor
    func requestPermissionIfNeeded() async -> CLAuthorizationStatus {
        guard currentAuthorizationStatus() == .notDetermined else {
            return currentAuthorizationStatus()
        }

        var cancellable: AnyCancellable?
        var didReceiveValue = false

        return await withCheckedContinuation { continuation in
            cancellable =
                currentAuthorization
                    .compactMap { $0 }
                    .sink { permission in
                        guard !didReceiveValue else { return }
                        guard permission != .notDetermined else { return }

                        didReceiveValue = true
                        cancellable?.cancel()
                        continuation.resume(returning: permission)
                    }

            locationProvider.requestWhenInUseAuthorization()
        }
    }
}

// MARK: @MainActor CLLocationManagerDelegate

@available(iOS 13.0, *)
extension ZDLocationManager: @MainActor CLLocationManagerDelegate {
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        currentAuthorization.send(currentAuthorizationStatus())
    }

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        currentAuthorization.send(status)
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            currentLocation.send(location)
        }
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        currentLocation.send(
            completion: .failure(.locationProviderError(error))
        )
    }
}

@available(iOS 13.0, *)
@MainActor
extension ZDLocationManager {
    @available(iOS 15.0, *)
    @discardableResult
    func detectLocation() async throws -> CLLocation? {
        let permission = await requestPermissionIfNeeded()
        guard Self.isAuthorized(permission) else {
            throw LocationError.authorizationDenied(permission)
        }

        var cancellable: AnyCancellable?
        var didReceiveValue = false

        return try await withCheckedThrowingContinuation { continuation in
            cancellable =
                currentLocation
                    .sink(
                        receiveCompletion: { completion in
                            guard !didReceiveValue else { return }

                            didReceiveValue = true
                            cancellable?.cancel()

                            switch completion {
                            case let .failure(error):
                                continuation.resume(throwing: error)
                            case .finished:
                                continuation.resume(throwing: LocationError.missingOutput)
                            }
                        },
                        receiveValue: { location in
                            guard !didReceiveValue else { return }

                            didReceiveValue = true
                            cancellable?.cancel()
                            continuation.resume(returning: location)
                        }
                    )

            locationProvider.requestLocation()
        }
    }

    @available(iOS 15.0, *)
    func currentLocationPublisher() async -> AsyncThrowingPublisher<AnyPublisher<CLLocation, LocationError>> {
        _ = await requestPermissionIfNeeded()

        locationProvider.startUpdatingLocation()

        return currentLocation
            .compactMap { $0 }
            .eraseToAnyPublisher()
            .values
    }

    func stopLocationUpdates() {
        locationProvider.stopUpdatingLocation()
    }
}

// MARK: - Private Helpers

@available(iOS 13.0, *)
private extension ZDLocationManager {
    func currentAuthorizationStatus() -> CLAuthorizationStatus {
        if #available(iOS 14.0, *) {
            return locationProvider.authorizationStatus
        }
        return type(of: locationProvider).authorizationStatus()
    }

    static func isAuthorized(_ status: CLAuthorizationStatus) -> Bool {
        status == .authorizedAlways || status == .authorizedWhenInUse
    }
}
