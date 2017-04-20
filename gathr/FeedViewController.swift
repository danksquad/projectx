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

        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "eventsFetched"), object: nil, queue: OperationQueue.main) { (notification: Notification) in
            self.events = ParseClient.events
            self.tableView.reloadData()
        }
        
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(FeedViewController.refreshEvents), userInfo: nil, repeats: true)
        
        //refreshEvents()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(_ sender: Any) {
        print("user logged out")
        PFUser.logOutInBackground { (error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            }
            
        }
        self.dismiss(animated: true, completion: nil)

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
