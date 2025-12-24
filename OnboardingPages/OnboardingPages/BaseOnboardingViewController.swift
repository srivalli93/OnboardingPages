//
//  BaseOnboardingViewController.swift
//  OnboardingPages
//
//  Created by Srivalli Kanchibotla on 12/23/25.
//


//
//  BaseOnboardingViewController.swift
//  Onboarding
//
//  Created by Srivalli Kanchibotla on 12/23/25.
//


import UIKit

public class BaseOnboardingViewController: UIPageViewController {
    
    public weak var onboardingDelegate: OnboardingDelegate?
    private var pages: [OnboardingPageConfig]
    private var orderedViewControllers: [UIViewController] = []

    public init(pages: [OnboardingPageConfig], delegate: OnboardingDelegate) {
        self.pages = pages
        self.onboardingDelegate = delegate
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViewControllers()
        
        if let firstVC = orderedViewControllers.first {
            setViewControllers([firstVC], direction: .forward, animated: true)
        }
    }

    private func setupViewControllers() {
        orderedViewControllers = pages.map { config in
            let contentVC = OnboardingContentViewController(config: config)
            contentVC.delegate = self.onboardingDelegate
            
            // Handle the button tap to advance or request permission
            contentVC.onActionTriggered = { [weak self] in
                if config.requiresLocationPermission {
                    self?.onboardingDelegate?.onboardingRequestLocation()
                } else {
                    self?.advancePage()
                }
            }
            return contentVC
        }
    }

    public func advancePage() {
        guard let currentVC = viewControllers?.first,
              let nextVC = dataSource?.pageViewController(self, viewControllerAfter: currentVC) else {
            onboardingDelegate?.onboardingDidFinish()
            return
        }
        setViewControllers([nextVC], direction: .forward, animated: true)
    }
}

extension BaseOnboardingViewController: UIPageViewControllerDataSource {
    public func pageViewController(_ pvc: UIPageViewController, viewControllerBefore vc: UIViewController) -> UIViewController? {
        guard let index = orderedViewControllers.firstIndex(of: vc), index > 0 else { return nil }
        return orderedViewControllers[index - 1]
    }
    
    public func pageViewController(_ pvc: UIPageViewController, viewControllerAfter vc: UIViewController) -> UIViewController? {
        guard let index = orderedViewControllers.firstIndex(of: vc), index < orderedViewControllers.count - 1 else { return nil }
        return orderedViewControllers[index + 1]
    }
}
