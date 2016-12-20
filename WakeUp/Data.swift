//
//  Data.swift
//  WakeUp
//
//  Created by shaowei on 2016/12/14.
//  Copyright © 2016年 Hopsken. All rights reserved.
//

import Foundation
import LeanCloud
import SwiftyJSON

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

var posts: JSON = [
    [
        "username": "张三",
        "avatar": "",
        "time": "今天 12:54",
        "post": "可惜在遇见我那天你并不快乐\n可能是因为我们相遇的太晚了\n可是我要走了 可温暖要走了\n可否有另一个我在你身后给予快乐\n可当我牵着你的手傻乎乎的乐\n渴望的爱情终于在我生命出现了"
    ],
    [
        "username": "李四",
        "avatar": "",
        "time": "5分钟前",
        "post": "不辜负每一个清晨～"
    ],
    [
        "username": "王二",
        "avatar": "",
        "time": "刚刚",
        "post": "Baby, this is what you came for\n亲爱的，这不就是你所期待的\nLightning strikes every time she moves\n她的每个举动，都在放出闪电，势不可挡\nAnd everybody’s watching her\n她生来万众瞩目\nBut she’s looking at you, oh, oh\n可她却只心系于你\nYou, oh, oh, you, oh, oh \n只有你，她眼中只有你"
    ]
]

