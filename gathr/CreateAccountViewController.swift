//
//  CreateAccountViewController.swift
//  gathr
//
//  Created by Gates Zeng on 4/19/17.
//  Copyright © 2017 Gates Zeng. All rights reserved.
//

import UIKit
import Parse
import AFNetworking

class CreateAccountViewController: UIViewController {
    @IBOutlet weak var fNameField: UITextField!
    @IBOutlet weak var lNameField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var createAccountButton: UIButton!
    
    var profileImage: UIImage = #imageLiteral(resourceName: "profile-placeholder")

    override func viewDidLoad() {
        super.viewDidLoad()
        let darkOrange = UIColor(red: 205/255.0, green: 80/255.0, blue: 0.0, alpha: 1.0)
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.tintColor = darkOrange
            navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: darkOrange]
        }
        createAccountButton.layer.cornerRadius = 5

        // Do any additional setup after loading the view.
        self.profileImageView.layer.cornerRadius = 10
        self.profileImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapProfileView(sender:)))
        self.profileImageView.addGestureRecognizer(tapGesture)
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
        let user_id = "u_" + ParseClient.generateUID(length: 12)
        
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        newUser["firstName"] = fNameField.text ?? "John"
        newUser["lastName"] = lNameField.text ?? "Smith"
        newUser["user_id"] = user_id
        newUser["profile_image"] = ParseClient.getPFFileFromImage(image: profileImage)
        
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if success {
                print("created new user")
                //ParseClient.currentUser = newUser
                self.performSegue(withIdentifier: "signupSegue", sender: nil)
            } else {
                
                print("Error on Sign Up")
                self.displayErrorDialog(error: error)
                print(error!.localizedDescription)
            }
        }
        
    }
    
    func didTapProfileView(sender: UITapGestureRecognizer) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(vc, animated: true, completion: nil)

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

extension CreateAccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        self.profileImage = editedImage
        self.profileImageView.image = editedImage
        
        dismiss(animated: true, completion: nil)
    }
}
