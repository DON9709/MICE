//
//  LogInViewController.swift
//  MICE
//
//  Created by 이돈혁 on 8/25/25.
//

import UIKit
import SnapKit
import Combine
import AuthenticationServices
import CoreLocation

// MARK: - 뷰모델 프로토콜
// MARK: - 뷰모델 프로토콜
protocol LogInViewModelType {
    // Define input/output properties here later
}

final class LogInViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - Location
    private let locationManager = CLLocationManager()
    private var hasShownLocationAlert = false
    
    // MARK: - 뷰모델
    private let viewModel: LoginViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI 구성요소
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo") // 실제 이름
        imageView.contentMode = .scaleAspectFit     // 비율 유지하며 크기 조정
        return imageView
    }()
    
    private let guestButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("비회원 둘러보기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 12
        return button
    }()
    
    private let appleLoginButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        button.cornerRadius = 12
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
        view.backgroundColor = UIColor(red: 114/255, green: 76/255, blue: 249/255, alpha: 1.0)
        setupUI()
        bindViewModel()
        locationManager.delegate = self
    }
    
    // MARK: - Bind ViewModel
    private func bindViewModel() {
        guestButton.addTarget(self, action: #selector(guestButtonTapped), for: .touchUpInside)
        appleLoginButton.addTarget(self, action: #selector(appleLoginButtonTapped), for: .touchUpInside)
        
        viewModel.output
            .sink { [weak self] output in
                switch output {
                case .navigateToMain:
                    let myPageVC = MypageViewController()
                    myPageVC.modalPresentationStyle = .fullScreen
                    self?.present(myPageVC, animated: true, completion: nil)
                case .showAppleLogin:
                    // Handle showAppleLogin if needed
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    @objc private func guestButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func appleLoginButtonTapped() {
        viewModel.transform(input: .didTapAppleLogin)
    }
    
    // MARK: - UI 셋업
    private func setupUI() {
        view.addSubview(logoImageView)
        view.addSubview(guestButton)
        view.addSubview(appleLoginButton)
        
        logoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-80)
            $0.width.height.equalTo(160) // 적당한 크기 (1200x1200 → 160x160 등)
        }
        
        guestButton.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(265)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.height.equalTo(48)
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.top.equalTo(guestButton.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(guestButton)
            $0.height.equalTo(48)
        }
    }
}
