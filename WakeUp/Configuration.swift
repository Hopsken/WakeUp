//
//  Configuration.swift
//  WakeUp
//
//  Created by shaowei on 2016/12/14.
//  Copyright © 2016年 Hopsken. All rights reserved.
//

import UIKit
import LeanCloud
import Foundation

// For Radius Badge
class BadgeView: UIImageView {
    override func awakeFromNib() {
        
        self.layoutIfNeeded()
        layer.cornerRadius = self.frame.height / 2.0
        layer.masksToBounds = true
        
    }
}

// Func Login
func tryLogin( username: String, password: String) -> Bool {
    
    var status = false

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
                        userInfo["email"] = info.get("email") as? String ?? ""
                        userInfo["phone"] = info.get("phone") as? String ?? ""
                        userInfo["sex"] = info.get("sex") as? String ?? "男"
                        userInfo["signature"] = info.get("signiture") as? String ?? "不辜负每一个清晨！"
                        userInfo["avatar"] = info.get("avatar") as? String ?? ""
                        userInfo["credit"] = info.get("credit") as? String ?? "0"
                        userInfo["birthday"] = info.get("birthday") as? String ?? "2015-11-11"
                        userInfo["camnpus"] = info.get("campus") as? String ?? "苏州大学 本部"
                        
                        status = true
                        print("User Class Yes")
                    case .failure:// Error when In UserClass
                        status = false
                        print("User Class Error")
                    }
                }
                
                currentUser = user
                status = true
            case .failure:
                print("username X")
                status = false
                    }
                }
            }
    return status
}


// MARK: getTimes()
func getTimes() -> [String: Int] {
    
    var timers: [String: Int] = [String: Int]() //  返回的字典
    
    let calendar: Calendar = Calendar(identifier: .gregorian)
    var comps: DateComponents = DateComponents()
    comps = calendar.dateComponents([.year,.month,.day, .weekday, .hour, .minute,.second], from: Date())
    
    timers["year"] = comps.year! % 2000  // 年 ，后2位数
    timers["month"] = comps.month!          // 月
    timers["day"] = comps.day!                // 日
    timers["hour"] = comps.hour!               // 小时
    timers["minute"] = comps.minute!            // 分钟
    timers["seconds"] = comps.second!            // 秒
    timers["weekday"] = comps.weekday!      //星期
    
    return timers
}
