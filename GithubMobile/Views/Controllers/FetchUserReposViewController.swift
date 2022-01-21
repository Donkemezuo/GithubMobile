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
    
    private func fetchData() {
        appManager.fetchUserRepos(username: appManager.currentSearchedUser) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                // Handle erorr appropriately
                print(error.errorMessage)
            } else {
                self.doneFetching = true
            }
        }
    }
    
    private func setupNavigationTitle() {
        title = appManager.titleText
    }
    
    private func registerCells() {
        userReposTableV.register(UINib(nibName: RepoTableViewCell.cellID, bundle: nil), forCellReuseIdentifier: RepoTableViewCell.cellID)
    }
    
    private func conformToDataSource() {
        userReposTableV.dataSource = self
    }
    
    private func conformToDelegates() {
        userReposTableV.delegate = self
        searchBar.delegate = self
    }
    
}

extension FetchUserReposViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appManager.userRepos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let repoCell = tableView.dequeueReusableCell(withIdentifier: RepoTableViewCell.cellID, for: indexPath) as? RepoTableViewCell else { return UITableViewCell() }
        let repo = appManager.userRepos[indexPath.row]
        let cellViewModel = RepoCellViewModel(reponame: repo.reponame, repoDescription: repo.description ?? "Repo has no description")
        repoCell.viewModel = cellViewModel
        repoCell.viewCommitsButton = {
            self.showRepoCommits(selectedRepo: repo.reponame)
        }
        return repoCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    private func showRepoCommits(selectedRepo: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let commitsViewController = storyboard.instantiateViewController(identifier: "FetchRepoCommitsViewController", creator: { coder in
            return FetchRepoCommitsViewController(coder: coder, reponame: selectedRepo, username: self.appManager.currentSearchedUser)
        })
        navigationController?.pushViewController(commitsViewController, animated: true)
    }
}

extension FetchUserReposViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text,
              !searchText.isEmpty else { return }
        appManager.currentSearchedUser = searchText
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
