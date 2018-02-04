//
//  UpdateViewController.swift
//  Swipefits
//
//  Created by Jean-Philippe McCluskey on 2018-02-03.
//  Copyright © 2018 JP McCluskey Productions. All rights reserved.
//

import UIKit
import Parse


class UpdateViewController: UIViewController , UINavigationControllerDelegate, UIImagePickerControllerDelegate{

  
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var ideaTextLabel: UILabel!
    @IBOutlet weak var skillsTextLabel: UILabel!
    @IBOutlet weak var nameTextLabel: UILabel!
    @IBOutlet weak var statusSwitch: UISwitch!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Hide error label
        errorLabel.isHidden = true

        //
        if let isLead = PFUser.current()?["isLead"] as? Bool {
            statusSwitch.setOn(isLead, animated: false)
        }

        //get the right image in the app for the right user
        if let photo = PFUser.current()?["photo"] as? PFFile {
            photo.getDataInBackground(block: { (data, error) in
                if let imageData = data {
                    if let image = UIImage(data: imageData) {
                        self.profileImageView.image = image
                    }
                }
            })
        }
       //run to create test users
       //createFreeAgents()
    }
    
    
    func createFreeAgents(){
        let imageURLs = ["https://i0.wp.com/news.harvard.edu/wp-content/uploads/2017/03/mark-zuckerberg-headshot-11.jpg?fit=605%2C403&ssl=1 , https://www.popsci.com/sites/popsci.com/files/styles/1000_1x_/public/images/2016/11/slack_for_ios_upload-3.null_.png?itok=I3qFnYBA&fc=50,50 , https://www.grammy.com/sites/com/files/styles/image_landscape_hero/public/kanyewest-hero-104092319.jpg?itok=ECpma28k , https://i.forbesimg.com/media/assets/2015/trump/trump-head.png"]
        var counter = 0
        for imageUrl in imageURLs {
            counter += 1
            if let url = URL(string: imageUrl) {
                if let data = try? Data(contentsOf: url) {
                    let imageFile = PFFile(name: "photo.png", data: data)
                    
                    let user = PFUser()
                    user["photo"] = imageFile
                    user.username = String(counter)
                    user.password = "abc123"
                    user["isLead"] = false
                    
                    user.signUpInBackground(block: { (success, error) in
                        if success {
                            print("Free Agent User created!")
                        }
                    })
                }
            }
        }
    }
    
    // Change profile picture "add+"
    @IBAction func addImageTapped(_ sender: Any) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    // go to Swiping view controler
    @IBAction func searchButton(_ sender: Any) {
        self.performSegue(withIdentifier: "updateToSwipeSeguay" , sender: nil)
    }
    
    // Updates database info with new user values
    @IBAction func editInfoTapped(_ sender: Any) {
            PFUser.current()?["isLead"] = statusSwitch.isOn
            if let image = profileImageView.image {
                if let imageData = UIImagePNGRepresentation(image) {
                    PFUser.current()?["photo"] = PFFile(name: "profile.png", data: imageData)
                    PFUser.current()?.saveInBackground(block: { (success, error) in
                        if error != nil {
                            var errorMessage = "Update Failed - Try Again"
                            if let newError = error as NSError? {
                                if let detailError = newError.userInfo["error"] as? String {
                                    errorMessage = detailError
                                }
                            }
                            self.errorLabel.isHidden = false
                            self.errorLabel.text = errorMessage
                        } else {
                            print("Update Successful")
                        }
                    })
                }
            }
    }
    
    
    @IBAction func signoutButton(_ sender: Any) {
        PFUser.logOut()
        self.performSegue(withIdentifier: "logoutSeguay", sender: nil)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
