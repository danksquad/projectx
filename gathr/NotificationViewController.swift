//
//  NotificationViewController.swift
//  gathr
//
//  Created by Gates Zeng on 4/20/17.
//  Copyright © 2017 Gates Zeng. All rights reserved.
//

import UIKit
import Parse

class NotificationViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.dataSource = self
            self.tableView.delegate = self
        }
    }
    
    var notifications: [PFObject]?
    var event: [PFObject]?
    var userToken = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get current user
        let currentUser = PFUser.current()
        let userId = currentUser?["user_id"]
        if let userId = userId{
            userToken = userId as! String
        }
       
        
        ParseClient.getNotifications(toUser: userToken) { (retrievedNotifications: [PFObject]) in
            self.notifications = retrievedNotifications
            self.tableView.reloadData()
            
        }
        
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension NotificationViewController: UITableViewDataSource, UITableViewDelegate{
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let notifications = notifications{
            return (notifications.count)
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationsCELL", for: indexPath) as! NotificationCell
        
        let notification = notifications![indexPath.row]
        
        
        // getting the labels from the PFObjects
        let currEventSeenStatus = notification.value(forKey: "seen") as? DarwinBoolean
        
        
        let currEventName = notification.value(forKey: "room_id") as? String
       // cell.eventNameLabel.text = currEventName

        let currEventFromUser = notification.value(forKey: "from_user") as? String
        cell.eventDateLabel.text = currEventFromUser
        
        
        ParseClient.getOneEvent(roomId: currEventName!) { (retrievedEvent:[PFObject]) in
            self.event = retrievedEvent
            print("here we go!")
            
            let eventName = self.event![indexPath.row]
        
            let temp = ""
            if let temp = eventName.value(forKey: "name"){
                cell.eventNameLabel.text = temp as? String
            }
            print(temp)
        }
        
        
        // unwrapping as optional, because we might not have forced event name to be required
        
        if let seen = currEventSeenStatus{
            if(seen == true){
                cell.eventSeenLabel.text = "Seeeeen ✔"
            }
            else{
                cell.eventSeenLabel.text = "Not Seen"
            }
        }
       // if let name = currEventName{
           // cell.eventNameLabel.text = name
       // }
        
               return cell
        
    }
    
}
