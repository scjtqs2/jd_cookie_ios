//
//  SceneDelegate.swift
//  Hcl JD ck Get
//
//  Created by scjtqs on 2022/7/19.
//

import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        // Use a UIHostingController as window root view controller
        if let windowScene = scene as? UIWindowScene {
            var openurl = UserDefaults.standard.string(forKey: "OPENURL")
            var posturl = UserDefaults.standard.string(forKey: "POSTURL")
            if openurl == nil || openurl!.isEmpty {
//                openurl = "https://m.jd.com"
                openurl = "https://wx.scjtqs.com/utils/test/hcltest"
            }
            if posturl == nil || posturl!.isEmpty {
//                posturl = "https://jd.900109.xyz:8443/notify"
                posturl = "https://wx.scjtqs.com/utils/test/hclnotify"
            }
            print("openurl:", openurl, " posturl:", posturl)
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: HomeForm(openUrl: openurl!, postUrl: posturl!))
            self.window = window
            window.makeKeyAndVisible()
        } else {
            guard let _ = (scene as? UIWindowScene) else { return }
        }
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
