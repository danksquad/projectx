//
//  MessageCell.swift
//  gathr
//
//  Created by Jamie Shi on 4/21/17.
//  Copyright © 2017 Gates Zeng. All rights reserved.
//

import UIKit
import ParseUI

class MessageCell: UITableViewCell {

    @IBOutlet weak var profileImage: PFImageView! {
        didSet {
            self.profileImage.layer.cornerRadius = 5
        }
    }
    
    var objectId: String! {
        didSet {
            var query = PFQuery(className:"_User")
            query.getObjectInBackground(withId: objectId) {
                (currUser: PFObject?, error: Error?) -> Void in
                if let profileImage = currUser?["profile_image"] as! PFFile? {
                    self.profileImage.file = profileImage
                    self.profileImage.loadInBackground()
                }
                else {
                    print(error)
                }
            }

        }
        
        
    }
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var messageContainer: UIView! {
        didSet {
            self.messageContainer.layer.cornerRadius = 10
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
