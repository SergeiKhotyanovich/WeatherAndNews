//
//  AppDelegate.swift
//  WeatherAndNews
//
//  Created by Сергей Хотянович on 27.03.22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let LoadingVC = LoadingBuilder.build()
        let TabBarVC = TabBarViewController()
        let navigatorLoadingVC = UINavigationController(rootViewController: LoadingVC)
        _ = UINavigationController(rootViewController: TabBarVC)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigatorLoadingVC
        window?.makeKeyAndVisible()
        
        return true
    }

   


}

