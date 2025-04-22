//
//  DetailVC.swift
//  NewsApp
//
//  Created by Emirhan İpek on 23.04.2025.
//

import UIKit
import Kingfisher

class DetailVC: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: DetailViewModel
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private let articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.image = UIImage(named: "placeholder")
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Inits
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
}

// MARK: - Private Methods

private extension DetailVC {
    func configureViews() {
        title = "News Detail"
        view.backgroundColor = .systemBackground
        addViews()
        configureLayout()
        articleImageView.kf.setImage(with: URL(string: viewModel.article.urlToImage ?? ""))
        configureLabels()
    }
    
    func addViews() {
        view.addSubview(titleLabel)
        view.addSubview(articleImageView)
        view.addSubview(descriptionLabel)
    }
    
    func configureLayout() {
        titleLabel.setupAnchors(
            top: view.safeAreaLayoutGuide.topAnchor,
            paddingTop: 16,
            leading: view.leadingAnchor,
            paddingLeading: 16,
            trailing: view.trailingAnchor,
            paddingTrailing: -16
        )
        
        articleImageView.setupAnchors(
            top: titleLabel.bottomAnchor,
            paddingTop: 8,
            leading: view.leadingAnchor,
            paddingLeading: 16,
            trailing: view.trailingAnchor,
            paddingTrailing: -16,
            height: 200
        )
        
        descriptionLabel.setupAnchors(
            top: articleImageView.bottomAnchor,
            paddingTop: 8,
            leading: view.leadingAnchor,
            paddingLeading: 16,
            trailing: view.trailingAnchor,
            paddingTrailing: -16
        )
    }
    
    func configureLabels() {
        titleLabel.text = viewModel.article.title
        descriptionLabel.text = viewModel.article.description
    }
}
