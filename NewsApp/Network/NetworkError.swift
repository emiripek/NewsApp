//
//  NetworkError.swift
//  NewsApp
//
//  Created by Emirhan İpek on 15.04.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidRequest
    case decodingError
    case requestFailedWith(Int)
    case invalidResponse
    case invalidData
    case customError(Error)
    
    var localizedDescription: String {
        switch self {
        case .invalidRequest:
            "Invalid request."
        case .decodingError:
            "Decoding error."
        case . requestFailedWith(let code):
            "Request failed with status code: \(code)"
        case .invalidResponse:
            "Invalid response."
        case .invalidData:
            "Invalid data."
        case .customError(let error):
            "An error occured: \(error.localizedDescription)"
        }
    }
}
