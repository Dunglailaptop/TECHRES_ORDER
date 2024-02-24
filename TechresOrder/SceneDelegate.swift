//
//  SceneDelegate.swift
//  TechresOrder
//
//  Created by Kelvin on 18/12/2021.
//

import UIKit
protocol RestartApp {
    func restartApp()
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate, RestartApp{

    var window: UIWindow?
      private let navigationController = UINavigationController()

      func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
          guard let windowScene = (scene as? UIWindowScene) else { return }
          window = UIWindow(windowScene: windowScene)
          
          navigationController.setViewControllers([SplashScreenViewController()], animated: true)
          window?.rootViewController = navigationController
          window?.makeKeyAndVisible()
          
////
//          if(ManageCacheObject.isLogin()){
//              navigationController.setViewControllers([CustomTabBarController()], animated: true)
//              window?.rootViewController = navigationController
//              window?.makeKeyAndVisible()
//          }else{
//              navigationController.setViewControllers([SplashScreenViewController()], animated: true)
//              window?.rootViewController = navigationController
//              window?.makeKeyAndVisible()
//          }
          
         
          
      }
    
    func changeRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard let window = self.window else {
            return
        }
        
        // change the root view controller to your specific view controller
//        window.rootViewController = vc
        
        navigationController.setViewControllers([vc], animated: true)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func restartApp() {
//            if !UserDefaults.standard.bool(forKey: "New User") {UserDefaults.standard.set(true, forKey: "New User")}
//            let isNewUser = UserDefaults.standard.bool(forKey: "New User")
//            print(isNewUser) // It will keep say "true" even change to false in UserDefault
//            if isNewUser == true {
//                window?.rootViewController = ViewController()
//            } else if versioncheck != "1.0.0.0" {
//                window?.rootViewController = NewUpdate()
//            } else {
//                window?.rootViewController = MainView()
//            }
            navigationController.setViewControllers([SplashScreenViewController()], animated: true)
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
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

    func resetApp() {
        UIApplication.shared.windows[0].rootViewController = UIStoryboard(
            name: "Main",
            bundle: nil
            ).instantiateInitialViewController()
    }
    
}

