//
//  AppErrors.swift
//  GithubMobile
//
//  Created by Raymond Donkemezuo on 1/17/22.
//

import Foundation

enum QueryErrors: LocalizedError, Equatable {
    case invalidURL(urlString: String)
    case jsonParse
    case failedRequest(destination: String)
    var errorMessage: String {
        switch self {
        case .invalidURL(let urlString):
            return "\(urlString) string is invalid "
        case .failedRequest(destination: let destination):
            return destination
        case .jsonParse:
            return ""
        }
    }
}
