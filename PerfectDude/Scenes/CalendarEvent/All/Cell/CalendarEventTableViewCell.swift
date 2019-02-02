//
//  CalendarEventTableViewCell.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 02/02/2019.
//  Copyright © 2019 yannisdecleene. All rights reserved.
//

import UIKit

class CalendarEventTableViewCell: UITableViewCell {

    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bind(_ viewModel:CalendarEventItemViewModel) {
        self.dateLabel.text = viewModel.dateText
        self.descriptionLabel.text = viewModel.description
    }
    
}
