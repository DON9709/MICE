//
//  LogInViewController.swift
//  MICE
//
//  Created by 이돈혁 on 8/25/25.
//

import UIKit
import SnapKit
import Combine

// MARK: - 뷰모델 프로토콜
protocol LogInViewModelType {
    // Define input/output properties here later
}

final class LogInViewController: UIViewController {

    // MARK: - 뷰모델
    private let viewModel: LoginViewModel
    private var cancellables = Set<AnyCancellable>()

    // MARK: - UI 구성요소
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "프로젝트로고"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    private let guestButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("비회원 둘러보기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        return button
    }()

    private let appleLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("애플 로그인", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return button
    }()

    // MARK: - Init
    init(viewModel: LoginViewModel = LoginViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        bindViewModel()
    }

    // MARK: - Bind ViewModel
    private func bindViewModel() {
        guestButton.addTarget(self, action: #selector(guestButtonTapped), for: .touchUpInside)
        appleLoginButton.addTarget(self, action: #selector(appleLoginButtonTapped), for: .touchUpInside)
        
        viewModel.output
            .sink { [weak self] output in
                switch output {
                case .navigateToMain:
                    // Navigate to main screen
                    // Placeholder: implement navigation logic here
                    break
                case .showAppleLogin:
                    // Handle showAppleLogin if needed
                    break
                }
            }
            .store(in: &cancellables)
    }

    @objc private func guestButtonTapped() {
        let sceneDelegate = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive })?
            .delegate as? SceneDelegate
        sceneDelegate?.setRootViewControllerToMainTabBar()
    }

    @objc private func appleLoginButtonTapped() {
        viewModel.transform(input: .didTapAppleLogin)
    }

    // MARK: - UI 셋업
    private func setupUI() {
        view.addSubview(logoLabel)
        view.addSubview(guestButton)
        view.addSubview(appleLoginButton)

        logoLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-80)
        }

        guestButton.snp.makeConstraints {
            $0.top.equalTo(logoLabel.snp.bottom).offset(60)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.height.equalTo(44)
        }

        appleLoginButton.snp.makeConstraints {
            $0.top.equalTo(guestButton.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(guestButton)
            $0.height.equalTo(44)
        }
    }
}
