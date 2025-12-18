//
//  OnboardingContentView.swift
//  OnboardingPages
//
//  Created by Srivalli Kanchibotla on 12/17/25.
//


import UIKit

final class OnboardingContentView: UIView {

    private let contentStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 16
        sv.alignment = .fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    var onSubmitTapped: (() -> Void)?
    var onDismissTapped: (() -> Void)?

    init(components: [OnboardingComponent]) {
        super.init(frame: .zero)
        setupLayout()
        buildComponents(components)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 32),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            contentStackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -32)
        ])
    }

    private func buildComponents(_ components: [OnboardingComponent]) {
        components.forEach { component in
            let view = makeView(for: component)
            contentStackView.addArrangedSubview(view)
        }
    }

    private func makeView(for component: OnboardingComponent) -> UIView {
        switch component {
        case .title(let text):
            let label = UILabel()
            label.font = .preferredFont(forTextStyle: .largeTitle)
            label.adjustsFontForContentSizeCategory = true
            label.numberOfLines = 0
            label.text = text
            return label

        case .body(let text):
            let label = UILabel()
            label.font = .preferredFont(forTextStyle: .body)
            label.adjustsFontForContentSizeCategory = true
            label.numberOfLines = 0
            label.text = text
            return label

        case .image(let image):
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
            return imageView

        case .checkbox(let title, _):
            let button = UIButton(type: .system)
            button.setTitle("☐ \(title)", for: .normal)
            button.contentHorizontalAlignment = .leading
            return button

        case .radioGroup(let title, let options):
            let stack = UIStackView()
            stack.axis = .vertical
            stack.spacing = 8

            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = .preferredFont(forTextStyle: .headline)
            titleLabel.adjustsFontForContentSizeCategory = true
            stack.addArrangedSubview(titleLabel)

            options.forEach { option in
                let button = UIButton(type: .system)
                button.setTitle("◯ \(option)", for: .normal)
                button.contentHorizontalAlignment = .leading
                stack.addArrangedSubview(button)
            }

            return stack

        case .submitButton(let title):
            let button = UIButton(type: .system)
            button.backgroundColor = .systemGreen
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 10
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true
            button.setTitle(title, for: .normal)
            button.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
            return button

        case .dismissButton(let title):
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
            return button
        }
    }

    @objc private func submitTapped() {
        onSubmitTapped?()
    }

    @objc private func dismissTapped() {
        onDismissTapped?()
    }
}
