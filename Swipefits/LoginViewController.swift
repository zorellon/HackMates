//
//  LoginViewController.swift
//  Swipefits
//
//  Created by Jean-Philippe McCluskey on 2018-02-03.
//  Copyright © 2018 JP McCluskey Productions. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextFeild: UITextField!
    @IBOutlet weak var passwordTextFeild: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var loginState = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //hide error label
        self.errorLabel.isHidden = true
    }
    
    
    @IBAction func loginTapped(_ sender: Any) {
        if loginState{
            let user = PFUser()
            
            user.username = usernameTextFeild.text
            user.password = passwordTextFeild.text
            
            if loginState {
                
                user.signUpInBackground(block: { (success, error) in
                    if error != nil {
                        var errorMessage = "Sign Up Failed - Try Again"
                        
                        if let newError = error as NSError? {
                            if let detailError = newError.userInfo["error"] as? String {
                                errorMessage = detailError
                            }
                        }
                        
                        self.errorLabel.isHidden = false
                        self.errorLabel.text = errorMessage
                        
                    } else {
                        print("Sign Up Successful")
                        self.performSegue(withIdentifier: "updateSeguay", sender: nil)
                    }
                })
                
            } else {
                
                if let username = usernameTextFeild.text {
                    if let password = passwordTextFeild.text {
                        PFUser.logInWithUsername(inBackground: username, password: password, block: { (user, error) in
                            if error != nil {
                                var errorMessage = "Login Failed - Try Again"
                                
                                if let newError = error as NSError? {
                                    if let detailError = newError.userInfo["error"] as? String {
                                        errorMessage = detailError
                                    }
                                }
                                
                                self.errorLabel.isHidden = false
                                self.errorLabel.text = errorMessage
                                
                            } else {
                                print("Login Successful")
                                self.performSegue(withIdentifier: "updateSeguay", sender: nil)
                            }
                        })
                    }
                }
                
                
            }
        }
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        if PFUser.current() != nil {
            self.performSegue(withIdentifier: "updateSeguay", sender: nil)
            print("Login Successful")
        }
 
    }

    // Swap login and sign up
    @IBAction func signupTapped(_ sender: Any) {
        if loginState{
            loginButton.setTitle("Signup", for: .normal)
            signupButton.setTitle("Login", for: .normal)
            loginState = false
        }
        else{
            signupButton.setTitle("Signup", for: .normal)
            loginButton.setTitle("Login", for: .normal)
            loginState = true
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
