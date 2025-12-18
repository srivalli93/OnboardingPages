//
//  ViewController.swift
//  OnboardingPages
//
//  Created by Srivalli Kanchibotla on 12/17/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.


    }
    
    override func viewDidAppear(_ animated: Bool) {
        let pages: [OnboardingPageModel] = [
            OnboardingPageModel(
                id: "welcome",
                components: [
                    .title("Welcome"),
                    .body("Let’s get started"),
                    .submitButton(title: "Continue")
                ],
                requiresLocationPermission: false
            ),
            OnboardingPageModel(
                id: "location",
                components: [
                    .title("Enable Location"),
                    .body("We use location to improve results"),
                    .submitButton(title: "Allow Location")
                ],
                requiresLocationPermission: true
            )
        ]

        let onboardingVC = OnboardingPageViewController(pages: pages)

        // MARK: - Sheet configuration
        onboardingVC.modalPresentationStyle = .pageSheet

        if let sheet = onboardingVC.sheetPresentationController {
            sheet.detents = [
                .large()   // Full-height onboarding (recommended)
                // .medium() // Optional if you want partial height
            ]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 24
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }

        present(onboardingVC, animated: true)
    }
    
}

