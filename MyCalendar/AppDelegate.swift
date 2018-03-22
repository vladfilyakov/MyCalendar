//
//  AppDelegate.swift
//  MyCalendar
//
//  Created by Vladislav Filyakov on 3/21/18.
//  Copyright © 2018 Vlad Filyakov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        initLayout()
        return true
    }
    
    private func initLayout() {
        window = UIWindow()
        window?.makeKeyAndVisible()
        
        let controller = CalendarController()
        let container = UINavigationController(rootViewController: controller)
        window?.rootViewController = container
    }
}
