//
//  EventViewController.swift
//  gathr
//
//  Created by Oscar Reyes on 4/17/17.
//  Copyright © 2017 Gates Zeng. All rights reserved.
//

import UIKit
import Parse
import GooglePlacePicker

class EventViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var startTimeDatePicker: UIDatePicker!
    @IBOutlet weak var endTimeDatePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let darkOrange = UIColor(red: 205/255.0, green: 80/255.0, blue: 0.0, alpha: 1.0)
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.tintColor = darkOrange
            navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: darkOrange]
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func onDoneButton(_ sender: UIButton) {
        if (self.nameTextField.text?.isEmpty)! || (self.locationTextField.text?.isEmpty)! {
            let alertController = UIAlertController(title: "ALERT", message: "Name and Location required", preferredStyle: .alert)
            
            // create a cancel action
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: { (action: UIAlertAction!) in
                
                alertController.dismiss(animated: true, completion: nil)
            })
            
            // add the cancel action to the alertController
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
            
            
        }
        else{
            
            let nameToEvent = self.nameTextField.text
            let locationToEvent = self.locationTextField.text
            let startTimeToEvent = self.startTimeDatePicker.date
            let endTimeToEvent = self.endTimeDatePicker.date
            let descriptionToEvent = self.descriptionTextField.text
            
            Event.postEvent(name: nameToEvent, location: locationToEvent, eventDescription: descriptionToEvent, startTime: startTimeToEvent, endTime: endTimeToEvent) { (success: Bool, error: Error?) in
                if success {
                    print("Created Event")
                    self.nameTextField.text = ""
                    self.locationTextField.text = ""
                    self.descriptionTextField.text = ""
                    
                }
                else {
                    print(error?.localizedDescription ?? "Error creating Event")
                }
            }
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    // Use Google Place Picker widget to select location
    @IBAction func pickPlace(_ sender: UIButton) {
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePicker(config: config)
        
        placePicker.pickPlace { (place: GMSPlace?, error: Error?) in
            if let error = error {
                print("GooglePlacePicker error: \(error.localizedDescription)")
                return
            }
            
            if let place = place {
                print("Location picked: \(place.name), \(place.formattedAddress)")
                self.locationTextField.text = place.formattedAddress
            } else {
                print("No place selected")
            }
        }
    }

    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    /** When making the pfObject and pushing it call the class Events ------->IMPORTANT<------------------- **/
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
