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
            AppleSignInDelegate.shared.onLoginSuccess = { [weak self] (idToken: Data, appleUID: String) in
                Task {
                    do {
                        guard let idTokenString = String(data: idToken, encoding: .utf8) else {
                            print("idToken 변환 실패")
                            return
                        }
                        _ = try await SupabaseManager.shared.signInWithApple(idToken: idTokenString, nonce: nil)
                        if SupabaseManager.shared.isLoggedIn() {
                            self?.outputSubject.send(.navigateToMain)
                        }
                    } catch {
                        print("Apple 로그인 실패: \(error)")
                    }
                }
            }
            controller.performRequests()
        case .didTapGuest:
            outputSubject.send(.navigateToMain)
        }
    }
}
