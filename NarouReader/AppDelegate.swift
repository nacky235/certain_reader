//
//  AppDelegate.swift
//  NarouReader
//
//  Created by 稲葉夏輝 on 2020/11/15.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var tabBarController: UITabBarController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        
        var viewControllers: [UIViewController] = []
        
        let firstTabBarButtonItem = UITabBarItem(title: "さがす", image: UIImage(systemName: "magnifyingglass.circle"), selectedImage: UIImage(systemName: "magnifyingglass.circle.fill"))
        let secondTabBarbuttonItem = UITabBarItem(title: "よむ", image: UIImage(systemName: "books.vertical"), selectedImage: UIImage(systemName: "books.vertical.fill"))
        
        let firstViewModel = SearchViewModel(dependency: .default)
        let firstViewController = SearchViewController(viewModel: firstViewModel)
        let firstNavigationController = UINavigationController(rootViewController: firstViewController)
        firstNavigationController.tabBarItem = firstTabBarButtonItem
        viewControllers.append(firstNavigationController)
        
        let secondViewModel = BookViewModel(dependency: .default)
        let secondViewController = BookViewController(viewModel: secondViewModel)
        let secondNavigationController = UINavigationController(rootViewController: secondViewController)
        secondNavigationController.tabBarItem = secondTabBarbuttonItem
        viewControllers.append(secondNavigationController)
        
        tabBarController = UITabBarController()
        tabBarController?.setViewControllers(viewControllers, animated: true)
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    


}

