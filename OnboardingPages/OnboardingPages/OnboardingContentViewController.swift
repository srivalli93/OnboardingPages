//
//  OnboardingContentViewController.swift
//  OnboardingPages
//
//  Created by Srivalli Kanchibotla on 12/23/25.
//


//
//  MTOnboardingContentViewController.swift
//  Onboarding
//
//  Created by Srivalli Kanchibotla on 12/23/25.
//


// Shared Module
import UIKit

public class OnboardingContentViewController: UIViewController {
    var onActionTriggered: (() -> Void)?
    weak var delegate: OnboardingDelegate?
    
    private let config: OnboardingPageConfig
    private let stackView = UIStackView()
    private let scrollView = UIScrollView()

    public init(config: OnboardingPageConfig) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        renderComponents()
    }

    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    private func renderComponents() {
        config.components.forEach { component in
            switch component {
            case .title(let text):
                addLabel(text: text, style: .headline)
            case .image(let img):
                addImage(img)
            case .body(let text):
                addLabel(text: text, style: .body)
            case .checkbox(let title, let id, let state):
                addCheckbox(title: title, id: id, initialState: state)
            case .radioButtonGroup(let title, let options, let id):
                addRadioGroup(title: title, options: options, id: id)
            case .primaryButton(let title):
                addPrimaryButton(title: title)
            }
        }
    }

    // MARK: - Component Helpers
    
    private func addLabel(text: String, style: UIFont.TextStyle) {
        let label = UILabel()
        label.text = text
        label.font = .preferredFont(forTextStyle: style)
        label.numberOfLines = 0
        label.textAlignment = .center
        stackView.addArrangedSubview(label)
    }

    private func addImage(_ img: UIImage?) {
        let iv = UIImageView(image: img)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.heightAnchor.constraint(equalToConstant: 180).isActive = true
        stackView.addArrangedSubview(iv)
    }

    private func addCheckbox(title: String, id: String, initialState: Bool) {
        let button = UIButton(configuration: .plain())
        var state = initialState
        
        let updateUI = { (btn: UIButton, s: Bool) in
            btn.setTitle("\(s ? "☑️" : "⬜️") \(title)", for: .normal)
        }
        
        updateUI(button, state)
        button.addAction(UIAction { [weak self] _ in
            state.toggle()
            updateUI(button, state)
            self?.delegate?.onboardingDidUpdateValue(identifier: id, value: state)
        }, for: .touchUpInside)
        
        stackView.addArrangedSubview(button)
    }

    private func addRadioGroup(title: String, options: [String], id: String) {
        if !title.isEmpty { addLabel(text: title, style: .subheadline) }
        
        options.enumerated().forEach { index, optionTitle in
            let btn = UIButton(configuration: .gray())
            btn.setTitle(optionTitle, for: .normal)
            btn.addAction(UIAction { [weak self] _ in
                // In a production app, you'd handle the visual "selected" state for all buttons in group
                self?.delegate?.onboardingDidUpdateValue(identifier: id, value: index)
            }, for: .touchUpInside)
            stackView.addArrangedSubview(btn)
        }
    }

    private func addPrimaryButton(title: String) {
        let btn = UIButton(configuration: .filled())
        btn.setTitle(title, for: .normal)
        btn.addAction(UIAction { [weak self] _ in
            self?.onActionTriggered?()
        }, for: .touchUpInside)
        stackView.addArrangedSubview(btn)
    }
}
