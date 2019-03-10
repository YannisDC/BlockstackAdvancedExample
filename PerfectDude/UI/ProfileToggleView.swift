//
//  ProfileToggleView.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 15/02/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import UIKit

@IBDesignable
final class ProfileToggleView: CustomView {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var switchButton: UISwitch!
    
    @IBInspectable var title: String = "" {
        didSet {
            titleLabel.text = title.localized()
        }
    }
    
    @IBInspectable var subTitle: String = "" {
        didSet {
            subTitleLabel.text = subTitle.localized()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
}

// MARK: - Private

private extension ProfileToggleView {
    func setup() {
        titleLabel <- {
            $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            $0.textColor = UIColor.textPrimary
        }
        
        subTitleLabel <- {
            $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            $0.textColor = UIColor.textSecondary
        }
    }
}
