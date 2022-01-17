//
//  FetchUserReposResponseModel.swift
//  GithubMobile
//
//  Created by Raymond Donkemezuo on 1/17/22.
//

import Foundation

struct FetchUserReposResponseModel: Codable {
    var userRepos: [UserRepo]
}

struct UserRepo: Codable {
    let reponame: String
}
