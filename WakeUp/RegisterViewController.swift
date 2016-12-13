//
//  RegisterViewController.swift
//  WakeUp
//
//  Created by shaowei on 2016/12/13.
//  Copyright © 2016年 Hopsken. All rights reserved.
//

import UIKit
import Spring
import LeanCloud

class RegisterViewController: UIViewController {
    @IBOutlet weak var usernameTextField: DesignableTextField!
    @IBOutlet weak var passwordTextField: DesignableTextField!
    @IBOutlet weak var registerButton: DesignableButton!
    @IBOutlet weak var message: UILabel!
    
    @IBAction func registerButtonDidTouch(_ sender: Any) {
        let button = self.registerButton
        button?.animation = "pop"
        button?.animate()
        
        // Register
        if let username = self.usernameTextField.text, let password = self.passwordTextField.text{
            if username != "", password != "" {
                let user = LCUser()
                
                user.username = LCString(username)
                user.password = LCString(password)
                
                user.signUp() { result in
                    switch result {
                    case .success:
                        // Query CheckIn days
                        let query = LCQuery(className: "checkIn")
                        query.whereKey("username", .equalTo(username))
                        let checkInCount = query.count().intValue
                        
                        // Set User Default
                        let defaults = UserDefaults.standard
                        defaults.set(username, forKey: "username")
                        defaults.set(password, forKey: "password")
                        defaults.set(checkInCount, forKey: "checkInDays")
                        defaults.synchronize()
                                                
                        self.performSegue(withIdentifier: "unwindToCheckInAfterRegister", sender: self)
                        
                        //TODO: prepare for Segue LCUser
                        
                    case .failure(let error):
                        if let error = error.reason {
                            self.message.text = "注册失败：\(error)"
                        }
                    }
                }
            }
        }
        
    }

}
