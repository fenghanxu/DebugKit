//
//  AppDelegate.swift
//  SwiftDemol
//
//  Created by fenghanxu on 2022/6/7.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: ViewController()) 
        window?.makeKeyAndVisible()
        return true
    }
    
}

