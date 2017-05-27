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
    @IBOutlet weak var eventStartDate: UILabel!
    @IBOutlet weak var eventEndDate: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var eventEndTime: UILabel!
    @IBOutlet weak var eventStartTime: UILabel!
    @IBOutlet weak var inviteButton: UIButton!
    
    var event: PFObject?
    var eventLong: CLLocationDegrees?
    var eventLat: CLLocationDegrees?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let darkOrange = UIColor(red: 205/255.0, green: 80/255.0, blue: 0.0, alpha: 1.0)
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.tintColor = darkOrange
            navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: darkOrange]
        }
        inviteButton.layer.cornerRadius = 5
        
        let eventName = event?["name"] as? String
        self.eventName.text = eventName
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        if let eventStartTime = event?["startTime"] {
            dateFormatter.dateFormat = "MMM dd, yyyy"
            self.eventStartDate.text = dateFormatter.string(from: eventStartTime as! Date)

            dateFormatter.dateFormat = "h:mm a"
            self.eventStartTime.text = dateFormatter.string(from: eventStartTime as! Date)
        }
        else {
            self.eventStartTime.text = "Unspecified"
        }
        
        if let eventEndTime = event?["endTime"] {
            
            dateFormatter.dateFormat = "MMM dd, yyyy"
            self.eventEndDate.text = dateFormatter.string(from: eventEndTime as! Date)
            
            dateFormatter.dateFormat = "h:mm a"
            self.eventEndTime.text = dateFormatter.string(from: eventEndTime as! Date)
        }
        else {
            self.eventEndDate.text = "Unspecified"
        }
        
        let eventLocation = event?["location"] as? String
        self.eventLocation.text = eventLocation
        
        let eventDescription = event?["eventDescription"] as? String
        self.eventDescription.text = eventDescription
        
        if let eventLong = event?["location_long"] {
            self.eventLong = eventLong as? CLLocationDegrees
        }
        
        if let eventLat = event?["location_lat"] {
            self.eventLat = eventLat as? CLLocationDegrees
        }
        
        print("details for room_id: \(event!.value(forKey: "room_id")!)")
        
        // Setup for mapView
        self.mapView.isHidden = true
        if eventLong != nil && eventLat != nil && eventLong != 0 && eventLat != 0 {
            let camera = GMSCameraPosition.camera(withLatitude: eventLat!, longitude: eventLong!, zoom: 17)
            self.mapView.camera = camera
            self.mapView.mapType = kGMSTypeNormal
            self.mapView.isMyLocationEnabled = true
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: eventLat!, longitude: eventLong!)
            marker.map = self.mapView
            
            self.mapView.isHidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.isScrollEnabled = true
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
