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

    @Published var isLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")
    @Published var email: String = UserDefaults.standard.string(forKey: "userEmail") ?? "알 수 없음"

    // MARK: - 메소드

    func logIn(email: String) {
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        UserDefaults.standard.set(email, forKey: "userEmail")
        isLoggedIn = true
        self.email = email
    }

    func logOut() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        isLoggedIn = false
        email = "알 수 없음"
    }
}
