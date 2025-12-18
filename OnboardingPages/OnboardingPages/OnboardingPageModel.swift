//
//  OnboardingPageModel.swift
//  OnboardingPages
//
//  Created by Srivalli Kanchibotla on 12/17/25.
//


// MARK: - Onboarding Models

import UIKit
import CoreLocation

struct OnboardingPageModel {
    let id: String
    let components: [OnboardingComponent]
    let requiresLocationPermission: Bool
}

// MARK: UI Components
enum OnboardingComponent {
    case title(String)
    case body(String)
    case image(UIImage)
    case checkbox(title: String, isRequired: Bool)
    case radioGroup(title: String, options: [String])
    case submitButton(title: String)
    case dismissButton(title: String)
}

// MARK: - Onboarding Page View Controller
final class OnboardingPageViewController: UIPageViewController {

    private(set) var pages: [OnboardingPageModel]
    private var viewControllersCache: [UIViewController] = []

    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPageIndicatorTintColor = .systemGreen
        pc.pageIndicatorTintColor = .systemGreen.withAlphaComponent(0.3)
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()

    init(pages: [OnboardingPageModel]) {
        self.pages = pages
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        setup()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setup() {
        dataSource = self
        delegate = self
        viewControllersCache = pages.map { makePageVC(from: $0) }
        setViewControllers([viewControllersCache.first!], direction: .forward, animated: false)
        setupPageControl()
    }

    private func setupPageControl() {
        view.addSubview(pageControl)
        pageControl.numberOfPages = pages.count
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func makePageVC(from model: OnboardingPageModel) -> UIViewController {
        let vc = UIViewController()
        let contentView = OnboardingContentView(components: model.components)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        contentView.onSubmitTapped = { [weak self] in
            self?.handleContinue(from: model)
        }

        vc.view.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: vc.view.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor)
        ])
        return vc
    }

    private func handleContinue(from page: OnboardingPageModel) {
        if page.requiresLocationPermission {
            NotificationCenter.default.addObserver(self, selector: #selector(locationAuthChanged), name: .locationAuthorizationChanged, object: nil)
            
            // ----- Debug testing code -----
            // Use this for testing onboarding location flow without system prompt
//            DebugLocationTester.simulatedResult = .deny
//            DebugLocationTester.requestAuthorization()
            
            // ----- Production code -----
            LocationPermissionRequester.request()
        } else {
            goToNextPage()
        }
    }

    @objc private func locationAuthChanged() {
        NotificationCenter.default.removeObserver(self, name: .locationAuthorizationChanged, object: nil)
        
        // ----- Debug testing code -----
//        DebugLocationTester.simulatedResult = .deny
//         let status = DebugLocationTester.authorizationStatus()
        
        // ----- Production code -----
        let status = CLLocationManager.authorizationStatus()
        
        if status == .denied || status == .restricted {
            injectDeniedPage()
        }
        goToNextPage()
    }

    private func injectDeniedPage() {
        let deniedPage = OnboardingPageModel(
            id: "locationDenied",
            components: [
                .title("Location Needed"),
                .body("Please enable location in Settings to get the best experience."),
                .submitButton(title: "Continue")
            ],
            requiresLocationPermission: false
        )
        pages.insert(deniedPage, at: min(currentIndex() + 1, pages.count))
        viewControllersCache = pages.map { makePageVC(from: $0) }
        pageControl.numberOfPages = pages.count
    }

    private func goToNextPage() {
        let index = currentIndex()
        guard index + 1 < viewControllersCache.count else { return }
        setViewControllers([viewControllersCache[index + 1]], direction: .forward, animated: true)
        pageControl.currentPage = index + 1
    }

    private func currentIndex() -> Int {
        guard let vc = viewControllers?.first else { return 0 }
        return viewControllersCache.firstIndex(of: vc) ?? 0
    }
}

// MARK: - PageViewController Delegates
extension OnboardingPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = viewControllersCache.firstIndex(of: viewController) ?? 0
        return index > 0 ? viewControllersCache[index - 1] : nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = viewControllersCache.firstIndex(of: viewController) ?? 0
        return index + 1 < viewControllersCache.count ? viewControllersCache[index + 1] : nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed { pageControl.currentPage = currentIndex() }
    }
}


// MARK: - Location Hook
extension Notification.Name {
    static let locationAuthorizationChanged = Notification.Name("locationAuthorizationChanged")
}

// This type is expected to exist in the host app
enum LocationPermissionRequester {
    static func request() {
        // Call into existing CLLocationManager flow
    }
}
