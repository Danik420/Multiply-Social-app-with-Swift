//
//  SceneDelegate.swift
//  mTest01
//
//  Created by Danik420 on 2022/04/21.
//

import UIKit
import Alamofire
import Combine

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate, ObservableObject {
    
    // ObservableObject - Combine 관련 코드
    @Published var loggedInUser: User? = nil
    @Published var users : [User] = []
    var subscription = Set<AnyCancellable>(
    )
    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let _ = (scene as? UIWindowScene) else { return }
        self.loadBaseController()
    }
    
    // 로그인 검증
    func loadBaseController() {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let window = self.window else { return }
        window.makeKeyAndVisible()
        if UserDefaultsManager.shared.isLoggedIn() == true {
            let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! TabBarControllerMain
            self.window?.rootViewController = homeVC
            
            APIManager.shared.currentUserInfoAPI()
                .sink { (completion: Subscribers.Completion<AFError>) in
                    print("유저 동기화")
                } receiveValue: { (receivedUser: User) in
                    self.loggedInUser = receivedUser
                }.store(in: &subscription)
            
        } else {
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            let homeLoginVC = UINavigationController(rootViewController: loginVC)
            self.window?.rootViewController = loginVC
        }
        self.window?.makeKeyAndVisible()
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

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    


}

