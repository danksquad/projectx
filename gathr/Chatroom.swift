//
//  Chatroom.swift
//  gathr
//
//  Created by Gates Zeng on 5/12/17.
//  Copyright © 2017 Gates Zeng. All rights reserved.
//

import UIKit
import Parse
import ParseLiveQuery


class Chatroom: NSObject {
    let lqClient = ParseLiveQuery.Client()
    var roomId: String?
    var subscription: Subscription<PFObject>?
    
    init(roomId: String!) {
        self.roomId = roomId
    }
    
    // gets all of the messages within the room
    func getRoomMessages(completion: @escaping ([PFObject]) -> Void) {
        let query = PFQuery(className: "messages")
        query.whereKey("room_id", equalTo: roomId!)
        query.findObjectsInBackground { (messages: [PFObject]?, error: Error?) in
            if let messages = messages {
                print("\(self.roomId!) messages received: \(messages.count)")
                completion(messages)
            } else {
                print (error?.localizedDescription)
            }
        }
    }
    
    // creates a new subscription using ParseLiveQuery to get new messages
    func subscribeRoomMessages(completion: @escaping (PFObject) -> Void) {
        print("subscribed to room messages")
        let query: PFQuery = PFQuery(className: "messages")
        query.whereKey("room_id", equalTo: roomId!)
        
        subscription = lqClient.subscribe(query).handle(ParseLiveQuery.Event.created) { _, obj in
            completion(obj)
        }

    }
    
    // cancels the subscription so that new messages are not received
    func unsubscribeRoomMessages() {
        let query: PFQuery = PFQuery(className: "messages")
        query.whereKey("room_id", equalTo: roomId!)
        lqClient.unsubscribe(query)
    }
    
    func sendMessage(message: String, completion: @escaping (Bool) -> Void) {
        let currUser: PFUser = PFUser.current()!
        let userObject: [String] = [currUser.objectId!, currUser.username!, currUser["firstName"] as! String, currUser["lastName"] as! String]
        let newMessage = PFObject(className: "messages")
        
        newMessage["sent_by"] = userObject
        newMessage["room_id"] = roomId!
        newMessage["likes"] = 0
        newMessage["text"] = message
        
        newMessage.saveInBackground { (success: Bool, error: Error?) in
            if (success) {
                print("message sent: " + message)
            } else {
                print(error?.localizedDescription)
            }
            completion(success)
        }
    }
    

}
