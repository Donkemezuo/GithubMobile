//
//  ErrorMessageTableViewCell.swift
//  GithubMobile
//
//  Created by Raymond Donkemezuo on 1/21/22.
//

import UIKit

class ErrorMessageTableViewCell: UITableViewCell {
    static let cellID = "ErrorMessageTableViewCell"
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    var viewModel: ErrorMessageCellViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            errorMessageLabel.text = viewModel.errorMessage
        }
    }
    
}
