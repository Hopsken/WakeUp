//
//  UserViewController.swift
//  WakeUp
//
//  Created by shaowei on 2016/12/14.
//  Copyright © 2016年 Hopsken. All rights reserved.
//

import UIKit
import Kingfisher

var profileOptions = [["我的签到", "动态"], ["设置", "意见反馈"], ["关于", "分享"]]

class UserViewController: UIViewController{
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
    }
    
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var avatarImageView: BadgeView!
    @IBOutlet weak var creditLabel: UILabel!
    @IBOutlet weak var checkInDaysLabel: UILabel!
    @IBOutlet weak var totalCheckInDaysLabel: UILabel!
    
    @IBOutlet weak var userTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        userTableView.dataSource = self
        userTableView.delegate = self
        
        if currentUser != nil {
            usernameButton.setTitle(userInfo["username"], for: .normal)
            usernameButton.isEnabled = false
            checkInDaysLabel.text = userInfo["checkInDays"]
            totalCheckInDaysLabel.text = userInfo["checkInDays"]
            creditLabel.text = userInfo["credit"]
            
            
            //Get Avatar
            if let imageURLString = userInfo["avatar"] {
                if imageURLString.hasPrefix("https://") {
                    let url = URL(string: imageURLString)!
                    avatarImageView.kf.setImage(with: url)
                }
            }
        } else {
            usernameButton.setTitle("请先登录", for: .normal)
            usernameButton.isEnabled = true
            checkInDaysLabel.text = "0"
            totalCheckInDaysLabel.text = "0"
            creditLabel.text = "0"
        }
    }
    
    @IBAction func logoutButtonDidTouch(_ sender: Any) {
        let alertController = UIAlertController(title: "注销？", message: "", preferredStyle: .alert)
        
        let logoutAction = UIAlertAction(title: "注销", style: .destructive) { (_) in
            let defaults = UserDefaults.standard
            
            defaults.set("", forKey: "username")
            defaults.set("", forKey: "password")
            defaults.synchronize()
            
            self.usernameButton.setTitle("请先登录", for: .normal)
            self.usernameButton.isEnabled = true
            self.checkInDaysLabel.text = "0"
            self.totalCheckInDaysLabel.text = "0"
            self.creditLabel.text = "0"
            self.avatarImageView.image = UIImage(named: "WakeUpLogo")
            
            currentUser = nil
            userInfo = [String: String]()
            userInfo["checkInDays"] = "0"
        }
        alertController.addAction(logoutAction)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension UserViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return profileOptions.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileOptions[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userPageCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "userPageCell")
        
        cell.textLabel?.text = profileOptions[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
