//
//  MypageViewModel.swift
//  MICE
//
//  Created by 이돈혁 on 8/26/25.
//

import Foundation
import Combine

// MARK: - Notification 이름 정의
// SceneDelegate에서 이 신호를 받아서 처리할 수 있도록 Notification 이름을 정의합니다.
extension Notification.Name {
    static let didRequestLogout = Notification.Name("didRequestLogout")
}

final class MypageViewModel: ObservableObject {
    // MARK: - 프로퍼티
    @Published var isLoggedIn: Bool = false
    @Published var email: String? = nil

    init() {
        Task {
            let loggedIn = SupabaseManager.shared.isLoggedIn()
            await MainActor.run {
                self.isLoggedIn = loggedIn
                if loggedIn {
                    self.email = SupabaseManager.shared.supabase.auth.currentUser?.email
                }
            }
        }
    }

    // MARK: - 메소드

    func logIn(with uid: String, email: String) {
        Task {
            let loggedIn = SupabaseManager.shared.isLoggedIn()
            await MainActor.run {
                self.isLoggedIn = loggedIn
                self.email = SupabaseManager.shared.supabase.auth.currentUser?.email
            }
        }
    }

    func logOut() {
        Task {
            await SupabaseManager.shared.signOut()
            UserSession.shared.logOut() // MARK: - 로컬 세션도 확실히 로그아웃 처리
            await MainActor.run {
                self.isLoggedIn = false
                // MARK: - 변경점: 로그아웃 신호 보내기
                NotificationCenter.default.post(name: .didRequestLogout, object: nil)
            }
        }
    }
    
    func deleteAccount() {
       Task {
           do {
               try await SupabaseManager.shared.deleteAccount()
               await SupabaseManager.shared.signOut()
               UserSession.shared.logOut() // MARK: - 로컬 세션도 확실히 로그아웃 처리
               await MainActor.run {
                   self.isLoggedIn = false
                   self.email = nil
                   // MARK: - 변경점: 회원 탈퇴 후 로그아웃 신호 보내기
                   NotificationCenter.default.post(name: .didRequestLogout, object: nil)
               }
           } catch {
               print("회원 탈퇴 실패: \(error)")
            }
        }
    }
}
