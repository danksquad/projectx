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
    static var events: [PFObject] = [] {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "eventsFetched"), object: nil)
        }
    }
    
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
    
    class func getAllEvents() {
        var query = PFQuery(className: "events")
        query.order(byDescending: "start_time")
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            
            if error == nil {
                // find succeeded
                print("Successfully retrieved \(objects!.count) events")
                
                if let objects = objects {
                    self.events = objects
                }
                
            } else {
                self.events = []
            }
        }
    }
}
