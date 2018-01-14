//
//  AppDelegate.swift
//  mOOOnWallet
//
//  Created by  조현호 on 2018. 1. 14..
//  Copyright © 2018년 mOOOn. All rights reserved.
//

import UIKit
import LocalAuthentication

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        setupWindow()
        setupMainController()
        presentLocalAuth()
        
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        presentLocalAuth()
    }
    
    func setupWindow() {
        let window = UIWindow()
        window.makeKeyAndVisible()
        self.window = window
    }
    
    func setupMainController() {
        let mainController = BalanceViewController()
        self.window?.rootViewController = mainController
    }
    
    func presentLocalAuth() {
        let authContext: LAContext = LAContext()
        var authError: NSError?
        
        if authContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {
            authContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Authentication") {
                [weak self] success, evaluateError in
                if success {
                    // User authenticated successfully, take appropriate action
                } else {
                   self?.presentLocalAuth()
                }
            }
        } else {
            presentLocalAuth()
        }
    }
}

