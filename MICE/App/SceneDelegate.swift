//
//  SceneDelegate.swift
//  MICE
//
//  Created by 이돈혁 on 8/20/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        // 탭 바 컨트롤러 생성
        let tabBarController = UITabBarController()
        
        // 각 탭에 들어갈 뷰 컨트롤러 생성
        let homeVC = HomeViewController()
        // 아래는 임시 뷰 컨트롤러, 실제 뷰 컨트롤러로 교체해야 합니다.
        let stampVC = UIViewController()
        let searchVC = SearchViewController()
        let myPageVC = MypageViewController()
        
        homeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 0)
        stampVC.tabBarItem = UITabBarItem(title: "스탬프", image: UIImage(systemName: "checkmark.seal"), tag: 1)
        searchVC.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 2)
        myPageVC.tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(systemName: "person"), tag: 3)
        
        // 탭 바에 뷰 컨트롤러들 설정
        tabBarController.viewControllers = [homeVC, stampVC, searchVC, myPageVC]
        
        // 탭 바 색상 등 외형 설정
        tabBarController.tabBar.tintColor = .black
        tabBarController.tabBar.backgroundColor = .white
        
        // 윈도우의 첫 화면으로 탭 바 컨트롤러를 지정
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        func sceneDidDisconnect(_ scene: UIScene) {
            // Called as the scene is being released by the system.
            // This occurs shortly after the scene enters the background, or when its session is discarded.
            // Release any resources associated with this scene that can be re-created the next time the scene connects.
            // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        }
        
        func sceneDidBecomeActive(_ scene: UIScene) {
            // Called when the scene has moved from an inactive state to an active state.
            // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        }
        
        func sceneWillResignActive(_ scene: UIScene) {
            // Called when the scene will move from an active state to an inactive state.
            // This may occur due to temporary interruptions (ex. an incoming phone call).
        }
        
        func sceneWillEnterForeground(_ scene: UIScene) {
            // Called as the scene transitions from the background to the foreground.
            // Use this method to undo the changes made on entering the background.
        }
        
        func sceneDidEnterBackground(_ scene: UIScene) {
            // Called as the scene transitions from the foreground to the background.
            // Use this method to save data, release shared resources, and store enough scene-specific state information
            // to restore the scene back to its current state.
        }
        
        
    }
    func setRootViewControllerToMainTabBar() {
        window?.rootViewController = UITabBarController()
        window?.makeKeyAndVisible()
    }
    
}
