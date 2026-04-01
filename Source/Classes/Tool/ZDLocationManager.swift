//
//  ZDLocationManager.swift
//  Pods
//
//  Created by Zero_D_Saber on 2025/12/8.
//
//  Ref: https://www.vbutko.com/articles/swift-async-await-location-manager/

import CoreLocation
import Combine

// MARK: - Location Provider

@available(iOS 13.0, *)
@MainActor
protocol ZDLocationProvider: AnyObject {
    var authorizationStatus: CLAuthorizationStatus { get }
    var onAuthorizationChange: ((CLAuthorizationStatus) -> Void)? { get set }
    var onLocationUpdate: (([CLLocation]) -> Void)? { get set }
    var onLocationError: ((Error) -> Void)? { get set }

    func requestWhenInUseAuthorization()
    func startUpdatingLocation()
    func stopUpdatingLocation()
    func requestLocation()
}

@available(iOS 13.0, *)
@MainActor
private final class ZDCoreLocationProvider: NSObject, ZDLocationProvider {
    // MARK: Properties

    private let manager = CLLocationManager()

    var onAuthorizationChange: ((CLAuthorizationStatus) -> Void)?
    var onLocationUpdate: (([CLLocation]) -> Void)?
    var onLocationError: ((Error) -> Void)?

    var authorizationStatus: CLAuthorizationStatus {
        if #available(iOS 14.0, *) {
            return manager.authorizationStatus
        }
        return type(of: manager).authorizationStatus()
    }

    // MARK: Lifecycle

    override init() {
        super.init()
        manager.delegate = self
    }

    // MARK: Functions

    func requestWhenInUseAuthorization() {
        manager.requestWhenInUseAuthorization()
    }

    func startUpdatingLocation() {
        manager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
    }

    func requestLocation() {
        manager.requestLocation()
    }
}

@available(iOS 13.0, *)
@MainActor
extension ZDCoreLocationProvider: @MainActor CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        onAuthorizationChange?(authorizationStatus)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        onAuthorizationChange?(status)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        onLocationUpdate?(locations)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        onLocationError?(error)
    }
}

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

    private let locationProvider: any ZDLocationProvider

    // MARK: Lifecycle

    public override init() {
        locationProvider = ZDCoreLocationProvider()
        super.init()
        bindProviderCallbacks()
    }

    init(locationProvider: any ZDLocationProvider) {
        self.locationProvider = locationProvider
        super.init()
        bindProviderCallbacks()
    }
}

@available(iOS 13.0, *)
public extension ZDLocationManager {
    /// Requests "When In Use" location permission when status is `.notDetermined`.
    ///
    /// Example:
    /// ```swift
    /// let manager = ZDLocationManager()
    /// manager.requestPermissionIfNeeded()
    /// ```
    @MainActor
    func requestPermissionIfNeeded() {
        guard currentAuthorizationStatus() == .notDetermined else {
            return
        }

        locationProvider.requestWhenInUseAuthorization()
    }

    /// Requests permission if needed and waits for the first non-`.notDetermined` status.
    ///
    /// - Returns: The latest authorization status.
    ///
    /// Example:
    /// ```swift
    /// let manager = ZDLocationManager()
    /// let status = await manager.requestPermissionIfNeeded()
    /// print(status)
    /// ```
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

@available(iOS 13.0, *)
@MainActor
extension ZDLocationManager {
    /// Fetches one location value via async/await.
    ///
    /// - Returns: The first emitted location after `requestLocation()` is called.
    ///
    /// Example:
    /// ```swift
    /// let manager = ZDLocationManager()
    /// let location = try await manager.detectLocation()
    /// print(location?.coordinate as Any)
    /// ```
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

    /// Starts continuous location updates and exposes them as an async sequence.
    ///
    /// Example:
    /// ```swift
    /// let manager = ZDLocationManager()
    /// let stream = await manager.currentLocationPublisher()
    /// Task {
    ///     for try await location in stream {
    ///         print(location.coordinate)
    ///     }
    /// }
    /// ```
    @available(iOS 15.0, *)
    func currentLocationPublisher() async -> AsyncThrowingPublisher<AnyPublisher<CLLocation, LocationError>> {
        _ = await requestPermissionIfNeeded()

        locationProvider.startUpdatingLocation()

        return currentLocation
            .compactMap { $0 }
            .eraseToAnyPublisher()
            .values
    }

    /// Stops continuous location updates.
    ///
    /// Example:
    /// ```swift
    /// manager.stopLocationUpdates()
    /// ```
    func stopLocationUpdates() {
        locationProvider.stopUpdatingLocation()
    }
}

// MARK: - Private Helpers

@available(iOS 13.0, *)
private extension ZDLocationManager {
    func bindProviderCallbacks() {
        locationProvider.onAuthorizationChange = { [weak self] status in
            self?.currentAuthorization.send(status)
        }
        locationProvider.onLocationUpdate = { [weak self] locations in
            guard let self else { return }
            for location in locations {
                currentLocation.send(location)
            }
        }
        locationProvider.onLocationError = { [weak self] error in
            self?.currentLocation.send(
                completion: .failure(.locationProviderError(error))
            )
        }
        currentAuthorization.send(currentAuthorizationStatus())
    }

    func currentAuthorizationStatus() -> CLAuthorizationStatus {
        locationProvider.authorizationStatus
    }

    static func isAuthorized(_ status: CLAuthorizationStatus) -> Bool {
        status == .authorizedAlways || status == .authorizedWhenInUse
    }
}
