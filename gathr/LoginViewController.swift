//
//  LoginViewController.swift
//  gathr
//
//  Created by Gates Zeng on 4/17/17.
//  Copyright © 2017 Gates Zeng. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCreateAccountButton(_ sender: UIButton) {

    }
    
    func displayErrorDialog(error: Error?, sender: UIButton) {
        let errorString = (error as! NSError).userInfo["error"] as? NSString
        let signUpErrorController = UIAlertController(title: "Failed", message: "", preferredStyle: .alert)
        
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default)
        
        // add the OK action to the alert controller
        signUpErrorController.addAction(OKAction)
        
        signUpErrorController.message = errorString as String!
        self.present(signUpErrorController, animated: true)
    }
    
    
    @IBAction func onLoginButton(_ sender: UIButton) {
        PFUser.logInWithUsername(inBackground: usernameField.text!, password: passwordField.text!)
        
        PFUser.logInWithUsername(inBackground: usernameField.text!, password: passwordField.text!) { (user: PFUser?, error: Error?) in
            if let error = error {
                self.displayErrorDialog(error: error, sender: sender)
            } else {
                if user != nil {
                    print("logged in")
                    //ParseClient.currentUser = user
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
            }

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

}
