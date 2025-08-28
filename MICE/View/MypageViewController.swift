//
//  MypageViewController.swift
//  MICE
//
//  Created by 이돈혁 on 8/25/25.
//

import UIKit

final class MypageViewController: UIViewController {

    private let viewModel = MypageViewModel()

    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
    }

    // MARK: - Setup
    private func setupView() {
        if viewModel.isLoggedIn {
            // 회원용 UI는 추후 구현
        } else {
            showGuestView()
        }
    }

    // MARK: - Guest View
    private func showGuestView() {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "마이페이지"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.widthAnchor.constraint(equalToConstant: 350).isActive = true

        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.image = UIImage(systemName: "person.crop.circle.fill") // 기본 아이콘
        profileImageView.tintColor = .lightGray
        profileImageView.contentMode = .scaleAspectFit

        let loginButton = UIButton(type: .system)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("로그인을 해주세요", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = .black
        loginButton.layer.cornerRadius = 8
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 350).isActive = true
        loginButton.addTarget(self, action: #selector(handleLoginTapped), for: .touchUpInside)

        let settingsLabel = UILabel()
        settingsLabel.translatesAutoresizingMaskIntoConstraints = false
        settingsLabel.text = "설정"
        settingsLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        settingsLabel.textColor = .darkGray
        settingsLabel.textAlignment = .left

        let stackView = UIStackView(arrangedSubviews: [titleLabel, profileImageView, loginButton, settingsLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 80),
            profileImageView.heightAnchor.constraint(equalToConstant: 80),

            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }

    // MARK: - 액션
    @objc private func handleLoginTapped() {
        let loginVC = LogInViewController()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion: nil)
    }
}
