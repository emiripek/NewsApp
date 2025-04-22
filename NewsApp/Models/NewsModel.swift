//
//  NewsModel.swift
//  NewsApp
//
//  Created by Emirhan İpek on 15.04.2025.
//

import Foundation

struct NewsModel: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let title: String
    let description: String?
    let author: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}
