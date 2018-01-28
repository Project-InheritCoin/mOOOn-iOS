//
//  AppDelegate.swift
//  mOOOnWallet
//
//  Created by  조현호 on 2018. 1. 14..
//  Copyright © 2018년 mOOOn. All rights reserved.
//

import UIKit
import LocalAuthentication
import Geth

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
        let tabBarController = TabBarController()
        
        let balanceViewController = BalanceViewController()
        balanceViewController.tabBarItem = UITabBarItem(title: "Balance", image: nil, tag: 1)
        balanceViewController.tabBarItem
            .setTitleTextAttributes([NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15)],
                                    for: .normal)
        
        let sendViewController = SendViewController()
        sendViewController.tabBarItem = UITabBarItem(title: "Send", image: nil, tag: 1)
        sendViewController.tabBarItem
            .setTitleTextAttributes([NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15)],
                                    for: .normal)
        
        let receiveViewController = ReceiveViewController()
        receiveViewController.tabBarItem = UITabBarItem(title: "Receive", image: nil, tag: 1)
        receiveViewController.tabBarItem
            .setTitleTextAttributes([NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15)],
                                    for: .normal)
        
        tabBarController.addChildViewController(balanceViewController)
        tabBarController.addChildViewController(sendViewController)
        tabBarController.addChildViewController(receiveViewController)
        
        self.window?.rootViewController = tabBarController
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

