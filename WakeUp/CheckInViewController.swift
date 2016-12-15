//
//  CheckInViewController.swift
//  WakeUp
//
//  Created by shaowei on 2016/12/11.
//  Copyright © 2016年 Hopsken. All rights reserved.
//

import UIKit
import LeanCloud
import Spring

class CheckInViewController: UIViewController {
    
    var isFirstLaunch = true
    
    
    @IBOutlet weak var CheckInDays: UILabel!
    @IBOutlet weak var checkButton: DesignableButton!
    
    @IBAction func CheckInButtonDidTouch(_ sender: Any) {
        if let button = checkButton {
            button.animation = "pop"
            button.animate()
        }
        if let user = currentUser {
            self.checkIn(user: user)
        } else {
            showAlert(info: "请先登录")
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Login User On First Launch
        if currentUser == nil {
            if let username = defaults.value(forKey: "username"), let password = defaults.value(forKey: "password") {
                // Login
                let username = username as! String
                let password = password as! String
                
                if username != "", password != "" {
                    LCUser.logIn(username: username, password: password) { result in
                        switch result {
                        case .success( let user ):
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
                                    
                                    let userID = info.get("objectId") as! LCString
                                    userInfo["userID"] = userID.value
                                    
                                    // Query CheckIn days
                                    let query = LCQuery(className: "checkIn")
                                    query.whereKey("UserID", .equalTo(userID.value))
                                    let checkInCount = query.count().intValue
                                    userInfo["checkInDays"] = String(checkInCount)
                                    self.CheckInDays.text = userInfo["checkInDays"]
                                case .failure:// Error when In UserClass
                                    break
                                }
                            }
                            
                            currentUser = user
                        case .failure:
                            break
                        }
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.CheckInDays.text = userInfo["checkInDays"]
    }
    
    // MARK: CheckIn
    func checkIn(user: LCUser) {
        // CheckTime
        let Timer = getTimes()
        if Timer["hour"]!<6 || Timer["hour"]!>7 || (Timer["hour"]!==7 && Timer["minute"]!>20) {
            showAlert(info: "现在不是签到时间")
            return
        }
        
        // CheckInChallenege
        let randomInt1 = arc4random_uniform(90) + 11
        let randomInt2 = arc4random_uniform(90) + 11
        let result = String(randomInt1 * randomInt2)
        
        let alert = UIAlertController(title: "签到", message: "\(randomInt1)*\(randomInt2)=?", preferredStyle: .alert)
        
        alert.addTextField{ (configurationTextField) in
            configurationTextField.placeholder = "请输入答案"
            configurationTextField.keyboardType = .numberPad
        }
        
        let checkAction = UIAlertAction(title: "确认", style: .default) { (_) in
            let resultTextField = alert.textFields![0] as UITextField
            let resultInput = resultTextField.text
            
            if let resultInput = resultInput {
                if resultInput == result {
                    self.checkInService(user: user)
                    print("input:\(resultInput), result:\(result)")
                } else {
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        alert.addAction(checkAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkInService(user: LCUser) {
        let username = user.username?.value
        let userID = user.objectId?.value
        let checkIn = LCObject(className: "checkIn")
        
        checkIn.set("username", value: username)
        checkIn.set("UserID", value: userID)
        
        checkIn.save { result in
            switch result {
            case .success:
                let query = LCQuery(className: "checkIn")
                query.whereKey("UserID", .equalTo(userID!))
                let checkInCount = query.count().intValue
                self.CheckInDays.text = String(checkInCount)
            case .failure(let error):
                self.showAlert(info: error.reason!)
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
