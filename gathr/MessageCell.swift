//
//  MessageCell.swift
//  gathr
//
//  Created by Jamie Shi on 4/21/17.
//  Copyright © 2017 Gates Zeng. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView! {
        didSet {
            self.profileImage.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var messageContainer: UIView! {
        didSet {
            self.messageContainer.layer.cornerRadius = 5
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
