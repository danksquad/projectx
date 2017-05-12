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
    
    func getRoomMessages(roomId: String, completion: @escaping ([PFObject]) -> Void) {
        let query = PFQuery(className: "messages")
        query.whereKey("room_id", equalTo: roomId)
        query.findObjectsInBackground { (messages: [PFObject]?, error: Error?) in
            if let messages = messages {
                print("\(roomId) messages received: \(messages.count)")
                completion(messages)
            } else {
                print (error?.localizedDescription)
            }
        }
    }
    
    func subscribeRoomMessages() {
        print("subscribed to room messages")
        let query: PFQuery = PFQuery(className: "messages")
        query.whereKey("room_id", equalTo: roomId)
        
        subscription = lqClient.subscribe(query).handle(ParseLiveQuery.Event.created) { _, obj in

        }

    }
    

}
