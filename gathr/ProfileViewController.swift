//
//  ProfileViewController.swift
//  gathr
//
//  Created by Gates Zeng on 4/24/17.
//  Copyright © 2017 Gates Zeng. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileView: PFImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let darkOrange = UIColor(red: 205/255.0, green: 80/255.0, blue: 0.0, alpha: 1.0)
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.tintColor = darkOrange
            navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: darkOrange]
        }
        
        if let currentUser = PFUser.current() {
            
            if let firstName = currentUser["firstName"] as! String? {
                firstNameLabel.text = ("First Name: " + firstName)
            }
            if let lastName = currentUser["lastName"] as! String? {
                lastNameLabel.text = ("Last Name: " + lastName)
            }
            if let username = currentUser["username"] as! String? {
                screenNameLabel.text = ("Username: " + username)
            }
            
            if let profileImage = currentUser["profile_image"] as! PFFile? {
                self.profileView.file = profileImage
                self.profileView.loadInBackground()
            }
        }
        self.profileView.layer.cornerRadius = 5
        self.profileView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapProfileView(sender:)))
        self.profileView.addGestureRecognizer(tapGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didTapProfileView(sender: UITapGestureRecognizer) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(vc, animated: true, completion: nil)
        
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

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        let currentUser = PFUser.current()

        self.profileView.image = editedImage
        currentUser?["profile_image"] = ParseClient.getPFFileFromImage(image: editedImage)
        currentUser?.saveInBackground(block: { (success: Bool, error: Error?) in
            if success {
                print("new profile image saved")
            } else {
                print(error?.localizedDescription)
            }
        })
        
        dismiss(animated: true, completion: nil)
    }
}
