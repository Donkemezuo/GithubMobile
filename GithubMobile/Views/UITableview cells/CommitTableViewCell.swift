//
//  CommitTableViewCell.swift
//  GithubMobile
//
//  Created by Raymond Donkemezuo on 1/19/22.
//

import UIKit

/// Commit tableview cell class
class CommitTableViewCell: UITableViewCell {
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var commitMessageLabel: UILabel!
    @IBOutlet weak var hashLabel: UILabel!
    
    static let cellID = "CommitTableViewCell"
    var viewModel: CommitCellViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            setupUI(viewModel: viewModel)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
    }
    
    private func setupUI(viewModel: CommitCellViewModel) {
        authorLabel.text = viewModel.authorname
        commitMessageLabel.text = viewModel.commitMessageText
        hashLabel.text = viewModel.hashString
        commitMessageLabel.textColor = .white
        authorLabel.textColor = .white
        hashLabel.textColor = .white
    }
    
}
