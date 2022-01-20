//
//  RepoTableViewCell.swift
//  GithubMobile
//
//  Created by Raymond Donkemezuo on 1/18/22.
//

import UIKit

class RepoTableViewCell: UITableViewCell {
    static let cellID = "RepoTableViewCell"
    @IBOutlet weak var reponameLabel: UILabel!
    @IBOutlet weak var repoDescriptionTxtView: UITextView!
    var viewCommitsButton: (() -> ())?
    var viewModel: RepoCellViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return;
            }
            self.setupUI(cellViewModel: viewModel)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupUI(cellViewModel: RepoCellViewModel) {
        reponameLabel.text = cellViewModel.reponame
        repoDescriptionTxtView.text = cellViewModel.repoDescription
    }
    
}
