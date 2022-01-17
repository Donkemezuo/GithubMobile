//
//  WebserviceProtocol.swift
//  GithubMobile
//
//  Created by Raymond Donkemezuo on 1/17/22.
//

import Foundation

protocol WebserviceProtocol: AnyObject {
    func fetchUserRepos(username: String, completionHandler: @escaping(QueryErrors?, FetchUserReposResponseModel?) -> ())
    func fetchRepoCommits(username: String, repoName: String, completionHandler: @escaping(QueryErrors?, Data?) -> ())
}
