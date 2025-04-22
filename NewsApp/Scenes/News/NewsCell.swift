//
//  NewsCell.swift
//  NewsApp
//
//  Created by Emirhan İpek on 22.04.2025.
//

import UIKit
import Kingfisher

class NewsCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "NewsCell"
    
    private var article: Article?
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.image = UIImage(systemName: "photo.artframe")
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 2
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .systemBlue
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Methods

extension NewsCell {
    func configure(with article: Article) {
        self.article = article
        titleLabel.text = article.title
        authorLabel.text = article.author
        dateLabel.text = article.publishedAt
        newsImageView.kf.setImage(with: URL(string: article.urlToImage ?? ""))
    }
}

// MARK: - Private Methods

private extension NewsCell {
    func configureView() {
        addViews()
        configureLayout()
    }
    
    func addViews() {
        contentView.addSubview(newsImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(dateLabel)
    }
    
    func configureLayout() {
        newsImageView.setupAnchors(
            top: contentView.topAnchor,
            paddingTop: 16,
            leading: contentView.leadingAnchor,
            paddingLeading: 16,
            width: 140,
            height: 140,
        )
        titleLabel.setupAnchors(
            top: contentView.topAnchor,
            paddingTop: 16,
            leading: newsImageView.trailingAnchor,
            paddingLeading: 12,
            trailing: contentView.trailingAnchor,
            paddingTrailing: -16,
        )
        authorLabel.setupAnchors(
            top: titleLabel.bottomAnchor,
            paddingTop: 12,
            leading: newsImageView.trailingAnchor,
            paddingLeading: 12,
            trailing: contentView.trailingAnchor,
            paddingTrailing: -16
        )
        dateLabel.setupAnchors(
            top: authorLabel.bottomAnchor,
            paddingTop: 12,
            leading: newsImageView.trailingAnchor,
            paddingLeading: 12,
            height: 24
        )
    }
}

#Preview {
    NewsVC()
}
