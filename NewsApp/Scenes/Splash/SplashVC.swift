//
//  SplashVC.swift
//  NewsApp
//
//  Created by Emirhan İpek on 10.04.2025.
//

import UIKit

final class SplashVC: UIViewController {
    
    // MARK: - Properties
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "newspaper.circle")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let newsLabel: UILabel = {
        let label = UILabel()
        label.text = "News App"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let newsService = NewsService()
    private var fetchedNews: [Article] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        navigateToTabBar()
    }
}

// MARK: - Private Methods
private extension SplashVC {
    func configureView() {
        view.backgroundColor = .systemBackground
        addViews()
        configureLayout()
    }
    
    func addViews() {
        view.addSubview(iconImageView)
        view.addSubview(newsLabel)
    }
    
    func configureLayout() {
        iconImageView.setupAnchors(
            centerX: view.centerXAnchor,
            centerY: view.centerYAnchor,
            width: 216,
            height: 216
        )
        
        newsLabel.setupAnchors(
            top: iconImageView.bottomAnchor,
            paddingTop: 16,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor
        )
    }
    
    func navigateToTabBar() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
            
            let tabBarController = TabBarController()
            sceneDelegate.window?.rootViewController = tabBarController
        }
    }
}

#Preview {
    SplashVC()
}
