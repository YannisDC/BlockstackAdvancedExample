//
//  UILabel+Extension.swift
//  PerfectUI
//
//  Created by Yannis De Cleene on 13/12/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import Foundation

extension UILabel {
    
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0, alignment: NSTextAlignment = .center) {
        
        guard let labelText = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        paragraphStyle.alignment = alignment
        
        let attributedString: NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        let range = NSRange(location: 0, length: attributedString.length)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                      value: paragraphStyle,
                                      range: range)
        
        self.attributedText = attributedString
    }
}

//infix operator <-
//
//@discardableResult
//func <- <T: AnyObject>(value: T, modify: (T) -> Void) -> T {
//    modify(value)
//    return value
//}
