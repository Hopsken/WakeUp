//
//  PostTableViewCell.swift
//  WakeUp
//
//  Created by shaowei on 2016/12/20.
//  Copyright © 2016年 Hopsken. All rights reserved.
//

import UIKit
import Spring
import SwiftyJSON

protocol PostTableViewCellDelegate: class {
    func postTableViewCellDidTouchLike(cell: PostTableViewCell)
}

class PostTableViewCell: UITableViewCell {

    weak var delegate: PostTableViewCellDelegate?
    
    @IBOutlet weak var avatarImageView: BadgeView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var postTextView: AutoTextView!
    @IBOutlet weak var likeNumberButton: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    
    func configurePost(post: JSON) {
        usernameLabel.text = post["username"].string
        timeLabel.text = post["time"].string
        postTextView.text = post["post"].string
        postTextView.font = UIFont(name: "PingFang SC", size: 16)
    }
    
    @IBAction func likeButtonDidTouch(_ sender: Any) {
        delegate?.postTableViewCellDidTouchLike(cell: self)
        print("2")
        likeButton.setImage(UIImage(named: "like-active"), for: .normal)
//        likeButton.isEnabled = false
    }
    
}
