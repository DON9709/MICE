//
//  UserSession.swift
//  MICE
//
//  Created by 이돈혁 on 9/1/25.
//

import Foundation

final class UserSession: ObservableObject {
    static let shared = UserSession()

    @Published var isLoggedIn: Bool = false
    @Published var appleUID: String = ""
    @Published var email: String = ""

    private init() {
        //앱 재시작시에도 유지되도록 초기화
        isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        appleUID = UserDefaults.standard.string(forKey: "appleUID") ?? ""
        email = UserDefaults.standard.string(forKey: "email") ?? ""
    }

    func logIn(appleUID: String, email: String) {
        self.appleUID = appleUID
        self.email = email
        self.isLoggedIn = true
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        UserDefaults.standard.set(appleUID, forKey: "appleUID")
        UserDefaults.standard.set(email, forKey: "email")
    }

    func logOut() {
        self.appleUID = ""
        self.email = ""
        self.isLoggedIn = false
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "appleUID")
        UserDefaults.standard.removeObject(forKey: "email")
    }
}
