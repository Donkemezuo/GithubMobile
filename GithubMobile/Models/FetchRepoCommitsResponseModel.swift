//
//  FetchRepoCommitsResponseModel.swift
//  GithubMobile
//
//  Created by Raymond Donkemezuo on 1/17/22.
//

import Foundation

struct FetchRepoCommitsResponseModel: Codable {
    let repoCommits: [Commit]
}
struct Commit: Codable {
    let commit: CommitDetails
    let commitHash: String
    
    enum CodingKeys: String, CodingKey {
        case commit
        case commitHash = "sha"
    }
}
struct CommitDetails: Codable {
    let author: CommitAuthor
    let message: String
}
struct CommitAuthor: Codable {
    let name: String
    let date: String
}
