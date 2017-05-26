//
//  NotificationViewController.swift
//  gathr
//
//  Created by Gates Zeng on 4/20/17.
//  Copyright © 2017 Gates Zeng. All rights reserved.
//

import UIKit
import Parse
import UserNotifications

class NotificationViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var notifications: [PFObject]?
    var events: [PFObject]?
    var hosts: [PFObject]?
    var userToken = ""
    var seenMark: Bool?
    var eventTime: NSDate?
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let darkOrange = UIColor(red: 205/255.0, green: 80/255.0, blue: 0.0, alpha: 1.0)
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.tintColor = darkOrange
            navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: darkOrange]
        }
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        //Set Refresh Control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshEvents(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        
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
    
    func refreshEvents(_ refreshControl: UIRefreshControl) {
        ParseClient.getNotifications(toUser: userToken) { (retrievedNotifications: [PFObject]) in
            self.notifications = retrievedNotifications
            self.tableView.reloadData()
        }
        
        refreshControl.endRefreshing()
    }
}


/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */



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
        let currEventSeenStatus = notification.object(forKey: "seen") as? Bool;
        if let seen = currEventSeenStatus{
            if(seen == true){
                seenMark = true;
                cell.eventSeenLabel.text = "Seen: \(seen)"
            }
            else{
                seenMark = false;
                cell.eventSeenLabel.text = "Seen: \(seen)"
            }
        }
        
        let currHost = notification.value(forKey: "from_user") as? String
        
        ParseClient.getOneUser(host: currHost!, completion: { ( retrievedHost:[PFObject]) in
            self.hosts = retrievedHost
            let host = self.hosts![indexPath.section]
            
            if let currHost = host.value(forKey: "firstName"){
                cell.eventHostNameLabel.text = ("from: \(currHost)")
            }
        })
        
        
        
        let currRoomId = notification.value(forKey: "room_id") as? String
        ParseClient.getOneEvent(roomId: currRoomId!) { (retrievedEvent: [PFObject]) in
            self.events = retrievedEvent
            let event = self.events![indexPath.section]
            
            let currRoomName = event.value(forKey: "name")
            cell.eventNameLabel.text = currRoomName as? String
            
            let currDescription = event.value(forKey: "eventDescription")
            
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .medium
            
            if let eventStartTime = event.value(forKey: "startTime") {
                self.eventTime = eventStartTime as? NSDate
                print("getting date!")
                print(eventStartTime)
                cell.eventDateLabel.text = formatter.string(from: eventStartTime as! Date)
                
                
                if(self.seenMark == false){
                    print("Alert Created!")

                     /*let notification = UILocalNotification()
                     notification.alertTitle = currRoomName as! String
                     notification.alertBody = currDescription as! String
                     notification.alertAction = "open"
                     notification.fireDate = self.eventTime as Date?
                     notification.soundName = UILocalNotificationDefaultSoundName
                     UIApplication.shared.scheduleLocalNotification(notification)
                     print("Alert Created!") */
                    
                    //////NEW SWIFT SYNTAX///////
                    
                    //defining notification contents
                    let content = UNMutableNotificationContent()
                    content.title = currRoomName as! String
                    content.body = currDescription as! String
                    content.sound = UNNotificationSound.default()
                    
                    //adding image
                    /*  if let path = Bundle.main.path(forResource: "60x60", ofType: "png") {
                     let url = URL(fileURLWithPath: path)
                     
                     do {
                     let attachment = try UNNotificationAttachment(identifier: "60x60", url: url, options: nil)
                     content.attachments = [attachment]
                     } catch {
                     print("The attachment was not loaded.")
                     }
                     }*/
                    
                    //making notification request
                    let trigger = UNCalendarNotificationTrigger(dateMatching: eventStartTime as! DateComponents, repeats: false)
                    let request = UNNotificationRequest(identifier: currRoomName as! String, content: content, trigger: trigger)
                    UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
                    UNUserNotificationCenter.current().add(request) {(error) in
                        if (error != nil){
                            print(error?.localizedDescription)
                        }
                    }
                    print("Alert Created!")
                    // create the controller
                    let messageController = UIAlertController(title: "Notification Created!", message: "Notification Created for \(currRoomName!)", preferredStyle: .alert)
                    
                    // create an OK action
                    let OKAction = UIAlertAction(title: "OK", style: .default)
                    
                    // add the OK action to the alert controller
                    messageController.addAction(OKAction)
                    
                    self.present(messageController, animated: true)
                }
                
                notification.setValue(true, forKeyPath: "seen")
                notification.saveInBackground()
            }
            
        }
        
        
        return cell
        
    }
    
    
    
}


