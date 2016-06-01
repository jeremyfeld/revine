//
//  JBFVinePostCollectionViewCell.swift
//  ReVine
//
//  Created by Jeremy Feld on 5/25/16.
//  Copyright © 2016 JBF. All rights reserved.
//

import UIKit
import AVFoundation
import AFNetworking

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
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var repostButton: UIButton!
    private let originalLikeImage = UIImage(named: "like");
    private let originalRepostImage = UIImage(named: "repost")
    private var tintedLikeImage = UIImage()
    private var tintedRepostImage = UIImage()
    
    var cellAVPlayer: AVPlayer?
    var vine: JBFVine? {
        didSet {
            setupVideo()
            setupLikeButton()
            setupRepostButton()
            setupLabels()
        }
    }
    
//    MARK: Cell Setup
    
    private func setupLikeButton() {
        
        tintedLikeImage = (originalLikeImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate))
        
        if vine!.userHasLiked {
            likeButton.setImage(tintedLikeImage, forState: UIControlState.Normal)
            likeButton.tintColor = UIColor.redColor()
            
        } else {
            likeButton.setImage(originalLikeImage, forState: UIControlState.Normal)
        }
    }
    
    private func setupRepostButton() {
        
        tintedRepostImage = (originalRepostImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate))

        if vine!.userHasReposted {
            repostButton.setImage(tintedLikeImage, forState: UIControlState.Normal)
            repostButton.tintColor = UIColor.purpleColor()
            
        } else {
            repostButton.setImage(originalRepostImage, forState: UIControlState.Normal)
        }
    }
    
    private func setupLabels() {
        
        let dateFormatter: NSDateFormatter = NSDateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.ssssss"
        let date: NSDate! = dateFormatter.dateFromString(vine!.dateString)
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        numberOfLoopsLabel.text = formattedStringFromNumber(vine!.loops)
        
        //date could be nil
        datePostedLabel.text = dateFormatter.stringFromDate(date)
        
        //could be nil
        usernameLabel.text = vine!.username
        
        titleLabel.text = vine!.title
        numberOfLikesLabel.text = formattedStringFromNumber(vine!.likes)
        numberOfCommentsLabel.text = formattedStringFromNumber(vine!.comments)
        numberOfRepostsLabel.text = formattedStringFromNumber(vine!.reposts)
        userAvatarImageView.layer.cornerRadius = userAvatarImageView.frame.height/2
        userAvatarImageView.clipsToBounds = true
        //could be nil
        userAvatarImageView.setImageWithURL(vine!.userAvatarUrl)
    }
    
    private func setupVideo() {
        //could be nil
        let url = vine!.videoUrl
        let playerItem = AVPlayerItem(URL: url)
        
        if ((cellAVPlayer) != nil) {
            cellAVPlayer!.replaceCurrentItemWithPlayerItem(playerItem)
            
        } else {
            cellAVPlayer = AVPlayer(playerItem: playerItem)
            
            let avPlayerLayer = AVPlayerLayer(player: cellAVPlayer)
            mediaView.layer.insertSublayer(avPlayerLayer, atIndex: 0)
            avPlayerLayer.frame = mediaView.bounds
            mediaView.layoutSubviews()
        }
    }
    
//    MARK: IBActions
    
    @IBAction func likeButtonTapped(sender: AnyObject) {
        
        if self.vine!.userHasLiked == true {
            JBFVineClient.sharedClient().unlikePost(stringForPostId(vine!.postID), withSessionID:JBFVineClient.sharedClient().currentUserKey(), withCompletion: { (success) in
                
                if success {
                    self.updateCellForUnlike(self.likeButton)
                }
            })
            
        } else {
            JBFVineClient.sharedClient().likePost(stringForPostId(vine!.postID), withSessionID: JBFVineClient.sharedClient().currentUserKey(), withCompletion: { (success) in
                
                if success {
                    self.updateCellForLike(self.likeButton)
                }
            })
        }
    }
    
    @IBAction func commentButtonTapped(sender: AnyObject) {
        
        //comment - will need to present a view for text entry
    }
    
    @IBAction func repostButtonTapped(sender: AnyObject) {
        
        if self.vine!.userHasReposted == true {
            //user has reposted
            
        } else {
            JBFVineClient.sharedClient().repost(stringForPostId(vine!.postID), withSessionID: JBFVineClient.sharedClient().currentUserKey(), withCompletion: { (success) in
                
                if success {
                    self.updateCellForRepost(self.repostButton)
                }
            })
        }
    }
    
//    MARK: Update UI Methods
    
    private func updateCellForUnlike(button:UIButton) {
        
        likeButton.setImage(originalLikeImage, forState: UIControlState.Normal)
        vine!.userHasLiked = false
    }
    
    private func updateCellForLike(button:UIButton) {
        
        likeButton.setImage(tintedLikeImage, forState: UIControlState.Normal)
        likeButton.tintColor = UIColor.redColor()
        vine!.userHasLiked = true
    }
    
    private func updateCellForRepost(button:UIButton) {
        
        repostButton.setImage(tintedRepostImage, forState: UIControlState.Normal)
        repostButton.tintColor = UIColor.purpleColor()
        vine!.userHasReposted = true
    }
    
    //    MARK: Label Formatting Helper
    
    private func formattedStringFromNumber(num: NSNumber) -> String {
        
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        return numberFormatter.stringFromNumber(num)!
    }
    
    private func stringForPostId(int: UInt) -> String {
        return "\(int)"
    }
}