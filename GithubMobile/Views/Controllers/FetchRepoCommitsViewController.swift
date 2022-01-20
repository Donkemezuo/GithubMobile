//
//  FetchRepoCommitsViewController.swift
//  GithubMobile
//
//  Created by Raymond Donkemezuo on 1/19/22.
//

import UIKit

class FetchRepoCommitsViewController: UIViewController {
    @IBOutlet weak var commitsTableView: UITableView!
    private var reponame: String
    private var username: String
    private let appDataManager = AppDataManager()
    private var doneFetching = false {
        didSet {
            DispatchQueue.main.async {
                self.commitsTableView.reloadData()
            }
        }
    }
    
    init?(coder: NSCoder, reponame: String, username: String) {
        self.reponame = reponame
        self.username = username
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationTitle()
        fetchRepoCommits()
        registerCells()
        conformToDataSource()
    }
    
    private func fetchRepoCommits() {
        appDataManager.fetchRepoCommits(username: username, reponame: reponame) { [weak self] responseError in
            guard let self = self else { return }
            if let responseError = responseError {
                print(responseError.errorMessage)
            } else {
                self.doneFetching = true
            }
        }
    }
    
    private func setupNavigationTitle() {
        navigationItem.largeTitleDisplayMode = .never
        title = "Commits"
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func registerCells() {
        commitsTableView.register(UINib(nibName: CommitTableViewCell.cellID, bundle: nil), forCellReuseIdentifier: CommitTableViewCell.cellID)
    }
    
    private func conformToDataSource() {
        commitsTableView.dataSource = self
        commitsTableView.delegate = self
    }
}

extension FetchRepoCommitsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDataManager.repoCommits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let commitCell = tableView.dequeueReusableCell(withIdentifier: CommitTableViewCell.cellID, for: indexPath) as? CommitTableViewCell else { return UITableViewCell() }
        let commit = appDataManager.repoCommits[indexPath.row]
        let viewModel = CommitCellViewModel(authorname: commit.commit.author.name, message: commit.commit.message, hashString: commit.commitHash)
        commitCell.viewModel = viewModel
        return commitCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView().estimatedRowHeight
    }
}
