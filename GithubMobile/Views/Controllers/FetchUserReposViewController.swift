//
//  FetchUserReposViewController.swift
//  GithubMobile
//
//  Created by Raymond Donkemezuo on 1/18/22.
//

import UIKit

class FetchUserReposViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var userReposTableV: UITableView!
    private let appManager = AppDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Test title"
        fetchData()
    }
    
    private func fetchData() {
        appManager.fetchUserRepos(username: appManager.currentSearchedUser) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                // Handle erorr appropriately
                print(error.errorMessage)
            } else {
            self.appManager.userRepos.map{print($0.createdDate)}
            }
        }
        
    }
    

}
