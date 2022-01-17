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
    case invalidUsername
    case invalidReponame
    case failedRequest(destination: String)
    case badStatusCode(statusCode: String)
    var errorMessage: String {
        switch self {
        case .invalidURL(let urlString):
            return "\(urlString) string is invalid "
        case .failedRequest(destination: let destination):
            return destination
        case .badStatusCode(statusCode: let code):
            return "bad status code: \(code)"
        case .jsonParse, .invalidUsername, .invalidReponame:
            return ""
        }
    }
}
