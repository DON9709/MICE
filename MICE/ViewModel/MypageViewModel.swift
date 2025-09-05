//
//  MypageViewModel.swift
//  MICE
//
//  Created by 이돈혁 on 8/26/25.
//

import Foundation
import Combine

final class MypageViewModel: ObservableObject {
    // MARK: - 프로퍼티
    @Published var isLoggedIn: Bool = false
    @Published var email: String? = nil

    init() {
        Task {
            let loggedIn = await SupabaseManager.shared.isLoggedIn()
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
            let loggedIn = await SupabaseManager.shared.isLoggedIn()
            await MainActor.run {
                self.isLoggedIn = loggedIn
                self.email = SupabaseManager.shared.supabase.auth.currentUser?.email
            }
        }
    }

    func logOut() {
        Task {
            await SupabaseManager.shared.signOut()
            await MainActor.run {
                self.isLoggedIn = false
            }
        }
    }
}
