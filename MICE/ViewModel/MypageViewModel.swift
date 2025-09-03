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
    @Published var appleUID: String = "알 수 없음"
    @Published var email: String = "이메일 없음"

    private var cancellables = Set<AnyCancellable>()

    init() {
        UserSession.shared.$appleUID
            .receive(on: RunLoop.main)
            .sink { [weak self] uid in
                self?.isLoggedIn = !uid.isEmpty
                self?.appleUID = uid.isEmpty ? "알 수 없음" : uid
            }
            .store(in: &cancellables)
    }

    // MARK: - 메소드

    func logIn(with uid: String, email: String) {
        UserSession.shared.logIn(appleUID: uid, email: email)
    }

    func logOut() {
        UserSession.shared.logOut()
    }
}
