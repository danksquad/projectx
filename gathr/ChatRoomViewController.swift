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
    var chatroom: Chatroom?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 200
    
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatRoomViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let darkOrange = UIColor(red: 205/255.0, green: 80/255.0, blue: 0.0, alpha: 1.0)
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.tintColor = darkOrange
            navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: darkOrange]
        }
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.sendButton.layer.cornerRadius = 5
        
        chatroom = Chatroom(roomId: roomId)
        
        chatroom?.getRoomMessages(completion: { (messages: [PFObject]) in
            self.messages = messages
            self.tableView.reloadData()
            self.scrollToBottom(animated: true)
        })
        
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
//        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startNewMessages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopNewMessages()
    }
    
    func startNewMessages() {
        print("start listening to new messages")
        chatroom?.subscribeRoomMessages(completion: { (newMessage: PFObject) in
            print("Recieved new message: \(newMessage.value(forKey: "text")!)")
            self.messages!.append(newMessage)
            self.tableView.reloadData()
            self.scrollToBottom(animated: true)
        })
    }
    
    func stopNewMessages() {
        print("stop listening to new messages")
        chatroom?.unsubscribeRoomMessages()
    }
    
    // keeps the tableview at the bottom when new messages arrive
    func scrollToBottom(animated: Bool) {
        let numberOfSections = self.tableView.numberOfSections
        let numberOfRows = self.tableView.numberOfRows(inSection: numberOfSections-1)
        
        if numberOfRows > 0 {
            let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
    }
    
    @IBAction func onSend(_ sender: Any) {
        if self.messageTextField.text != "" {
            chatroom?.sendMessage(message: self.messageTextField.text!, completion: { (success: Bool) in
                if (success) {
                    print("Message sent successfully")
                    self.messageTextField.text = ""
                    self.dismissKeyboard()
                    self.tableView.reloadData()
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

}
