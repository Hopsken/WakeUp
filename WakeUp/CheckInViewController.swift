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
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){   
    }
    
    var currentUser: LCUser?
    
    @IBOutlet weak var CheckInDays: UILabel!
    @IBOutlet weak var userNameButton: UIButton!
    @IBOutlet weak var checkButton: DesignableButton!
    
    @IBAction func loginButtonDidTouch(_ sender: Any) {
        self.performSegue(withIdentifier: "LoginSegue", sender: self)
    }
    @IBAction func CheckInButtonDidTouch(_ sender: Any) {
        if let button = checkButton {
            button.animation = "pop"
            button.animate()
        }
        if let user = LCUser.current {
            self.checkIn(user: user)
        }
    }
    
    @IBAction func SignInButtonDidTouch(_ sender: Any) {
        self.performSegue(withIdentifier: "LoginSegue", sender: self)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        if currentUser == nil {
            if let username = defaults.value(forKey: "username"), let password = defaults.value(forKey: "password") {
                // Login
                let username = username as! String
                let password = password as! String
                
                LCUser.logIn(username: username, password: password) { result in
                    switch result {
                    case .success( let user ):
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
                        
                        self.currentUser = user
                        
                        self.userNameButton.setTitle(user.username?.value, for: .normal)
                        self.userNameButton.isEnabled = false
                    case .failure:
                        self.performSegue(withIdentifier: "LoginSegue", sender: self)
            }
        }
    }
    }
    }
    
    // MARK: CheckIn
    func checkIn(user: LCUser) {
        // CheckTime
        let Timer = getTimes()
        if Timer[3]<6 || Timer[3]>7 || (Timer[3]==7 && Timer[4]>20) {
            self.alert(info: "现在不是签到时间")
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
        let checkIn = LCObject(className: "checkIn")
        
        checkIn.set("username", value: username)
        
        checkIn.save { result in
            switch result {
            case .success:
                let query = LCQuery(className: "checkIn")
                query.whereKey("username", .equalTo(username!))
                let checkInCount = query.count().intValue
                self.CheckInDays.text = String(checkInCount)
            case .failure(let error):
                self.alert(info: error.reason!)
            }
        }

    }
    
    // MARK: getTimes()
    func getTimes() -> [Int] {
        
        var timers: [Int] = [] //  返回的数组
        
        let calendar: Calendar = Calendar(identifier: .gregorian)
        var comps: DateComponents = DateComponents()
        comps = calendar.dateComponents([.year,.month,.day, .weekday, .hour, .minute,.second], from: Date())
        
        timers.append(comps.year! % 2000)  // 年 ，后2位数
        timers.append(comps.month!)            // 月
        timers.append(comps.day!)                // 日
        timers.append(comps.hour!)               // 小时
        timers.append(comps.minute!)            // 分钟
        timers.append(comps.second!)            // 秒
        timers.append(comps.weekday! - 1)      //星期
        
        return timers;
    }
    
    // MARK: alertFunc
    func alert(info: String) {
        let alertController = UIAlertController(title: info, message: "", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}
