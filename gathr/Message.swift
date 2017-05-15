//
//  Message.swift
//  gathr
//
//  Created by Gates Zeng on 5/10/17.
//  Copyright © 2017 Gates Zeng. All rights reserved.
//

import UIKit
import Parse

class Message: PFObject {
    var authorFirstName: String?
    var authorLastName: String?
    var authorUser: PFUser?
    var roomId: String?
    var likes: Int?
    var text: String?

}
