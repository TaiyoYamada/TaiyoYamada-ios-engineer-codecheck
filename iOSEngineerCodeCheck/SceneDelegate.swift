//
//  SceneDelegate.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let contentView = ContentView()
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UIHostingController(rootView: contentView)
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // シーンが解放される際のリソース解放処理
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // アクティブ状態になった際の処理
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // 非アクティブ状態になる際の処理
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // フォアグラウンドに移行する際の処理
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // バックグラウンドに移行する際の処理
    }
}

