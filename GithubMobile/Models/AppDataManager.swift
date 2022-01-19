//
//  AppDataManager.swift
//  GithubMobile
//
//  Created by Raymond Donkemezuo on 1/18/22.
//

import Foundation

class AppDataManager {
    private let webservice = Webservice()
    var currentSearchedUser = "Donkemezuo"
    var userRepos = [UserRepo]()
    
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
    
}
