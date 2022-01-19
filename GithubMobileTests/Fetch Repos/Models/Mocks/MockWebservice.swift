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
    
    func fetchRepoCommits(username: String, repoName: String, completionHandler: @escaping (QueryErrors?, FetchRepoCommitsResponseModel?) -> ()) {
        isRepoCommitsMethodCalled = true
        guard !username.isEmpty else {
            completionHandler(.invalidUsername, nil)
            return;
        }
        guard !repoName.isEmpty else {
            completionHandler(.invalidReponame, nil)
            return;
        }
        if shouldReturnError {
            completionHandler(.failedRequest(destination: "Fetch request was not successful"), nil)
        } else {
            let commitAuthor = CommitAuthor(name: "Raymond", date: "2022-01-17T22:54:13Z")
            let commitDetails = CommitDetails(author: commitAuthor, message: "Added Unit Test for fetchUserReposwebservices")
            let commit = Commit(commit: commitDetails)
            completionHandler(nil, FetchRepoCommitsResponseModel(repoCommits: [commit]))
        }
    }
}
