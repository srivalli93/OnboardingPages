//
//  ViewController.swift
//  OnboardingPages
//
//  Created by Srivalli Kanchibotla on 12/17/25.
//

import UIKit


class TestViewController: OnboardingDelegate {
        func setupAndPresentTutorialsIfNecessary() {
                let pages = [
                    OnboardingPageConfig(id: "title1", components: [
                        .title("test"),
                        .image(UIImage(systemSymbol: .car)),
                        .body("test"),
                        .checkbox(title: "test", identifier: "test", initialState: true),
                        .primaryButton("test")
                    ]),
                    OnboardingPageConfig(id: "test1", components: [
                        .title("test1"),
                        .image(UIImage(systemSymbol: .speedometer)),
                        .radioButtonGroup(title: "Select Unit", options: ["test1", "test1"], identifier: "test1"),
                        .primaryButton("test1")
                    ]),
                    OnboardingPageConfig(id: "test2", components: [
                        .title("test2"),
                        .image(UIImage(systemSymbol: .mappinAndEllipse)),
                        .body("test2"),
                        .primaryButton("test2")
                    ], requiresLocationPermission: true)
                ]

                let onboardingVC = BaseOnboardingViewController(pages: pages, delegate: self)
                let nav = UINavigationController(rootViewController: onboardingVC)
                nav.modalPresentationStyle = .pageSheet
                nav.isModalInPresentation = true
                
                self.present(nav, animated: true)
                self.showTutorials = false
            }

            // MARK: - OnboardingDelegate Implementation

            func onboardingRequestLocation() {
                // Hand-off: Main controller handles actual system prompt
                self.requestLocation()
                // Assuming your requestLocation handles the prompt, we dismiss the onboarding
                onboardingDidFinish()
            }

            func onboardingDidUpdateValue(identifier: String, value: Any) {
                switch identifier {
                case "test2":
                    if let index = value as? Int {
                        let unit = index == 0 ? L10n.mtMiles : L10n.mtKilometers
                        self.updateUnit(to: unit)
                    }
                case "test1":
                    if let dontShow = value as? Bool {
                        // Defaults.standard.hideSafetyTutorial = dontShow
                    }
                default: break
                }
            }

            func onboardingDidFinish() {
                self.dismiss(animated: true) { [weak self] in
                    guard let self = self else { return }
//                    self.enableLocation()
//                    self.detetminewarningalert()
                }
            }
        }
