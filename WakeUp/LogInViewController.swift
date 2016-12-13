//
//  LogInViewController.swift
//  WakeUp
//
//  Created by shaowei on 2016/12/13.
//  Copyright © 2016年 Hopsken. All rights reserved.
//

import UIKit
import Spring
import LeanCloud

class LogInViewController: UIViewController {
    @IBOutlet weak var userNameTextField: DesignableTextField!
    @IBOutlet weak var passwordTextField: DesignableTextField!

    @IBOutlet weak var message: UILabel!
    
    @IBOutlet weak var loginButton: DesignableButton!
    
    @IBAction func loginButtonDidTouch(_ sender: Any) {
        // Button Animation
        let button = self.loginButton
        button?.animation = "pop"
        button?.animate()
        
        // Login
        if let username = self.userNameTextField.text, let password = self.passwordTextField.text{
            if username != "", password != "" {
                LCUser.logIn(username: username, password: password) { result in
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
                        
                        self.performSegue(withIdentifier: "unwindToCheckInViewController", sender: self)
                        
                    case .failure:
                        self.message.text = "用户名或密码错误"
                    }
                }
            } else {
                self.message.text = "用户名或密码不正确"
            }
        }

        
    }
    
    @IBAction func registerButtonDidTouch(_ sender: Any) {
        self.performSegue(withIdentifier: "RegisterSegue", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginSegue" {
            // TODO
        }
    }
}
