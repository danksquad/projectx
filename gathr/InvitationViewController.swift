//
//  InvitationViewController.swift
//  gathr
//
//  Created by Gates Zeng on 4/24/17.
//  Copyright © 2017 Gates Zeng. All rights reserved.
//

import UIKit
import Parse

class InvitationViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var event: PFObject?
    var users: [PFObject]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        ParseClient.getAllUsers()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "usersFetched"), object: nil, queue: OperationQueue.main) { (notification: Notification) in
            self.users = ParseClient.users
            self.tableView.reloadData()
        }

        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(InvitationViewController.refreshUsers), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshUsers() {
        ParseClient.getAllUsers()
        
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

extension InvitationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.gates.InviteUserCell", for: indexPath) as! InviteUserCell
        
        let currUser = users![indexPath.row] as! PFUser
        
        let currName = "\(currUser.value(forKey: "firstName")!) \(currUser.value(forKey: "lastName")!)"
        let currUsername = currUser.value(forKey: "username") as! String
        
        cell.firstLastNameLabel.text = currName
        cell.usernameLabel.text = currUsername
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let users = users {
            return users.count
        }
        return 0
    }
}
