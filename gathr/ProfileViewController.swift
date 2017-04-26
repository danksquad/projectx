//
//  ProfileViewController.swift
//  gathr
//
//  Created by Gates Zeng on 4/24/17.
//  Copyright © 2017 Gates Zeng. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let myProfile: PFUser! = ParseClient.currentUser

        firstNameLabel.text = myProfile.value(forKey: "firstName") as! String?
        lastNameLabel.text = myProfile.value(forKey: "lastName") as! String?
        screenNameLabel.text = myProfile.username
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
