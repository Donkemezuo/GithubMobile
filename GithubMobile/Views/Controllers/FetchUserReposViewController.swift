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
    private let appDataManager = AppDataManager()
    
    private var doneFetching = false {
        didSet {
            DispatchQueue.main.async {
                self.userReposTableV.reloadData()
                self.setupNavigationTitle()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationTitle()
        registerCells()
        conformToDataSource()
        conformToDelegates()
        fetchData()
        (searchBar.value(forKey: "searchField") as? UITextField)?.textColor = .black
    }
    
    /// A function to fetch data
    private func fetchData() {
        appDataManager.fetchUserRepos(username: appDataManager.currentSearchedUser) { [weak self] error in
            guard let self = self else { return }
            if let _ = error {
                self.showAlert(title: "Error encountered", message: "Unexpected error encountered")
            } else {
                self.doneFetching = true
            }
        }
    }
    
    /// A function to set navigation bar title
    private func setupNavigationTitle() {
        title = appDataManager.titleText
    }
    
    /// A function to register tableview cell
    private func registerCells() {
        userReposTableV.register(UINib(nibName: RepoTableViewCell.cellID, bundle: nil), forCellReuseIdentifier: RepoTableViewCell.cellID)
        userReposTableV.register(UINib(nibName: ErrorMessageTableViewCell.cellID, bundle: nil), forCellReuseIdentifier: ErrorMessageTableViewCell.cellID)
    }
    
    /// A function to conform to the UITableview Datasource
    private func conformToDataSource() {
        userReposTableV.dataSource = self
    }
    
    /// A function to conform to the delegates
    private func conformToDelegates() {
        userReposTableV.delegate = self
        searchBar.delegate = self
    }
    
}

extension FetchUserReposViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDataManager.userRepos.isEmpty ? 1 : appDataManager.userRepos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if appDataManager.userRepos.isEmpty {
            guard let errorMessageCell = tableView.dequeueReusableCell(withIdentifier: ErrorMessageTableViewCell.cellID, for: indexPath) as? ErrorMessageTableViewCell else { return UITableViewCell() }
            let viewModel = ErrorMessageCellViewModel(errorMessage: "\(appDataManager.currentSearchedUser) have no repo")
            errorMessageCell.viewModel = viewModel
            return errorMessageCell
        } else {
            guard let repoCell = tableView.dequeueReusableCell(withIdentifier: RepoTableViewCell.cellID, for: indexPath) as? RepoTableViewCell else { return UITableViewCell() }
            let repo = appDataManager.userRepos[indexPath.row]
            let cellViewModel = RepoCellViewModel(reponame: repo.reponame, repoDescription: repo.description ?? "Repo has no description")
            repoCell.viewModel = cellViewModel
            repoCell.viewCommitsButton = {
                self.showRepoCommits(selectedRepo: repo.reponame)
            }
            return repoCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return appDataManager.userRepos.isEmpty ? tableView.frame.height : 150
    }
    
    /// A function to handle the segueing to details view when view commits button is pressed
    /// - Parameter selectedRepo: a selected repo
    private func showRepoCommits(selectedRepo: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let commitsViewController = storyboard.instantiateViewController(identifier: "FetchRepoCommitsViewController", creator: { coder in
            return FetchRepoCommitsViewController(coder: coder, reponame: selectedRepo, username: self.appDataManager.currentSearchedUser)
        })
        navigationController?.pushViewController(commitsViewController, animated: true)
    }
}

extension FetchUserReposViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text,
              !searchText.isEmpty else { return }
        appDataManager.currentSearchedUser = searchText
        fetchData()
        view.endEditing(true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resignFirstResponder()
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
}
