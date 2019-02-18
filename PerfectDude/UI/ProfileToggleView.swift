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
            titleLabel.text = title
        }
    }
    
    @IBInspectable var subTitle: String = "" {
        didSet {
            subTitleLabel.text = subTitle
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
    
    }
}
