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
    static var users: [PFObject] = [] {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "usersFetched"), object: nil)
        }
    }
    
    static var currentUser: PFUser?
    
    // This method will send the message to the messages database (not in use at the moment)
    class func sendMessage(message: String?, withCompletion completion: PFBooleanResultBlock) {
        let newMessage = PFObject(className: "messages")
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
    
    // This method will get pull all of the events from the user
    class func getAllEvents() {
        let query = PFQuery(className: "events")
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
    
    // This method will get a list of all the users
    class func getAllUsers() {
        let query = PFQuery(className: "_User")
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            
            if error == nil {
                print("Successfully pulled \(objects!.count) users")
                
                if let objects = objects {
                    self.users = objects
                }
            } else {
                self.events = []
            }
        }
    }
    
    
    // This method will push a notification to the notification database
    class func sendInvite(from_user: String?, to_user: String?, room_id: String?, withCompletion completion: PFBooleanResultBlock) {
        let invite = PFObject(className: "notifications")
        
        invite["from_user"] = from_user
        invite["to_user"] = to_user
        invite["room_id"] = room_id
        
        invite.saveInBackground { (success: Bool, error: Error?) in
            if (success) {
                print("invite sent")
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    
    class func generateUID(length: Int) -> String {
        let letters: NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var uid = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(UInt32(letters.length))
            var nextChar = letters.character(at: Int(rand))
            uid += NSString(characters: &nextChar, length: 1) as String
        }
        
        return uid
    }
    
}
