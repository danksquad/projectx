//
//  ChatRoomViewController.swift
//  gathr
//
//  Created by Jamie Shi on 4/21/17.
//  Copyright © 2017 Gates Zeng. All rights reserved.
//

import UIKit
import Parse

class ChatRoomViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.dataSource = self
            self.tableView.delegate = self
        }
    }
    
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton! {
        didSet {
            self.sendButton.layer.cornerRadius = 5
        }
    }
    
    var roomId: String = ""
    var messages: [PFObject]?
    var usernames: [PFObject]?
    var currentRoom: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        let query = PFQuery(className: "chatrooms")
        query.whereKey("room_id", equalTo: roomId)
        query.getFirstObjectInBackground { (room: PFObject?, error: Error?) in
            if let room = room {
                let messages = room["messages"] as! NSArray
                self.messages = messages as NSArray!
                self.currentRoom = room
                self.tableView.reloadData()
            }
        }
        */
        
        ParseClient.getRoomMessages(roomId: roomId) { (retrievedMessages: [PFObject]) in
            self.messages = retrievedMessages
            self.tableView.reloadData()
        }
        
        refreshEverySecond()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
        func refreshEverySecond() {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ChatRoomViewController.onTimer), userInfo: nil, repeats: true)
        self.tableView.reloadData()
    }
 
    
    
    func onTimer(){
        ParseClient.getRoomMessages(roomId: roomId) { (retrievedMessages: [PFObject]) in
            self.messages = retrievedMessages
            self.tableView.reloadData()
        }
        
        /*
        let query = PFQuery(className: "chatrooms")
       // query.order(byDescending: "createdAt")
        
        
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            
            if error == nil {
                self.messages = objects as NSArray!
                self.tableView.reloadData()
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.localizedDescription)")
            }
        }
 */
    }
    
    
    @IBAction func onSend(_ sender: Any) {
        
        if self.messageTextField.text != "" {
            ParseClient.sendMessage(message: self.messageTextField.text!, room_id: roomId, completion: { (success: Bool) in
                if (success) {
                    print("message sent successfully")
                    self.messageTextField.text = ""
                }
            })
            
            /*
            let messageToSend = PFObject()
            messageToSend["text"] = self.messageTextField.text
            messageToSend["user"] = PFUser.current() ?? ""
            
            currentRoom?.add(messageToSend, forKey: "messages")
            currentRoom?.saveInBackground(block: { (success: Bool, error: Error?) in
                if (!success) {
                    print("Message sent.")
                }
                else {
                    print (error?.localizedDescription)
                }
            })
            
            messageToSend.saveInBackground {
                (success: Bool, error: Error?) -> Void in
                if (!success) {
                    print("Error: message not saved")
                }
                else {
                    self.messageTextField.text = ""
                }
            }
 */
        }
        
        
    }
    
    // MARK: UITableViewDelegate and UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (messages?.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageCell
        
        cell.selectionStyle = .none
        
        print("message maybe sent")
        let message = messages![indexPath.row]
        //let userSent = message.value(forKey: "sent_by_id") as! String
        let userSent = message["sent_by"] as! [String]
        
        cell.messageLabel.text = message.value(forKey: "text") as! String
        //cell.usernameLabel.text = userSent.value(forKey: "username") as? String
        cell.usernameLabel.text = userSent[1]
        
      /*  if let user = message["user"] as? PFUser{
            user.fetchInBackground(block: {(user, error) in
                if let user = user as? PFUser{
                    cell.usernameLabel.text = user.username
                }})
        }*/
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
