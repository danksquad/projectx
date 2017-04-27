//
//  EventViewController.swift
//  gathr
//
//  Created by Oscar Reyes on 4/17/17.
//  Copyright © 2017 Gates Zeng. All rights reserved.
//

import UIKit
import Parse

class EventViewController: UIViewController {
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var startTimeDatePicker: UIDatePicker!
    @IBOutlet weak var endTimeDatePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
