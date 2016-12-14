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
//            let isLoginSuccess = tryLogin(username: username, password: password)
//            if isLoginSuccess {
//                self.performSegue(withIdentifier: "unwindToUserViewController", sender: self)
//            } else {
//                self.message.text = "用户名或密码错误"
//            }
            if username != "", password != "" {
                LCUser.logIn(username: username, password: password) { result in
                    switch result {
                    case .success( let user ):
                        // Query CheckIn days
                        let query = LCQuery(className: "checkIn")
                        query.whereKey("username", .equalTo(username))
                        let checkInCount = query.count().intValue
                        userInfo["checkInDays"] = String(checkInCount)
                        
                        
                        // Set User Default
                        defaults.set(username, forKey: "username")
                        defaults.set(password, forKey: "password")
                        defaults.synchronize()
                        
                        
                        // Set User Info
                        let userQuery = LCQuery(className: "UserClass")
                        userQuery.whereKey("username", .equalTo(username))
                        userQuery.find { result in
                            switch result {
                            case .success( let info ):
                                guard let info = info.first else { return }
                                
                                userInfo["username"] = username
                                
                                let email = info.get("email") as! LCString
                                userInfo["email"] = email.value
                                let phone = info.get("phone") as! LCNumber
                                userInfo["phone"] = String(Int(phone.value))
                                let sex = info.get("sex") as! LCString
                                userInfo["sex"] = sex.value
                                let signature = info.get("signature") as! LCString
                                userInfo["signature"] = signature.value
                                let avatar = info.get("avatar") as! LCString
                                userInfo["avatar"] = avatar.value
                                let credit = info.get("credit") as! LCNumber
                                userInfo["credit"] = String(Int(credit.value))
                                let birthday = info.get("birthday") as! LCString
                                userInfo["birthday"] = birthday.value
                                let campus = info.get("campus") as! LCString
                                userInfo["camnpus"] = campus.value
                                
                                self.performSegue(withIdentifier: "unwindToUserViewController", sender: self)
                                
                            case .failure:// Error when In UserClass
                                self.message.text = "发生未知错误"
                            }
                        }
                        
                        currentUser = user
                    case .failure:
                        self.message.text = "用户名或密码错误"
                    }
                }
            }
        }

    }
    
    
    @IBAction func registerButtonDidTouch(_ sender: Any) {
        self.performSegue(withIdentifier: "RegisterSegue", sender: self)
    }
}
