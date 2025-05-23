//
//  NewsViewModel.swift
//  NewsApp
//
//  Created by Emirhan İpek on 15.04.2025.
//

import Foundation

enum Mode: Equatable {
    case top
    case search(String)
}

final class NewsViewModel {
    
    // MARK: Properties
    
    private let newsService: NewsServiceProtocol
    weak var delegate: NewsViewVCProtocol?
    
    private var mode: Mode = .top
    
    private let debounceInterval: TimeInterval = 1
    private var debounceWorkItem: DispatchWorkItem?
    
    private(set) var articles: [Article] = []
    
    init(
        newsService: NewsServiceProtocol = NewsService()
    ) {
        self.newsService = newsService
    }
    
    deinit { debounceWorkItem?.cancel() }
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
    
    func fetch() {
        let completion: (Result<NewsModel, NetworkError>) -> Void = { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                articles = response.articles
                self.delegate?.reloadData()
            case .failure(let error):
                print("Error fetching news: \(error)")
            }
        }
        switch mode {
        case .top:
            newsService.fetchTopNews(country: "us", page: 1, pageSize: 20, completion: completion)
        case .search(let query):
            newsService.searchNews(searchString: query, page: 1, pageSize: 20, completion: completion)
        }
    }
    
    func search(term: String) {
        let trimmed = term.trimmingCharacters(in: .whitespacesAndNewlines)
        
        debounceWorkItem?.cancel()
        
        let workItem = DispatchWorkItem { [weak self] in
            guard let self else { return }
            self.mode = trimmed.isEmpty ? .top : .search(trimmed)
            self.fetch()
        }
        
        debounceWorkItem = workItem
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + debounceInterval,
            execute: workItem
        )
    }
}
