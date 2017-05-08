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
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
