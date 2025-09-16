// LocationManager.swift

import Foundation
import CoreLocation

@MainActor
class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    
    private let manager = CLLocationManager()
    private var locationContinuation: CheckedContinuation<CLLocation, Error>?
    
    override private init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func getCurrentLocation() async throws -> CLLocation {
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self = self else { return }
            self.locationContinuation = continuation
            self.manager.requestWhenInUseAuthorization()
            self.manager.startUpdatingLocation()
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // nonisolated 함수 안에서 @MainActor 프로퍼티에 접근하기 위해 Task로 감싸줍니다.
        Task { @MainActor in
            if let location = locations.first {
                self.manager.stopUpdatingLocation()
                locationContinuation?.resume(returning: location)
                locationContinuation = nil
            }
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // nonisolated 함수 안에서 @MainActor 프로퍼티에 접근하기 위해 Task로 감싸줍니다.
        Task { @MainActor in
            self.manager.stopUpdatingLocation()
            locationContinuation?.resume(throwing: error)
            locationContinuation = nil
        }
    }
}
