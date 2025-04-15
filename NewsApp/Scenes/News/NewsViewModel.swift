//
//  NewsViewModel.swift
//  NewsApp
//
//  Created by Emirhan İpek on 15.04.2025.
//

import Foundation

final class NewsViewModel {
    
    // MARK: Properties
    
    private let newsService: NewsServiceProtocol
    weak var delegate: NewsViewVCProtocol?
    
    private(set) var articles: [Article] = []
    
    init(
        newsService: NewsServiceProtocol = NewsService()
    ) {
        self.newsService = newsService
    }
}

extension NewsViewModel {
    func fetchTopNews() {
        newsService.fetchTopNews(
            country: "us",
            page: 1,
            pageSize: 10) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let success):
                    self.articles = success.articles
                    self.delegate?.reloadData()
                case .failure(let failure):
                    print("Failed to fetch news: \(failure)")
                }
            }
    }
}
