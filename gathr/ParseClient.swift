//
//  ParseClient.swift
//  gathr
//
//  Created by Gates Zeng on 4/19/17.
//  Copyright © 2017 Gates Zeng. All rights reserved.
//

import UIKit
import Parse
import ParseLiveQuery

class ParseClient: NSObject {
    static var events: [PFObject] = []
    static var users: [PFObject] = []
    
    static var currentUser: PFUser?
    
    // This method will get pull all of the events from the user
    class func getAllEvents(completion: @escaping ([PFObject]?) -> ()) {
        let query = PFQuery(className: "events")
        query.order(byDescending: "start_time")
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            
            if error == nil {
                // find succeeded
                print("Successfully retrieved \(objects!.count) events")
                
                if let objects = objects {
                    completion(objects)
                }
                
            } else {
                completion(nil)
            }
        }
    }
    
    
    // This method will get one event through the room id
    class func getOneEvent(roomId: String, completion: @escaping ([PFObject]) -> Void){
        let query = PFQuery(className: "events")
        query.whereKey("room_id", equalTo: roomId)
        query.findObjectsInBackground { (event: [PFObject]?, error: Error?) in
            if let event = event {
                completion(event)
            } else {
                print (error?.localizedDescription as Any)
            }
        }
        
    }
    
    // This method will get a list of all the users
    class func getAllUsers(completion: @escaping ([PFObject]) -> Void) {
        let query = PFQuery(className: "_User")
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            
            if error == nil {
                print("Successfully pulled \(objects!.count) users")
                
                if let objects = objects {
                    //self.users = objects
                    completion(objects)
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
        invite["seen"] = false
        
        updateInvitedUsers(room_id: room_id, user_id: to_user)
        
        invite.saveInBackground { (success: Bool, error: Error?) in
            if (success) {
                print("invite sent")
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    class func updateInvitedUsers(room_id: String!, user_id: String!) {
        let query = PFQuery(className: "events")
        query.whereKey("room_id", equalTo: room_id!)
        query.getFirstObjectInBackground { (object: PFObject?, error: Error?) in
            if let object = object {
                let event = object
                print("sent invite for room_id: \(event.value(forKey: "room_id")!)")
                event.add(user_id, forKey: "invited_users")
                event.saveInBackground()
            } else {
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    class func getNotifications(toUser: String, completion: @escaping ([PFObject]) -> Void){
        let query = PFQuery(className: "notifications")
        query.whereKey("to_user", equalTo: toUser)
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground { (notifications: [PFObject]?, error: Error?) in
            if let notifications = notifications {
                print(" \(toUser) Succesfuly retrieved \(notifications.count) notifications")
                completion(notifications)
            } else{
                // Log details of the failure
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        }
    }
        
    // This method will generate the random userID or eventID
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
    
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if the image i snot nil
        if let image = image {
            // get image data and check that it is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
    
}
