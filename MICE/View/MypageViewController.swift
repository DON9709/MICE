//
//  MypageViewController.swift
//  MICE
//
//  Created by 이돈혁 on 8/25/25.
//

import UIKit
import Combine

final class MypageViewController: UIViewController {

    private var cancellables = Set<AnyCancellable>()

    private let viewModel = MypageViewModel()

    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        bindViewModel()
    }

    // MARK: - 로그인시
    private func setupView() {
        if viewModel.isLoggedIn {
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

            let profileContainer = UIView()
            profileContainer.translatesAutoresizingMaskIntoConstraints = false
            profileContainer.addSubview(profileImageView)

            NSLayoutConstraint.activate([
                profileImageView.leadingAnchor.constraint(equalTo: profileContainer.leadingAnchor),
                profileImageView.topAnchor.constraint(equalTo: profileContainer.topAnchor),
                profileImageView.bottomAnchor.constraint(equalTo: profileContainer.bottomAnchor),
                profileImageView.widthAnchor.constraint(equalToConstant: 80),
                profileImageView.heightAnchor.constraint(equalToConstant: 80),
                profileContainer.widthAnchor.constraint(equalToConstant: 350)
            ])

            let emailLabel = UILabel()
            emailLabel.translatesAutoresizingMaskIntoConstraints = false
            emailLabel.text = "abc1234@gmail.com"
            emailLabel.textColor = .darkGray
            emailLabel.font = UIFont.systemFont(ofSize: 16)
            emailLabel.textAlignment = .left
            emailLabel.widthAnchor.constraint(equalToConstant: 350).isActive = true

            let stackView = UIStackView(arrangedSubviews: [titleLabel, profileContainer, emailLabel])
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.spacing = 16
            stackView.alignment = .center

            view.addSubview(stackView)

            NSLayoutConstraint.activate([
                stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
                stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
            ])
            let separatorView = UIView()
            separatorView.translatesAutoresizingMaskIntoConstraints = false
            separatorView.backgroundColor = .lightGray // 회색

            view.addSubview(separatorView)
            
            //회색 구분선
            NSLayoutConstraint.activate([
                separatorView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 50),
                separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                separatorView.heightAnchor.constraint(equalToConstant: 1)
            ])
            
            let favoritesButton = UIButton(type: .system)
            favoritesButton.translatesAutoresizingMaskIntoConstraints = false
            favoritesButton.setTitle("찜한 목록", for: .normal)
            favoritesButton.setTitleColor(.black, for: .normal)
            favoritesButton.contentHorizontalAlignment = .leading

            let logoutButton = UIButton(type: .system)
            logoutButton.translatesAutoresizingMaskIntoConstraints = false
            logoutButton.setTitle("로그아웃", for: .normal)
            logoutButton.setTitleColor(.black, for: .normal)
            logoutButton.contentHorizontalAlignment = .leading

            let buttonStackView = UIStackView(arrangedSubviews: [favoritesButton, logoutButton])
            buttonStackView.translatesAutoresizingMaskIntoConstraints = false
            buttonStackView.axis = .vertical
            buttonStackView.spacing = 8
            buttonStackView.alignment = .fill

            view.addSubview(buttonStackView)

            NSLayoutConstraint.activate([
                buttonStackView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 16),
                buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
            ])
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

        let profileContainer = UIView()
        profileContainer.translatesAutoresizingMaskIntoConstraints = false
        profileContainer.addSubview(profileImageView)

        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: profileContainer.leadingAnchor),
            profileImageView.topAnchor.constraint(equalTo: profileContainer.topAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: profileContainer.bottomAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 80),
            profileImageView.heightAnchor.constraint(equalToConstant: 80),
            profileContainer.widthAnchor.constraint(equalToConstant: 350)
        ])

        let loginButton = UIButton(type: .system)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("로그인을 해주세요", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = UIColor(red: 114/255, green: 76/255, blue: 249/255, alpha: 1.0)
        loginButton.layer.cornerRadius = 8
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 350).isActive = true
        loginButton.addTarget(self, action: #selector(handleLoginTapped), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [titleLabel, profileContainer, loginButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .lightGray // 회색

        view.addSubview(separatorView)
        
        //회색 구분선
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 50),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func bindViewModel() {
        viewModel.$isLoggedIn
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.view.subviews.forEach { $0.removeFromSuperview() }
                self.setupView()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - 액션
    @objc private func handleLoginTapped() {
        let loginVC = LogInViewController(launchSource: .mypage)
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion: nil)
    }
}

// Ensure SettingView exists and is a UIViewController subclass
// If not, add a stub here or in its own file.

extension MypageViewController {
    @objc private func handleSettingsTapped() {
        let settingsVC = SettingViewController()
        settingsVC.launchSource = .mypage
        navigationController?.pushViewController(settingsVC, animated: true)
    }
}
