//
//  JBFVinePostCollectionViewCell.swift
//  ReVine
//
//  Created by Jeremy Feld on 5/25/16.
//  Copyright © 2016 JBF. All rights reserved.
//

import UIKit
import AVFoundation

class JBFVinePostCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mediaView: UIView!
    @IBOutlet weak var numberOfLoopsLabel: UILabel!
    @IBOutlet weak var likeButtonContainerView: UIView!
    @IBOutlet weak var repostButtonContainerView: UIView!
    @IBOutlet weak var datePostedLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numberOfLikesLabel: UILabel!
    @IBOutlet weak var numberOfCommentsLabel: UILabel!
    @IBOutlet weak var numberOfRepostsLabel: UILabel!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var vineThumbnailImageView: UIImageView!
    var cellAVPlayer: AVPlayer?
    var vine: JBFVine?
    
    @IBAction func likeButtonTapped(sender: AnyObject) {
        
        if self.vine!.userHasLiked == true {
            
            JBFVineClient.sharedClient().unlikePost(self.vine!.postID, withSessionID:JBFVineClient.sharedClient().returnUserKey(), withCompletion: { (success) in
                
                self.likeButtonContainerView.backgroundColor = UIColor.whiteColor()
            })
            
        } else {
            
            JBFVineClient.sharedClient().likePost(self.vine!.postID, withSessionID: JBFVineClient.sharedClient().returnUserKey(), withCompletion: { (success) in
                
                self.likeButtonContainerView.backgroundColor = UIColor.purpleColor()
            })
        }
    }
    
    @IBAction func commentButtonTapped(sender: AnyObject) {
        
        //comment - will need to present a view for text entry
    }
    
    @IBAction func repostButtonTapped(sender: AnyObject) {
        
        if self.vine!.userHasReposted == true {
            
            //error message - already reposted
            
        } else {
            
            JBFVineClient.sharedClient().repost(self.vine!.postID, withSessionID: JBFVineClient.sharedClient().returnUserKey(), withCompletion: { (success) in
                
                self.repostButtonContainerView.backgroundColor = UIColor.purpleColor()
            })
        }
    }
}
