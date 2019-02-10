//
//  SelectionButtonView.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 09/02/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//
import UIKit

enum SelectionButtonType {
    case empty
    case donJuan
    case coolBoy
    case dontCare
    case married
    case livingTogether
    case relationship
}

@IBDesignable
final class SelectionButtonView: CustomView {
    
    @IBOutlet private weak var titleWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var descriptionWidthConstraint: NSLayoutConstraint!
    
    var type: SelectionButtonType = .empty {
        didSet {
            setColor(type: type)
            setTitle(type: type)
            setDescription(type: type)
        }
    }

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var selectionButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
}

// MARK: - Private

private extension SelectionButtonView {
    func setup() {
        
    }
    
    func setColor(type: SelectionButtonType) {
        switch type {
        case .donJuan, .married:
            layer.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.6156862745, blue: 0.5176470588, alpha: 1)
        case .coolBoy, .livingTogether:
            layer.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.7215686275, blue: 0.09411764706, alpha: 1)
        case .dontCare, .relationship:
            layer.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.7019607843, blue: 0.9568627451, alpha: 1)
        default:
            break
        }
    }
    
    func setTitle(type: SelectionButtonType) {
        switch type {
        case .donJuan:
            titleLabel.text = "don_juan_title".localized()
        case .coolBoy:
            titleLabel.text = "cool_boy_title".localized()
        case .dontCare:
            titleLabel.text = "dont_care_title".localized()
        case .married:
            titleLabel.text = "married_title".localized()
        case .livingTogether:
            titleLabel.text = "living_together_title".localized()
        case .relationship:
            titleLabel.text = "relationship_title".localized()
        default:
            break
        }
    }
    
    func setDescription(type: SelectionButtonType) {
        switch type {
        case .donJuan:
            descriptionLabel.text = "don_juan_description".localized()
        case .coolBoy:
            descriptionLabel.text = "cool_boy_description".localized()
        case .dontCare:
            descriptionLabel.text = "dont_care_description".localized()
        case .married, .livingTogether, .relationship:
            titleWidthConstraint.constant = self.bounds.size.width - 48
            descriptionWidthConstraint.constant = 0.0
            descriptionLabel.isHidden = true
        default:
            descriptionLabel.text = ""
        }
    }
}
