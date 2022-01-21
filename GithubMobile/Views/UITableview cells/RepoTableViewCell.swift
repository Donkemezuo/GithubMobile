//
//  RepoTableViewCell.swift
//  GithubMobile
//
//  Created by Raymond Donkemezuo on 1/18/22.
//

import UIKit

/// A repo tableview cell class
class RepoTableViewCell: UITableViewCell {
    static let cellID = "RepoTableViewCell"
    @IBOutlet weak var reponameLabel: UILabel!
    @IBOutlet weak var repoDescriptionTxtView: UITextView!
    var viewCommitsButton: (() -> ())?
    var viewModel: RepoCellViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            self.setupUI(cellViewModel: viewModel)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
    }
    
    @IBAction func viewRepoCommits(_ sender: UIButton) {
        if let block = viewCommitsButton {
            block()
        }
    }
    
    private func setupUI(cellViewModel: RepoCellViewModel) {
        reponameLabel.text = cellViewModel.reponame
        repoDescriptionTxtView.text = cellViewModel.repoDescription
    }
    
}
