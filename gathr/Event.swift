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
    var locationLong: Int?
    var locationLat: Int?
    
    init(name: String, location: String,eventDescription: String, startTime: Date, endTime: Date) {
        self.name = name
        self.location = location
        self.eventDescription = eventDescription
        self.startTime = startTime
        self.endTime = endTime
    }
    
    class func postEvent(name: String?, location: String?, eventDescription: String?, startTime: Date, endTime: Date, locationLong: Double?, locationLat:Double?, withCompletion completion: PFBooleanResultBlock?){
        let roomID = "e_" + ParseClient.generateUID(length: 12)
        let userId = PFUser.current()?.value(forKey: "user_id") as! String
        
        // Create Parse object PFObject
        let event = PFObject(className: "events")
        
        event["name"] = name
        event["location"] = location
        event["eventDescription"] = eventDescription
        event["startTime"] = startTime
        event["endTime"] = endTime
        event["room_id"] = roomID
        event["invited_users"] = [userId]
        
        if let locationLong = locationLong {
            event["location_long"] = locationLong
            event["location_lat"] = locationLat!
            print("locationLong: \(locationLong)")
            print("locationLat: \(locationLat!)")
        } else {
            print("no location saved")
            event["location_long"] = 0
            event["location_lat"] = 0
        }
        


        
        // Save object (following function will save the object in Parse asynchronously)
        event.saveInBackground(block: completion)
        
        /*
        // Create chatroom
        let chatroom = PFObject(className: "chatrooms")
        
        chatroom["room_id"] = roomID
        chatroom["messages"] = ["test message"]
        
        chatroom.saveInBackground(block: completion)
        */
        
    }
    

}
