//
//  LoginViewController.swift
//  gathr
//
//  Created by Gates Zeng on 4/17/17.
//  Copyright © 2017 Gates Zeng. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let darkOrange = UIColor(red: 205/255.0, green: 80/255.0, blue: 0.0, alpha: 1.0)
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.tintColor = darkOrange
            navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: darkOrange]
        }
        createAccountButton.layer.cornerRadius = 5
        loginButton.layer.cornerRadius = 5
        usernameField.delegate = self
        usernameField.tag = 0 //Increment accordingly
        passwordField.delegate = self
        passwordField.tag = 1

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func dismissKeyboard() {
        view.endEditing(true)
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
