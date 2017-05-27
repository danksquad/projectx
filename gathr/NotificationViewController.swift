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
import ParseLiveQuery

let lqtClient = ParseLiveQuery.Client()

class NotificationViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var notifications: [PFObject]?
    var events: [PFObject]?
    var hosts: [PFObject]?
    var userToken = ""
    var seenMark: Bool?
    var eventTime: NSDate?
    var refreshControl: UIRefreshControl!
    var subscription: Subscription<PFObject>?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let darkOrange = UIColor(red: 205/255.0, green: 80/255.0, blue: 0.0, alpha: 1.0)
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.tintColor = darkOrange
            navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: darkOrange]
        }
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorColor = UIColor.black
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
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
        // Configure User Notification Center
        UNUserNotificationCenter.current().delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        startNewNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        stopNewNotifications()
    }
    
    func startNewNotifications() {
        print("start listening to new notifications")
        suscribeNotifications(toUser: userToken) { (retrievedNotification: PFObject) in
            self.notifications!.append(retrievedNotification)
            self.tableView.reloadData()
        }


    }
    
    func stopNewNotifications() {
        print("stop listening to new notifications")
        unsuscribeNotifications(toUser: userToken)
    }
    // creates a new subscription using ParseLiveQuery to get new messages
     func suscribeNotifications(toUser: String, completion: @escaping (PFObject) -> Void) {
        print("subscribed to notifications")
        let query: PFQuery = PFQuery(className: "notifications")
        query.whereKey("to_user", equalTo: toUser)
        
        
        subscription = lqtClient.subscribe(query).handle(ParseLiveQuery.Event.created) { _, obj in
            completion(obj)
        }
        
    }
    
    // cancels the subscription so that new messages are not received
     func unsuscribeNotifications(toUser: String) {
        let query: PFQuery = PFQuery(className: "notifications")
        query.whereKey("to_user", equalTo: toUser)
        lqtClient.unsubscribe(query)
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
               // print("getting date!")
               // print(eventStartTime)
                cell.eventDateLabel.text = formatter.string(from: eventStartTime as! Date)
                
                
                let currEventSeenStatus = notification.object(forKey: "seen") as? Bool;
                if let seen = currEventSeenStatus{
                    if(seen == true){
                        self.seenMark = true;
                        cell.eventSeenLabel.text = ""//"Seen: \(seen)"
                    }
                    else{
                        self.seenMark = false;
                        cell.eventSeenLabel.text = ""
                        print("Alert Created!")
            
                    
                    //defining notification contents
                    let content = UNMutableNotificationContent()
                    content.title = currRoomName as! String
                    content.body = currDescription as! String
                    content.sound = UNNotificationSound.default()
                    
                    //making notification request
                    let date = self.eventTime
                    let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date! as Date)
                        
                    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                    let request = UNNotificationRequest(identifier: currRoomName as! String, content: content, trigger: trigger)
                    UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
                    UNUserNotificationCenter.current().add(request) {(error) in
                        if (error != nil){
                            print(error?.localizedDescription ?? "error")
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
            
        }
        
        
        return cell
        
    }
    
    
    
}
extension NotificationViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

    }
}


