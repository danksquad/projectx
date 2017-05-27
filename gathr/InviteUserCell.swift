//
//  InviteUserCell.swift
//  gathr
//
//  Created by Gates Zeng on 4/26/17.
//  Copyright © 2017 Gates Zeng. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class InviteUserCell: UITableViewCell {
    @IBOutlet weak var firstLastNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileView: PFImageView!
    
    var thisUser: PFObject! {
        didSet {
            if let profileImage = thisUser["profile_image"] as! PFFile? {
                self.profileView.file = profileImage
                self.profileView.loadInBackground()
            }
            self.profileView.layer.cornerRadius = 10
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
