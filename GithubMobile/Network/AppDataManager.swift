//
//  AppDataManager.swift
//  GithubMobile
//
//  Created by Raymond Donkemezuo on 1/18/22.
//

import Foundation


/// A data manager class 
class AppDataManager {
    private let webservice = Webservice()
    var currentSearchedUser = "Donkemezuo"
    var titleText: String {
        return "\(currentSearchedUser)'s repos"
    }
    var userRepos = [UserRepo]()
    var repoCommits = [Commit]()
    
    /// A function to fetch a given user's repos
    /// - Parameters:
    ///   - name: github username
    ///   - completionHandler: response
    func fetchUserRepos(username name: String, completionHandler: @escaping(QueryError?) -> ()) {
        webservice.fetchUserRepos(username: name) { [weak self] (responseError, responseData ) in
            if let responseError = responseError {
                completionHandler(responseError)
            } else if let responseData = responseData {
                self?.userRepos = responseData.userRepos.sorted{$0.createdDate > $1.createdDate}
                completionHandler(nil)
            }
        }
    }
    
    /// A function to fetch a given repo's commits
    /// - Parameters:
    ///   - name: name of github user
    ///   - rname: reponame
    ///   - completionHandler: response
    func fetchRepoCommits(username name: String, reponame rname: String, completionHandler: @escaping(QueryError?) -> ()) {
        webservice.fetchRepoCommits(username: name, repoName: rname) {[weak self] (responseError, responseData) in
            if let responseError = responseError {
                print(String(describing: responseError.localizedDescription))
                completionHandler(responseError)
            } else if let responseData = responseData {
                self?.repoCommits = responseData.repoCommits
                completionHandler(nil)
            }
        }
    }
}
