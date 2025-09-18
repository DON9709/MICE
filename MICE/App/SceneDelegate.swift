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
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        // 기본적으로 로딩 화면 먼저 띄우기
        window?.rootViewController = SplashViewController()
        window?.makeKeyAndVisible()

        Task {
            if let session = try? await SupabaseManager.shared.client.auth.session, session.user != nil {
                // 세션이 있으면 메인 화면으로
                DispatchQueue.main.async {
                    self.window?.rootViewController = MainTabBarController()
                }
            } else {
                // 세션이 없으면 로그인 화면으로
                DispatchQueue.main.async {
                    self.window?.rootViewController = LogInViewController(launchSource: .firstInstall)
                }
            }
        }
    }
    
    // MARK: - 추가된 함수: 로그아웃 처리 및 화면 전환
    // Notification 신호를 받으면 이 함수가 실행됩니다.
    @objc private func handleLogout() {
        // 애니메이션과 함께 로그인 화면으로 전환합니다.
        let loginVC = LogInViewController(launchSource: .mypage)
        
        guard let window = self.window else { return }
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = loginVC
        }, completion: nil)
    }
    
    // SceneDelegate가 메모리에서 해제될 때 Observer도 함께 제거해줍니다.
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
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
//    func setRootViewControllerToMainTabBar() {
//        window?.rootViewController = MainTabBarController()
//        window?.makeKeyAndVisible()
//    }
//    

