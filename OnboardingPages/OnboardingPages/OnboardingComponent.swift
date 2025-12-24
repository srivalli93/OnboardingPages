//
//  OnboardingComponent.swift
//  OnboardingPages
//
//  Created by Srivalli Kanchibotla on 12/23/25.
//


//
//  OnboardingComponent.swift
//  Onboarding
//
//  Created by Srivalli Kanchibotla on 12/23/25.
//


import UIKit

// Represents the types of UI elements we can stack in a page
public enum OnboardingComponent {
    case title(String)
    case image(UIImage?)
    case body(String)
    case checkbox(title: String, identifier: String, initialState: Bool)
    case radioButtonGroup(title: String, options: [String], identifier: String)
    case primaryButton(String)
}

// Configuration for a single page
public struct OnboardingPageConfig {
    public let id: String
    public let components: [OnboardingComponent]
    public let requiresLocationPermission: Bool

    public init(id: String, components: [OnboardingComponent], requiresLocationPermission: Bool = false) {
        self.id = id
        self.components = components
        self.requiresLocationPermission = requiresLocationPermission
    }
}

public protocol OnboardingDelegate: AnyObject {
    func onboardingRequestLocation()
    func onboardingDidUpdateValue(identifier: String, value: Any)
    func onboardingDidFinish()
}
