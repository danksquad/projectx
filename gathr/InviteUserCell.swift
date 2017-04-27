//
//  InviteUserCell.swift
//  gathr
//
//  Created by Gates Zeng on 4/26/17.
//  Copyright © 2017 Gates Zeng. All rights reserved.
//

import UIKit

class InviteUserCell: UITableViewCell {
    @IBOutlet weak var firstLastNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
