//
//  ParseClient.swift
//  gathr
//
//  Created by Gates Zeng on 4/19/17.
//  Copyright © 2017 Gates Zeng. All rights reserved.
//

import UIKit
import Parse

class ParseClient: NSObject {
    class func sendMessage(message: String?, withCompletion completion: PFBooleanResultBlock) {
        var newMessage = PFObject(className: "message")
        newMessage["text"] = message!
        newMessage["time_sent"] = Date()
        newMessage["sent_by_id"] = PFUser.current()
        newMessage["likes"] = 0
        newMessage.saveInBackground { (success: Bool, error: Error?) in
            if (success) {
                print("message sent: " + message!)
            } else {
                // check error.description
            }
            
        }
    }


}
