//
//  AppDelegate.swift
//  MICE
//
//  Created by 이돈혁 on 8/20/25.
//

import UIKit
import CoreLocation

@main
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 앱 실행 후 초기 설정을 진행하는 지점
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        return true
    }

    // MARK: - UISceneSession 생명주기

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // 새로운 씬 세션이 생성될 때 호출됨
        // 해당 메서드를 통해 사용할 씬 구성 정보를 반환함
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // 사용자가 씬 세션을 삭제했을 때 호출됨
        // 앱이 실행되지 않는 동안 삭제된 씬 세션도 이 메서드를 통해 정리됨
        // 삭제된 씬과 관련된 리소스를 해제하는 데 사용
    }

}
