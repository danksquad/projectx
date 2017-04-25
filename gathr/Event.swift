//
//  Event.swift
//  gathr
//
//  Created by Oscar Reyes on 4/17/17.
//  Copyright © 2017 Gates Zeng. All rights reserved.
//

import UIKit
import Parse

class Event: NSObject {
    
    var name: String?
    var location: String?
    var eventDescription: String?
    var startTime: Date
    var endTime: Date
    
    init(name: String, location: String,eventDescription: String, startTime: Date, endTime: Date){
        self.name = name
        self.location = location
        self.eventDescription = eventDescription
        self.startTime = startTime
        self.endTime = endTime
    }
    
    class func postEvent(name: String?, location: String?, eventDescription: String?, startTime: Date, endTime: Date, withCompletion completion: PFBooleanResultBlock?){
        let roomID = self.generateUID(length: 12)
        
        // Create Parse object PFObject
        let event = PFObject(className: "events")
        
        event["name"] = name
        event["location"] = location
        event["eventDescription"] = eventDescription
        event["startTime"] = startTime
        event["endTime"] = endTime
        event["room_id"] = roomID

        // Save object (following function will save the object in Parse asynchronously)
        event.saveInBackground(block: completion)
        
        // Create chatroom
        let chatroom = PFObject(className: "chatrooms")
        
        chatroom["room_id"] = roomID
        
        chatroom.saveInBackground(block: completion)
        
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
