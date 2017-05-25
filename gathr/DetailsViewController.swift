//
//  DetailsViewController.swift
//  gathr
//
//  Created by Jamie Shi on 4/20/17.
//  Copyright © 2017 Gates Zeng. All rights reserved.
//

import UIKit
import Parse
import GoogleMaps

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var eventCoverView: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventStartTime: UILabel!
    @IBOutlet weak var eventEndTime: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    
    var event: PFObject? 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let darkOrange = UIColor(red: 205/255.0, green: 80/255.0, blue: 0.0, alpha: 1.0)
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.tintColor = darkOrange
            navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: darkOrange]
        }
        
        let eventName = event?["name"] as? String
        self.eventName.text = eventName
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        
        if let eventStartTime = event?["startTime"] {
            self.eventStartTime.text = formatter.string(from: eventStartTime as! Date)
        }
        else {
            self.eventStartTime.text = "Unspecified"
        }
        
        if let eventEndTime = event?["endTime"] {
            self.eventEndTime.text = formatter.string(from: eventEndTime as! Date)
        }
        else {
            self.eventEndTime.text = "Unspecified"
        }
        
        let eventLocation = event?["location"] as? String
        self.eventLocation.text = eventLocation
        
        let eventDescription = event?["eventDescription"] as? String
        self.eventDescription.text = eventDescription
        
        print("details for room_id: \(event!.value(forKey: "room_id")!)")
        
        // set up for mapView
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "inviteSegue" {
            let invitationViewController = segue.destination as! InvitationViewController
            
            invitationViewController.event = self.event
        }
        
        if segue.identifier == "toChatroom" {
            let chatroomViewController = segue.destination as! ChatRoomViewController
            
            
            chatroomViewController.roomId = event?.value(forKey: "room_id") as! String
            
            print("Test")
            
        }
        
    }
    

}
