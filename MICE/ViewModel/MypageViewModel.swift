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

    init() {
        Task {
            let loggedIn = await SupabaseManager.shared.isLoggedIn()
            await MainActor.run {
                self.isLoggedIn = loggedIn
            }
        }
    }

    // MARK: - 메소드

    func logIn(with uid: String, email: String) {
        Task {
            let loggedIn = await SupabaseManager.shared.isLoggedIn()
            await MainActor.run {
                self.isLoggedIn = loggedIn
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
