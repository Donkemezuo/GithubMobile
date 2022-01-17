//
//  AppConstants.swift
//  GithubMobile
//
//  Created by Raymond Donkemezuo on 1/16/22.
//

import Foundation

enum QueryEndPoint {
    case userRepos(username: String)
    case repoCommits(username: String, repoName: String)
    private var baseURL: String { return "https://api.github.com/" }
    var endPointURL: String {
        switch self {
        case .repoCommits(username: let username, repoName: let reponame):
            return "\(baseURL)repos/\(username)/\(reponame)/commits"
        case .userRepos(username: let username):
            return "\(baseURL)users/\(username)/repos"
        }
    }
    /*
     a user repos: https://api.github.com/users/Donkemezuo/repos
     a repo commits: https://api.github.com/repos/octocat/hello-world/commits
     */
}
