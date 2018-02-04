//
//  ViewController.swift
//  Swipefits
//
//  Created by Jean-Philippe McCluskey on 2018-02-03.
//  Copyright © 2018 JP McCluskey Productions. All rights reserved.
//
import UIKit
import Parse

class ViewController: UIViewController {
    
    @IBOutlet weak var swipeLabel: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(wasDragged(gestureRecognizer:)))
        swipeLabel.addGestureRecognizer(gesture)
    }
    
    
    
    
    @IBAction func backButton(_ sender: Any) {
        self.performSegue(withIdentifier: "backSeguay", sender: nil)
        
    }
    
    
    @objc func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
         let labelPoint = gestureRecognizer.translation(in: view)
        swipeLabel.center = CGPoint(x: view.bounds.width / 2 + labelPoint.x, y: view.bounds.height / 2 + labelPoint.y)
    
        let xFromCenter = view.bounds.width / 2 - swipeLabel.center.x
        var rotation = CGAffineTransform(rotationAngle: xFromCenter / 200)
        let scale = min(100 / abs(xFromCenter), 1)
        var scaledAndRotated = rotation.scaledBy(x: scale, y: scale)
        swipeLabel.transform = scaledAndRotated
        if gestureRecognizer.state == .ended {
           if swipeLabel.center.x < (view.bounds.width / 2 - 100) {
                print("Not Interested")
            }
            if swipeLabel.center.x > (view.bounds.width / 2 + 100) {
                print("Interested")
            }
            
            rotation = CGAffineTransform(rotationAngle: 0)
            scaledAndRotated = rotation.scaledBy(x: 1, y: 1)
            swipeLabel.transform = scaledAndRotated
            swipeLabel.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
         }
    }
    
    /*
    func updateImage() {
        if let query = PFUser.query() {
            
            if let isInterestedInWomen = PFUser.current()?["isLead"] {
                
                query.whereKey("isLead")
            }
            
            if let isFemale = PFUser.current()?["isLead"] {
                
                query.whereKey("isLead", equalTo: isLead)
            }
            
            var ignoredUsers : [String] = []
            
            if let acceptedUsers = PFUser.current()?["accepted"] as? [String] {
                ignoredUsers += acceptedUsers
            }
            
            if let rejectedUsers = PFUser.current()?["rejected"] as? [String] {
                ignoredUsers += rejectedUsers
            }
            
            query.whereKey("objectId", notContainedIn: ignoredUsers)
            
            query.limit = 1
            
            query.findObjectsInBackground { (objects, error) in
                if let users = objects {
                    for object in users {
                        if let user = object as? PFUser {
                            if let imageFile = user["photo"] as? PFFile {
                                imageFile.getDataInBackground(block: { (data, error) in
                                    if let imageData = data {
                                        self.swipeLabel.image = UIImage(data: imageData)
                                        if let objectID = object.objectId {
                                            self.displayUserID = objectID
                                        }
                                    }
                                })
                            }
                        }
                    }
                }
            }
        }
        
    }
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
