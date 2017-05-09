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
    @IBOutlet weak var tableView: UITableView!
    
    var notifications: [PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(NotificationViewController.refreshEvents), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func refreshEvents() {
        ParseClient.getAllEvents()
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
    
    func loadItems(){
        let query = PFQuery(className: "notifications")
        query.order(byDescending: "createdAt")
    
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) -> Void in
            
            if error == nil{
                //succeeded
                print("Succesfuly retrieved \(objects!.count) events")
                
                if let objects = objects{
                    self.notifications = objects
                }
                self.tableView.reloadData()
            }
            else{
                self.notifications = []
                // Log details of the failure
                print("Error: \(error!) \(error!.localizedDescription)")
            }
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationsCELL", for: indexPath) as! NotificationCell
        
        // getting the labels from the PFObjects
        let currEventSeenStatus = notifications?[indexPath.row].object(forKey: "seen") as? String
        let currEventRoom = notifications?[indexPath.row].object(forKey: "room_id") as? String
        
        // unwrapping as optional, because we might not have forced event name to be required
        
        print(currEventSeenStatus)
        
        if let seen = currEventSeenStatus{
            cell.eventSeenLabel.text = seen
        }
        if let room = currEventRoom{
            cell.eventNameLabel.text = room
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let notifications = notifications{
            return notifications.count
        }
        return 0
    }
}
