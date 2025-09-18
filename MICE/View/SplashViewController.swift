//
//  SplashViewController.swift
//  MICE
//
//  Created by 이돈혁 on 9/18/25.
//

import UIKit

class SplashViewController: UIViewController {
    private let label: UILabel = {
        let label = UILabel()
        label.text = "로딩 중..."
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.startAnimating()
        return indicator
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(activityIndicator)
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1.0) {
            self.label.alpha = 1.0
        }
    }
}
