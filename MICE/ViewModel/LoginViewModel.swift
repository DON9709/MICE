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
            AppleSignInDelegate.shared.onLoginSuccess = { [weak self] in
                self?.outputSubject.send(.navigateToMain)
            }
            controller.performRequests()
        case .didTapGuest:
            outputSubject.send(.navigateToMain)
        }
    }
}
