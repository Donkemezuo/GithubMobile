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
    let repoCreatedString: String
    let description: String?
    var createdDate: Date {
        return repoCreatedString.formatDateStringToMMDDyyyy(dateFormat: "MMMM dd, yyyy")
    }
    enum CodingKeys: String, CodingKey {
        case reponame = "name"
        case repoCreatedString = "created_at"
        case description
    }
}
