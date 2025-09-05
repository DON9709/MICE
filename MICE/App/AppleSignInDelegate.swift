//
//  AppleSignIndelegate.swift
//  MICE
//
//  Created by 이돈혁 on 8/20/25.
//

import Foundation
import AuthenticationServices

class AppleSignInDelegate: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    static let shared = AppleSignInDelegate()
    
    var onLoginSuccess: ((Data, String) -> Void)?
    var userName: String?
    var userEmail: String?
    var userID: String?

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow } ?? ASPresentationAnchor()
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            self.userID = credential.user
            UserDefaults.standard.set(credential.user, forKey: "apple_uid")
            let fullName = credential.fullName
            let email = credential.email
            
            print("Apple 로그인 성공")
            print("User ID: \(self.userID ?? "")")
            print("이름: \(fullName?.givenName ?? "") \(fullName?.familyName ?? "")")
            print("이메일: \(email ?? "")")
            
            userName = "\(fullName?.givenName ?? "") \(fullName?.familyName ?? "")"
            userEmail = email

            let name = "\(fullName?.givenName ?? "") \(fullName?.familyName ?? "")"
            let emailToSave = email ?? "(unknown)"
            let provider = "apple"

            guard let identityTokenData = credential.identityToken,
                  let identityTokenString = String(data: identityTokenData, encoding: .utf8) else {
                print("Failed to convert identityToken to String.")
                return
            }

            Task {
                do {
                    try await SupabaseManager.shared.client.auth.signInWithIdToken(
                        credentials: .init(provider: .apple, idToken: identityTokenString)
                    )

                    // 바로 이어서 세션 설정
                    //try await SupabaseManager.shared.client.auth.setSession(from: credential)

                    print("Supabase 인증 및 세션 설정 완료")

                    SupabaseManager.shared.registerOrUpdateUser(
                        appleUID: credential.user,
                        name: name,
                        email: emailToSave,
                        provider: provider
                    )

                    UserDefaults.standard.set(credential.user, forKey: "apple_uid")

                } catch {
                    print("Supabase 인증 실패: \(error.localizedDescription)")
                }
            }

            onLoginSuccess?(identityTokenData, credential.user)
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple 로그인 실패: \(error.localizedDescription)")
    }
}
