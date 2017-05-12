//
//  ChatRoomViewController.swift
//  gathr
//
//  Created by Jamie Shi on 4/21/17.
//  Copyright © 2017 Gates Zeng. All rights reserved.
//

import UIKit
import Parse
import ParseLiveQuery

let lqClient = ParseLiveQuery.Client()

class ChatRoomViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var roomId: String = ""
    var messages: [PFObject]?
    var subscription: Subscription<PFObject>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.sendButton.layer.cornerRadius = 5

        ParseClient.getRoomMessages(roomId: roomId) { (retrievedMessages: [PFObject]) in
            self.messages = retrievedMessages
            self.tableView.reloadData()
            self.scrollToBottom(animated: true)
        }
        //refreshEverySecond()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        subscribeRoomMessages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
        func refreshEverySecond() {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ChatRoomViewController.onTimer), userInfo: nil, repeats: true)
        self.tableView.reloadData()
    }
    
    func subscribeRoomMessages() {
        print("subscribed to room messages")
        let query: PFQuery = PFQuery(className: "messages")
        query.whereKey("room_id", equalTo: roomId)
        
        subscription = lqClient.subscribe(query).handle(ParseLiveQuery.Event.created) { _, obj in
            print("Recieved new message: \(obj.value(forKey: "text")!)")
            self.messages!.append(obj)
            self.tableView.reloadData()
            self.scrollToBottom(animated: true)
        }
    }
    
    func unsubscribeRoomMessages() {
        let query: PFQuery = PFQuery(className: "messages")
        query.whereKey("room_id", equalTo: roomId)
        lqClient.unsubscribe(query)
    }
    
    func scrollToBottom(animated: Bool) {
        let numberOfSections = self.tableView.numberOfSections
        let numberOfRows = self.tableView.numberOfRows(inSection: numberOfSections-1)
        
        if numberOfRows > 0 {
            let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
    }
    
    
    func onTimer(){
        ParseClient.getRoomMessages(roomId: roomId) { (retrievedMessages: [PFObject]) in
            self.messages = retrievedMessages
            self.tableView.reloadData()
        }
    }
    
    
    @IBAction func onSend(_ sender: Any) {
        
        if self.messageTextField.text != "" {
            ParseClient.sendMessage(message: self.messageTextField.text!, room_id: roomId, completion: { (success: Bool) in
                if (success) {
                    print("message sent successfully")
                    self.messageTextField.text = ""
                }
            })
            
        }
        
        
    }
    
    // MARK: UITableViewDelegate and UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (messages?.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageCell
        
        cell.selectionStyle = .none
        
        let message = messages![indexPath.row]
        let userSent = message["sent_by"] as! [String]
        
        cell.messageLabel.text = message.value(forKey: "text") as! String
        cell.usernameLabel.text = userSent[1]
        
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
