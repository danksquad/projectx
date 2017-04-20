//
//  CreateAccountViewController.swift
//  gathr
//
//  Created by Gates Zeng on 4/19/17.
//  Copyright © 2017 Gates Zeng. All rights reserved.
//

import UIKit
import Parse

class CreateAccountViewController: UIViewController {
    @IBOutlet weak var fNameField: UITextField!
    @IBOutlet weak var lNameField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCreateAccount(_ sender: Any) {
        // create a new PFUser obj
        let newUser = PFUser()
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        newUser.add(fNameField.text ?? "John", forKey: "firstName")
        newUser.add(lNameField.text ?? "Smith", forKey: "lastName")
        
        
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if success {
                print("created new user")
                self.performSegue(withIdentifier: "signupSegue", sender: nil)
            } else {
                
                print("Error on Sign Up")
                self.displayErrorDialog(error: error)
                
                print(error?.localizedDescription)
            }
        }
        
    }
    
    func displayErrorDialog(error: Error?) {
        let errorString = (error as! NSError).userInfo["error"] as? NSString
        let signUpErrorController = UIAlertController(title: "Failed", message: "", preferredStyle: .alert)
        
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default)
        
        // add the OK action to the alert controller
        signUpErrorController.addAction(OKAction)
        
        signUpErrorController.message = errorString as String!
        self.present(signUpErrorController, animated: true)
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
