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
    var roomID: String?
    
    init(name: String, location: String,eventDescription: String, startTime: Date, endTime: Date){
        self.name = name
        self.location = location
        self.eventDescription = eventDescription
        self.startTime = startTime
        self.endTime = endTime
    }
    
    class func postEvent(name: String?, location: String?, eventDescription: String?, startTime: Date, endTime: Date, withCompletion completion: PFBooleanResultBlock?){
        let roomID = "e_" + ParseClient.generateUID(length: 12)
        
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
    

}
