//
//  LikeTableViewCell.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 21/11/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import UIKit

class LikeTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionTitle: UILabel!
    @IBOutlet private weak var thumbnailView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setup()
    }

    func bind(_ viewModel:LikeItemViewModel) {
        self.titleLabel.text = viewModel.title
        self.thumbnailView.image = viewModel.image
        self.descriptionTitle.text = viewModel.tags.first
        
        thumbnailView <- {
            $0.layer.cornerRadius = 4.0
            $0.layer.masksToBounds = true
        }
    }
}

private extension LikeTableViewCell {
    func setup() {
        accessoryType = .disclosureIndicator
        
        titleLabel <- {
            $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            $0.textColor = UIColor.textPrimary
        }
        
        descriptionTitle <- {
            $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            $0.textColor = UIColor.textSecondary
        }
    }
}
