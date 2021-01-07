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
        
        let searchTabBarButtonItem = UITabBarItem(title: "新しい小説を探す", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass"))
        let readTabBarbuttonItem = UITabBarItem(title: nil, image: UIImage(systemName: "book"), selectedImage: UIImage(systemName: "book"))
        let moreTabBarbuttonItem = UITabBarItem(title: "その他", image: UIImage(systemName: "ellipsis"), selectedImage: UIImage(systemName: "ellipsis"))
        
        let readViewModel = BookViewModel(dependency: .default)
        let readViewController = BookViewController(viewModel: readViewModel)
        let readNavigationController = UINavigationController(rootViewController: readViewController)
        readNavigationController.tabBarItem = readTabBarbuttonItem
        viewControllers.append(readNavigationController)
        
        let searchViewModel = SearchViewModel(dependency: .default)
        let searchViewController = SearchViewController(viewModel: searchViewModel)
        let searchNavigationController = UINavigationController(rootViewController: searchViewController)
        searchNavigationController.tabBarItem = searchTabBarButtonItem
        viewControllers.append(searchNavigationController)
        
        let moreViewModel = SettingViewModel(dependency: .default)
        let moreViewController = SettingViewController(viewModel: moreViewModel)
        let moreNavigationController = UINavigationController(rootViewController: moreViewController)
        moreNavigationController.tabBarItem = moreTabBarbuttonItem
        viewControllers.append(moreNavigationController)
        
        tabBarController = UITabBarController()
        tabBarController?.setViewControllers(viewControllers, animated: true)
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    


}

