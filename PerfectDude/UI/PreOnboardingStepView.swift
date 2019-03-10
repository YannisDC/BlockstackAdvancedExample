//
//  PreOnboardingStepView.swift
//  PerfectUI
//
//  Created by Yannis De Cleene on 13/12/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//
import UIKit

@IBDesignable
final class PreOnboardingStepView: CustomView {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    @IBInspectable var image: UIImage? = nil {
        didSet {
            imageView.image = image?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    @IBInspectable var titleText: String? = nil {
        didSet {
            if let titleText = titleText {
                titleLabel.text = titleText.localized()
//                titleLabel!.setLineSpacing(lineSpacing: 1.2, lineHeightMultiple: 1.2)
            }
        }
    }
    
    @IBInspectable var descriptionText: String? = nil {
        didSet {
            if let descriptionText = descriptionText {
                descriptionLabel.text = descriptionText.localized()
            }
        }
    }
}

// MARK: - Private

private extension PreOnboardingStepView {
    func setup() {
        
    }
}
