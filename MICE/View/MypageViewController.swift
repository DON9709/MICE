//
//  MypageViewController.swift
//  MICE
//
//  Created by 이돈혁 on 8/25/25.
//

import UIKit
import Combine
import Kingfisher

final class MypageViewController: UIViewController {
    
    let stampImageDataManager = StampImageDataManager.shared

    private var cancellables = Set<AnyCancellable>()

    private let viewModel = MypageViewModel()

    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
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
            
            //최근획득스탬프1
            let recentlyGetStamp1 = UIImageView()
            Task {
                let firstStamp = await StampImageDataManager.shared.getAcquiredFirstStampImageUrl()
                //헤더스탬프 1
                if let urlString = firstStamp?.stampimg, let url = URL(string: urlString) {
                    recentlyGetStamp1.kf.setImage(with: url, options: [
                        .imageModifier(AnyImageModifier { image in
                            image.withRenderingMode(.alwaysTemplate)
                        })
                    ])
                    recentlyGetStamp1.tintColor = firstStamp?.getTint()
                }
            }
            
            recentlyGetStamp1.translatesAutoresizingMaskIntoConstraints = false
            recentlyGetStamp1.contentMode = .scaleAspectFill
            recentlyGetStamp1.layer.cornerRadius = 40
            recentlyGetStamp1.clipsToBounds = true
            recentlyGetStamp1.backgroundColor = .white
                
            //최근획득스탬프2
            let recentlyGetStamp2 = UIImageView()
            //헤더스탬프 2
            Task {
                let secondStamp = await StampImageDataManager.shared.getAcquiredSecondStampImageUrl()
                if let urlString = secondStamp?.stampimg, let url = URL(string: urlString) {
                    recentlyGetStamp2.kf.setImage(with: url, options: [
                        .imageModifier(AnyImageModifier { image in
                            image.withRenderingMode(.alwaysTemplate)
                        })
                    ])
                    recentlyGetStamp2.tintColor = secondStamp?.getTint()
                }
            }
            recentlyGetStamp2.translatesAutoresizingMaskIntoConstraints = false
            recentlyGetStamp2.image = UIImage(named: "Mystery")
            recentlyGetStamp2.contentMode = .scaleAspectFit
            recentlyGetStamp2.layer.cornerRadius = 40
            recentlyGetStamp2.clipsToBounds = true
            recentlyGetStamp2.backgroundColor = .white
            
            //최근획득스탬프3
            let recentlyGetStamp3 = UIImageView()
            //헤더스탬프 3
            Task {
                let thirdStamp = await StampImageDataManager.shared.getAcquiredThirdStampImageUrl()
                if let urlString = thirdStamp?.stampimg, let url = URL(string: urlString) {
                    recentlyGetStamp3.kf.setImage(with: url, options: [
                        .imageModifier(AnyImageModifier { image in
                            image.withRenderingMode(.alwaysTemplate)
                        })
                    ])
                    recentlyGetStamp3.tintColor = thirdStamp?.getTint()
                }
            }
            recentlyGetStamp3.translatesAutoresizingMaskIntoConstraints = false
            recentlyGetStamp3.image = UIImage(named: "Mystery")
            recentlyGetStamp3.contentMode = .scaleAspectFit
            recentlyGetStamp3.layer.cornerRadius = 40
            recentlyGetStamp3.clipsToBounds = true
            recentlyGetStamp3.backgroundColor = .white
            
            let profileContainer = UIView()
            profileContainer.translatesAutoresizingMaskIntoConstraints = false
            profileContainer.addSubview(recentlyGetStamp3)
            profileContainer.addSubview(recentlyGetStamp2)
            profileContainer.addSubview(recentlyGetStamp1)

            NSLayoutConstraint.activate([
                recentlyGetStamp3.leadingAnchor.constraint(equalTo: recentlyGetStamp2.centerXAnchor),
                recentlyGetStamp3.topAnchor.constraint(equalTo: profileContainer.topAnchor),
                recentlyGetStamp3.bottomAnchor.constraint(equalTo: profileContainer.bottomAnchor),
                recentlyGetStamp3.widthAnchor.constraint(equalToConstant: 80),
                recentlyGetStamp3.heightAnchor.constraint(equalToConstant: 80),
                recentlyGetStamp2.leadingAnchor.constraint(equalTo: recentlyGetStamp1.centerXAnchor),
                recentlyGetStamp2.topAnchor.constraint(equalTo: profileContainer.topAnchor),
                recentlyGetStamp2.bottomAnchor.constraint(equalTo: profileContainer.bottomAnchor),
                recentlyGetStamp2.widthAnchor.constraint(equalToConstant: 80),
                recentlyGetStamp2.heightAnchor.constraint(equalToConstant: 80),
                recentlyGetStamp1.leadingAnchor.constraint(equalTo: profileContainer.leadingAnchor),
                recentlyGetStamp1.topAnchor.constraint(equalTo: profileContainer.topAnchor),
                recentlyGetStamp1.bottomAnchor.constraint(equalTo: profileContainer.bottomAnchor),
                recentlyGetStamp1.widthAnchor.constraint(equalToConstant: 80),
                recentlyGetStamp1.heightAnchor.constraint(equalToConstant: 80),
                profileContainer.widthAnchor.constraint(equalToConstant: 350)
            ])
            
            view.addSubview(profileContainer)

            let emailLabel = UILabel()
            emailLabel.translatesAutoresizingMaskIntoConstraints = false
            emailLabel.text = viewModel.email ?? "  "
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
            favoritesButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            favoritesButton.addTarget(self, action: #selector(handleFavoritesTapped), for: .touchUpInside)

            let logoutButton = UIButton(type: .system)
            logoutButton.translatesAutoresizingMaskIntoConstraints = false
            logoutButton.setTitle("로그아웃", for: .normal)
            logoutButton.setTitleColor(.black, for: .normal)
            logoutButton.contentHorizontalAlignment = .leading
            logoutButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            logoutButton.addTarget(self, action: #selector(handleLogoutTapped), for: .touchUpInside)
            
            let deleteAccountButton = UIButton(type: .system)
            deleteAccountButton.translatesAutoresizingMaskIntoConstraints = false
            deleteAccountButton.setTitle("회원 탈퇴", for: .normal)
            deleteAccountButton.setTitleColor(.black, for: .normal)
            deleteAccountButton.titleLabel?.font = UIFont.systemFont(ofSize: 11)
            deleteAccountButton.contentHorizontalAlignment = .center

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
            
            view.addSubview(deleteAccountButton)
            NSLayoutConstraint.activate([
                deleteAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                deleteAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
                deleteAccountButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
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
        
        //최근획득스탬프1
        let recentlyGetStamp1 = UIImageView()
        recentlyGetStamp1.translatesAutoresizingMaskIntoConstraints = false
        recentlyGetStamp1.image = UIImage(named: "Mystery")
        recentlyGetStamp1.contentMode = .scaleAspectFit
        recentlyGetStamp1.layer.cornerRadius = 40
        recentlyGetStamp1.clipsToBounds = true
        recentlyGetStamp1.backgroundColor = .white
            
        //최근획득스탬프2
        let recentlyGetStamp2 = UIImageView()
        recentlyGetStamp2.translatesAutoresizingMaskIntoConstraints = false
        recentlyGetStamp2.image = UIImage(named: "Mystery")
        recentlyGetStamp2.contentMode = .scaleAspectFit
        recentlyGetStamp2.layer.cornerRadius = 40
        recentlyGetStamp2.clipsToBounds = true
        recentlyGetStamp2.backgroundColor = .white
        
        //최근획득스탬프3
        let recentlyGetStamp3 = UIImageView()
        recentlyGetStamp3.translatesAutoresizingMaskIntoConstraints = false
        recentlyGetStamp3.image = UIImage(named: "Mystery")
        recentlyGetStamp3.contentMode = .scaleAspectFit
        recentlyGetStamp3.layer.cornerRadius = 40
        recentlyGetStamp3.clipsToBounds = true
        recentlyGetStamp3.backgroundColor = .white

        let profileContainer = UIView()
        profileContainer.translatesAutoresizingMaskIntoConstraints = false
        profileContainer.addSubview(recentlyGetStamp3)
        profileContainer.addSubview(recentlyGetStamp2)
        profileContainer.addSubview(recentlyGetStamp1)

        NSLayoutConstraint.activate([
            recentlyGetStamp3.leadingAnchor.constraint(equalTo: recentlyGetStamp2.centerXAnchor),
            recentlyGetStamp3.topAnchor.constraint(equalTo: profileContainer.topAnchor),
            recentlyGetStamp3.bottomAnchor.constraint(equalTo: profileContainer.bottomAnchor),
            recentlyGetStamp3.widthAnchor.constraint(equalToConstant: 80),
            recentlyGetStamp3.heightAnchor.constraint(equalToConstant: 80),
            recentlyGetStamp2.leadingAnchor.constraint(equalTo: recentlyGetStamp1.centerXAnchor),
            recentlyGetStamp2.topAnchor.constraint(equalTo: profileContainer.topAnchor),
            recentlyGetStamp2.bottomAnchor.constraint(equalTo: profileContainer.bottomAnchor),
            recentlyGetStamp2.widthAnchor.constraint(equalToConstant: 80),
            recentlyGetStamp2.heightAnchor.constraint(equalToConstant: 80),
            recentlyGetStamp1.leadingAnchor.constraint(equalTo: profileContainer.leadingAnchor),
            recentlyGetStamp1.topAnchor.constraint(equalTo: profileContainer.topAnchor),
            recentlyGetStamp1.bottomAnchor.constraint(equalTo: profileContainer.bottomAnchor),
            recentlyGetStamp1.widthAnchor.constraint(equalToConstant: 80),
            recentlyGetStamp1.heightAnchor.constraint(equalToConstant: 80),
            profileContainer.widthAnchor.constraint(equalToConstant: 350)
        ])
        
        view.addSubview(profileContainer)

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
    @objc private func handleFavoritesTapped() {
        let bookmarkVC = BookmarkViewController()
        navigationController?.pushViewController(bookmarkVC, animated: true)
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

extension MypageViewController {
    @objc private func handleLogoutTapped() {
        viewModel.logOut()
    }
}
