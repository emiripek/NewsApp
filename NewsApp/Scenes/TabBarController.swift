//
//  TabBarController.swift
//  NewsApp
//
//  Created by Emirhan İpek on 11.04.2025.
//

import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
}

// MARK: - Private Methods
private extension TabBarController {
    func setupTabs() {
        let homeVC = createNav(
            with: "News",
            and: UIImage(systemName: "newspaper.circle"),
            viewController: NewsVC()
        )
        let settingsVC = createNav(
            with: "Settings",
            and: UIImage(systemName: "gear.circle"),
            viewController: SettingsVC()
        )
        
        setViewControllers([homeVC, settingsVC], animated: true)
    }
    
    func createNav(
        with title: String,
        and image: UIImage?,
        viewController: UIViewController
    ) -> UINavigationController {
        let controller = UINavigationController(rootViewController: viewController)
        controller.tabBarItem.title = title
        controller.tabBarItem.image = image
        viewController.title = title
        controller.navigationBar.prefersLargeTitles = true
        viewController.navigationItem.largeTitleDisplayMode = .always
        return controller
    }
}
