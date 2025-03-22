//
//  LocationManager.swift
//  Pinit
//
//  Created by 안정흠 on 3/14/25.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject {
    private let manager = CLLocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        
        // 배터리에 맞게 권장되는 최적의 정확도
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func getCurrentUserLocation() -> CLLocationCoordinate2D? {
        guard manager.authorizationStatus != .denied || manager.authorizationStatus != .restricted else { return nil }
        guard let location = manager.location?.coordinate else { return nil }
        return location
    }
    
    func requestAuthorizationIfNeeded() {
        let status = manager.authorizationStatus
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            print("Access to location denied or restricted.")
        default:
            break
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            // 위치 업데이트
            manager.startUpdatingLocation()
        case .denied, .restricted:
            print("Denied")
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
//        print(location.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("CLLocationManager: DidFailWithError")
    }
}
