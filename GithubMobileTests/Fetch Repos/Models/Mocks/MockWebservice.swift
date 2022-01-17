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
    private var urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func fetchUserRepos(username: String, completionHandler: @escaping (QueryErrors?, FetchUserReposResponseModel?) -> ()) {
        isFetchUserRepoMethodCalled = true
        guard !username.isEmpty else {
            completionHandler(.invalidUsername, nil)
            return;
        }
        if shouldReturnError {
            completionHandler(.failedRequest(destination: "Fetch request was not successful"), nil)
        } else {
            let repo = UserRepo(reponame: "9square")
            let fetchUserReposResponseModel = FetchUserReposResponseModel(userRepos: [repo])
            completionHandler(nil, fetchUserReposResponseModel)
        }
    }
    
    func fetchRepoCommits(username: String, repoName: String, completionHandler: @escaping (QueryErrors?, Data?) -> ()) {
        isRepoCommitsMethodCalled = true
        if shouldReturnError {
            completionHandler(.failedRequest(destination: "Fetch request was not successful"), nil)
        } else {
            completionHandler(nil, nil)
        }
    }
}
