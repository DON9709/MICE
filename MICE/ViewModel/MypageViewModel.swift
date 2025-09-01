//
//  MypageViewModel.swift
//  MICE
//
//  Created by 이돈혁 on 8/26/25.
//

import Foundation

final class MypageViewModel {

    // MARK: - 프로퍼티

    // 로그인 여부 확인 로직 - 실제 앱에선 AuthManager 등을 참조할 수 있음
    var isLoggedIn: Bool {
        // 예시: UserDefaults 또는 AuthManager 사용 가능
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }

    /// 사용자의 이메일을 반환하는 프로퍼티
    var email: String {
        return UserDefaults.standard.string(forKey: "userEmail") ?? "알 수 없음"
    }

    // MARK: - 메소드

    func logIn() {
        // 로그인 처리 로직 (예: Supabase 호출 후 성공 시 상태 저장)
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
    }

    func logOut() {
        // 로그아웃 처리 로직
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
    }
}
