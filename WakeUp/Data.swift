//
//  Data.swift
//  WakeUp
//
//  Created by shaowei on 2016/12/14.
//  Copyright © 2016年 Hopsken. All rights reserved.
//

import Foundation
import LeanCloud

var currentUser = LCUser.current
let defaults = UserDefaults.standard
var userInfo: [String: String] = [
    "username": "请先登录",
    "checkInDays": "0",
    "email": "未填写",
    "phone": "未填写",
    "sex": "男",
    "signature": "不辜负每一个清晨！",
    "credit": "0",
    "campus": "苏州大学 本部",
    "birthday": "2015-11-11",
    "avatar": "https://ooo.0o0.ooo/2016/12/14/5851678ada138.jpg",
    "userID": ""
    ]

