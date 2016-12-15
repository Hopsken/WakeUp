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
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var registerButton: DesignableButton!
    
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
                        // Set User Default
                        defaults.set(username, forKey: "username")
                        defaults.set(password, forKey: "password")
                        defaults.synchronize()
                        
                        
                        //更新 UserClass 表
                        let userClass = LCObject(className: "UserClass")
                        
                        userClass.set("username", value: username)
                        
                        userClass.save { result in
                            switch result {
                            case .success:
                                self.performSegue(withIdentifier: "unwindToUserAfterRegister", sender: self)
                            case .failure( let error ):
                                self.message.text = "注册失败：\(error)"
                            }
                        }
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
