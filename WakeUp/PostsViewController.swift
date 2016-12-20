//
//  PostsViewController.swift
//  WakeUp
//
//  Created by shaowei on 2016/12/20.
//  Copyright © 2016年 Hopsken. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh

class PostsViewController: UIViewController, PostTableViewCellDelegate {
    @IBOutlet weak var PostTableView: UITableView!
    let loadingView = DGElasticPullToRefreshLoadingViewCircle()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Config TableView
        PostTableView.estimatedRowHeight = 200
        PostTableView.rowHeight = UITableViewAutomaticDimension
        PostTableView.dataSource = self
        PostTableView.delegate = self
        
        //Set Up Pull to refresh
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        PostTableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self?.reloadPost()
            self?.PostTableView.dg_stopLoading()
            }, loadingView: loadingView)
        PostTableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        PostTableView.dg_setPullToRefreshBackgroundColor(PostTableView.backgroundColor!)
    }
    
    func reloadPost() {
        print("reload")
    }
}

extension PostsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        if let postCell = cell as? PostTableViewCell {
            let post = posts[indexPath.row]
            postCell.selectionStyle = .none
            postCell.configurePost(post: post)
            postCell.delegate = self
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func postTableViewCellDidTouchLike(cell: PostTableViewCell) {
        
    }
}
