//
//  RepositoryCell.swift
//  GitTest
//
//  Created by Nikola Andriiev on 4/4/17.
//  Copyright © 2017 Nikola Andriiev. All rights reserved.
//

import UIKit
import AlamofireImage

class RepositoryCell: UITableViewCell {
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var ownerLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var followersLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func fillWithRepository(_ repository: Repository) {
        self.titleLabel.text = repository.name
        self.ownerLabel.text = repository.owner?.login
        self.descriptionLabel.text = repository.descriptionDetails
        self.followersLabel.text = String(repository.forks_count ?? 0)
        
        self.loadAvatarWithStringURL(repository.owner?.avatar_url)
    }
    
    private func loadAvatarWithStringURL(_ stringURL: String?) {
        guard let string = stringURL, let url = URL(string: string)  else { return }
        let request = URLRequest(url: url)
        let filter = ScaledToSizeCircleFilter(size: CGSize(width: 100.0, height: 100.0))
       _ = imageDownloader?.download(request, receiptID: stringURL!, filter: filter, progress: nil, progressQueue: DispatchQueue.main, completion: { (responce) in
            self.avatarImageView.image = responce.result.value
        })
    }
}
