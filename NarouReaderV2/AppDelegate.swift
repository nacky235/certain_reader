//
//  AppDelegate.swift
//  NarouReaderV2
//
//  Created by 稲葉夏輝 on 2020/11/15.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        let viewModel = MainViewModel(dependency: .default)
        let viewController = MainViewController(viewModel: viewModel)
        let navCon = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navCon
        window?.makeKeyAndVisible()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    


}

