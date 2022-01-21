//
//  MockWebservice.swift
//  GithubMobileTests
//
//  Created by Raymond Donkemezuo on 1/17/22.
//

import Foundation
@testable import GithubMobile

class MockWebservice: WebserviceProtocol {
    var isFetchUserRepoMethodCalled = false
    var isRepoCommitsMethodCalled = false
    var shouldReturnError = false
    var responseErrorType: QueryError = .invalidUsername
    private var urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func fetchUserRepos(username: String, completionHandler: @escaping (QueryError?, FetchUserReposResponseModel?) -> ()) {
        isFetchUserRepoMethodCalled = true
        guard !username.isEmpty else {
            completionHandler(.invalidUsername, nil)
            return
        }
        if shouldReturnError {
            var error: QueryError
            switch responseErrorType {
            case .invalidURL(let urlString):
                error = .invalidURL(urlString: urlString)
            case .jsonParse:
                error = .jsonParse
            case .invalidUsername:
                error = .invalidUsername
            case .invalidReponame:
                error = .invalidReponame
            case .failedRequest(_):
                error = .failedRequest(destination: "Fetch request was not successful")
            case .badStatusCode(let statusCode):
                error = .badStatusCode(statusCode: statusCode)
            }
            completionHandler(error, nil)
        } else {
            let repo = UserRepo(reponame: "9square", repoCreatedString: "2019-02-08T17:31:49Z", description: "A mobile App that enable users search for venues")
            let fetchUserReposResponseModel = FetchUserReposResponseModel(userRepos: [repo])
            completionHandler(nil, fetchUserReposResponseModel)
        }
    }
    
    func fetchRepoCommits(username: String, repoName: String, completionHandler: @escaping (QueryError?, FetchRepoCommitsResponseModel?) -> ()) {
        isRepoCommitsMethodCalled = true
        guard !username.isEmpty else {
            completionHandler(.invalidUsername, nil)
            return
        }
        guard !repoName.isEmpty else {
            completionHandler(.invalidReponame, nil)
            return
        }
        if shouldReturnError {
            var error: QueryError
            switch responseErrorType {
            case .invalidURL(let urlString):
                error = .invalidURL(urlString: urlString)
            case .jsonParse:
                error = .jsonParse
            case .invalidUsername:
                error = .invalidUsername
            case .invalidReponame:
                error = .invalidReponame
            case .failedRequest(_):
                error = .failedRequest(destination: "Fetch request was not successful")
            case .badStatusCode(let statusCode):
                error = .badStatusCode(statusCode: statusCode)
            }
            completionHandler(error, nil)
        } else {
            let commitAuthor = CommitAuthor(name: "Donkemezuo", date: "2022-01-17T22:54:13Z")
            let commitDetails = CommitDetails(author: commitAuthor, message: "Added Unit Test for fetchUserReposwebservices")
            let commit = Commit(commit: commitDetails, commitHash: "230dae05ec42792da47b315152591626caca351f")
            completionHandler(nil, FetchRepoCommitsResponseModel(repoCommits: [commit]))
        }
    }
}
