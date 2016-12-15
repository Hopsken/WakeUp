//
//  UserInfoChangeViewController.swift
//  WakeUp
//
//  Created by shaowei on 2016/12/15.
//  Copyright © 2016年 Hopsken. All rights reserved.
//

import UIKit
import LeanCloud

class UserInfoChangeViewController: UIViewController {
    var infoName: String?
    var infoType: String?
    
    @IBOutlet weak var userInfoTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userInfoTextField.text = infoName
    }
    
    @IBAction func saveButtonDidTouch(_ sender: Any) {
        let userInfoToChange = userInfoTextField.text
        
        if infoType == "昵称" {
            currentUser?.set("username", value: userInfoToChange)
            currentUser?.save { result in
                switch result {
                case .success:
                    let userClass = LCObject(className: "UserClass", objectId: userInfo["userId"]!)
                    userClass.set("username", value: userInfoToChange)
                    userClass.save { result in
                        switch result {
                        case .success:
                            break
                        case .failure:
                            self.showAlert(info: "发生了些意外...")
                        }
                    }
                case .failure:
                    self.showAlert(info: "发生了些意外....")
                }
            }
            
        } else {
            let nameMap = ["性别": "sex", "生日": "brithday", "所在校区": "campus", "签名": "signature"]
            let userId = userInfo["userID"] ?? " "
            print(userId)
            let userClass = LCObject(className: "UserClass", objectId: userId)
            let objectToChange = nameMap[infoType!]
            
            if let objectToChange = objectToChange, let userInfoToChange = userInfoToChange {
                print(objectToChange, userInfoToChange)
                userClass.set(objectToChange, value: userInfoToChange)
                userClass.save { result in
                    switch result {
                    case .success:
                        userInfo[objectToChange] = userInfoToChange
                        self.performSegue(withIdentifier: "saveUserInfoChangeSegue", sender: self)
                    case .failure(let error):
                        self.showAlert(info: "发生了些意外.....")
                        print(error)
                    }
                }
            }
        }
    }
    
    func showAlert(info: String) {
        let alertController = UIAlertController(title: info, message: "", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
