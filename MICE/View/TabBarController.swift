//
//  TabBarController.swift
//  MICE
//
//  Created by 이돈혁 on 8/28/25.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    private func setupTabBar() {
        // 각 탭의 VC 생성
        let homeVC = HomeViewController()
        let stampVC = StampViewController()
        let searchVC = SearchViewController()
        let myPageVC = MypageViewController()

        // 탭 아이템 설정
        homeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 0)
        stampVC.tabBarItem = UITabBarItem(title: "스탬프", image: UIImage(systemName: "checkmark.seal"), tag: 1)
        searchVC.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 2)
        myPageVC.tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(systemName: "person"), tag: 3)

        // 탭 배열 구성
        viewControllers = [homeVC, stampVC, searchVC, myPageVC]

        // 탭바 색상 및 스타일 설정
        tabBar.tintColor = .black
        tabBar.backgroundColor = .white
    }
}
