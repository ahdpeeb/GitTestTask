//
//  CommitCell.swift
//  GitTest
//
//  Created by Nikola Andriiev on 4/7/17.
//  Copyright © 2017 Nikola Andriiev. All rights reserved.
//

import UIKit

class CommitCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func fillWithCommit(_ commit: Commit) {
        self.nameLabel.text = commit.committerName
        self.dateLabel.text =  commit.committerDateString()
        self.descriptionLabel.text = commit.message
    }
}
