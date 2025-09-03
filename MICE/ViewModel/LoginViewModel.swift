//
//  LoginViewModel.swift
//  MICE
//
//  Created by 이돈혁 on 8/25/25.
//

import Foundation
import Combine
import AuthenticationServices

final class LoginViewModel {

    // MARK: - 인풋
    enum Input {
        case didTapAppleLogin
        case didTapGuest
    }

    // MARK: - 아웃풋
    enum Output {
        case navigateToMain
        case showAppleLogin
    }

    // MARK: - 퍼블리셔
    private let outputSubject = PassthroughSubject<Output, Never>()
    var output: AnyPublisher<Output, Never> {
        return outputSubject.eraseToAnyPublisher()
    }

    // MARK: - Init
    init() {}

    // MARK: - 입력 -> 상태 변환 처리
    func transform(input: Input) {
        switch input {
        case .didTapAppleLogin:
            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = AppleSignInDelegate.shared
            controller.presentationContextProvider = AppleSignInDelegate.shared
            AppleSignInDelegate.shared.onLoginSuccess = { [weak self] appleUID in
                Task {
                    if let email = await SupabaseManager.shared.fetchEmail(for: appleUID) {
                        UserSession.shared.logIn(appleUID: appleUID, email: email)
                        self?.outputSubject.send(.navigateToMain)
                    } else {
                        print("로그인 실패: 이메일 조회 실패")
                    }
                }
            }
            controller.performRequests()
        case .didTapGuest:
            outputSubject.send(.navigateToMain)
        }
    }
}
