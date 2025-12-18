//
//  DebugLocationTester.swift
//  OnboardingPages
//
//  Created by Srivalli Kanchibotla on 12/17/25.
//


import CoreLocation

final class DebugLocationTester {

    enum Result {
        case allow
        case deny
    }

    /// Change this before presenting onboarding
    static var simulatedResult: Result = .allow

    /// Call this instead of the real CLLocationManager request
    static func requestAuthorization() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            NotificationCenter.default.post(
                name: .locationAuthorizationChanged,
                object: nil
            )
        }
    }

    /// Read this when onboarding checks status
    static func authorizationStatus() -> CLAuthorizationStatus {
        switch simulatedResult {
        case .allow:
            return .authorizedWhenInUse
        case .deny:
            return .denied
        }
    }
}
