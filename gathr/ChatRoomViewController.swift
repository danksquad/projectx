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
    
    var messages: [PFObject]?
    var usernames: [PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let query = PFQuery(className: "messages")
        query.order(byDescending: "createdAt")
        
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            
            if error == nil {
                self.messages = objects
                self.tableView.reloadData()
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.localizedDescription)")
            }
        }
    }
    
    @IBAction func onSend(_ sender: Any) {
        if self.messageTextField.text != "" {
            let messageToSend = PFObject(className: "messages")
            messageToSend["text"] = self.messageTextField.text
            messageToSend["user"] = PFUser.current() ?? ""
            messageToSend.saveInBackground {
                (success: Bool, error: Error?) -> Void in
                if (!success) {
                    print("Error: message not saved")
                }
                else {
                    self.messageTextField.text = ""
                }
            }
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
        cell.messageLabel.text = message["text"] as? String
        
        if let user = message["user"] as? PFUser{
            user.fetchInBackground(block: {(user, error) in
                if let user = user as? PFUser{
                    cell.usernameLabel.text = user.username
                }})
        }
        
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
