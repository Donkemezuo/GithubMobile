//
//  CommitCellViewModel.swift
//  GithubMobile
//
//  Created by Raymond Donkemezuo on 1/19/22.
//

import Foundation


struct CommitCellViewModel {
    let authorname: String
    let message: String
    let hashString: String
    var commitMessageText: String {
        return
            """
            " \(message) "
            """

    }
}
