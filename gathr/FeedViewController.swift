//
//  FeedViewController.swift
//  gathr
//
//  Created by Gates Zeng on 4/17/17.
//  Copyright © 2017 Gates Zeng. All rights reserved.
//

import UIKit
import Parse

class FeedViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var events: [PFObject]?

    override func viewDidLoad() {
        super.viewDidLoad()
        let darkOrange = UIColor(red: 205/255.0, green: 80/255.0, blue: 0.0, alpha: 1.0)
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.tintColor = darkOrange
            navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: darkOrange]
        }

        tableView.dataSource = self
        
        ParseClient.getAllEvents { (receivedEvents: [PFObject]?) in
            if let receivedEvents = receivedEvents {
                self.events = receivedEvents
                self.tableView.reloadData()
            }
        }
        
        // creating UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshEvents(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshEvents(_ refreshControl: UIRefreshControl) {
        ParseClient.getAllEvents { (receivedEvents: [PFObject]?) in
            if let receivedEvents = receivedEvents {
                self.events = receivedEvents
                self.tableView.reloadData()
            }
            
            refreshControl.endRefreshing()
        }
    }
    
    @IBAction func onLogout(_ sender: Any) {
        print("user logged out")
        PFUser.logOutInBackground { (error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                //ParseClient.currentUser = nil
                self.performSegue(withIdentifier: "feedToLoginSegue", sender: nil)
            }
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "detailsSegue" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let detailsViewController = segue.destination as! DetailsViewController
            
            let event = self.events?[(indexPath?.row)!]
            detailsViewController.event = event
            
            tableView.deselectRow(at: indexPath!, animated: true)
        }
    }
}

extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.gates.EventCell", for: indexPath) as! EventCell
        
        // getting the labels from the PFObjects
        let currEventName = events?[indexPath.row].object(forKey: "name") as? String
        let currEventDesc = events?[indexPath.row].object(forKey: "eventDescription") as? String
        
        // unwrapping as optional, because we might not have forced event name to be required
        cell.eventDescriptionLabel.text = ""
        if let currEventName = currEventName {
            cell.eventNameLabel.text = currEventName
        }
        if let currEventDesc = currEventDesc {
            cell.eventDescriptionLabel.text = currEventDesc
        }
             
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let events = events {
            return events.count
        }
        return 0
    }
}
