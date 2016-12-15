//
//  UserInfoViewController.swift
//  WakeUp
//
//  Created by shaowei on 2016/12/15.
//  Copyright © 2016年 Hopsken. All rights reserved.
//

import UIKit

var userInfoforCell = ["加载中","加载中","加载中","加载中","加载中"]
let userInfoName = ["昵称", "性别", "生日", "所在校区","签名"]

class UserInfoViewController: UIViewController {
    
    @IBAction func saveUserInfoChangeSegue(segue: UIStoryboardSegue){
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let imageURLString = userInfo["avatar"] {
            if imageURLString.hasPrefix("https://") {
                let url = URL(string: imageURLString)!
                avatarImageView.kf.setImage(with: url)
            }
        }
        
        userInfoforCell = ["加载中","加载中","加载中","加载中","加载中"]
        
        userInfoforCell = [
            userInfo["username"]!,
            userInfo["sex"]! ,
            userInfo["birthday"]! ,
            userInfo["campus"]! ,
            userInfo["signature"]!
        ]
    }
    
}

extension UserInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInfoforCell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserInfoCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "UserInfoCell")
        
        cell.textLabel?.text = userInfoName[indexPath.row]
        cell.detailTextLabel?.text = userInfoforCell[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "UserInfoChangeSegue", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserInfoChangeSegue" {
            let indexPath = sender as! IndexPath
            let indexPathRow = indexPath.row
            let userInfo = userInfoforCell[indexPathRow]
            let toView = segue.destination as! UserInfoChangeViewController
            toView.infoName = userInfo
            toView.infoType = userInfoName[indexPathRow]
        }
    }
    
    
    
}
