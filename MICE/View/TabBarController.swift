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
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        let stampVC = UINavigationController(rootViewController: StampViewController())
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        let myPageVC = UINavigationController(rootViewController: MypageViewController())

        // 탭 아이템 설정
        homeVC.tabBarItem = UITabBarItem(title: "홈",
                                         image: UIImage(named: "Home")?.withRenderingMode(.alwaysOriginal),
                                         selectedImage: UIImage(named: "HomeActive")?.withRenderingMode(.alwaysOriginal))

        stampVC.tabBarItem = UITabBarItem(title: "스탬프",
                                          image: UIImage(named: "Stamp")?.withRenderingMode(.alwaysOriginal),
                                          selectedImage: UIImage(named: "StampActive")?.withRenderingMode(.alwaysOriginal))

        searchVC.tabBarItem = UITabBarItem(title: "검색",
                                           image: UIImage(named: "Search")?.withRenderingMode(.alwaysOriginal),
                                           selectedImage: UIImage(named: "SearchActive")?.withRenderingMode(.alwaysOriginal))

        myPageVC.tabBarItem = UITabBarItem(title: "My Page",
                                           image: UIImage(named: "MyPage")?.withRenderingMode(.alwaysOriginal),
                                           selectedImage: UIImage(named: "MyPageActive")?.withRenderingMode(.alwaysOriginal))

        // 탭 배열 구성
        viewControllers = [homeVC, stampVC, searchVC, myPageVC]

        // 탭바 색상 및 스타일 설정
        tabBar.tintColor = .black
        tabBar.backgroundColor = .white
    }
}
