//
//  EventCell.swift
//  gathr
//
//  Created by Gates Zeng on 4/20/17.
//  Copyright © 2017 Gates Zeng. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
