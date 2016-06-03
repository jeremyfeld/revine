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
    weak var delegate: ErrorAlertProtocol?
    
    let avPlayerLayer = AVPlayerLayer()
    var cellAVPlayer: AVPlayer?
    var vine: JBFVine? {
        didSet {
            setupVideo()
            setupLikeButton()
            setupRepostButton()
            setupLabels()
        }
    }
    
    //MARK: - Cell Setup
    
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
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.ssssss"
        let date = dateFormatter.dateFromString(vine!.dateString)
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        usernameLabel.text = vine!.username
        titleLabel.text = vine!.title
        datePostedLabel.text = dateFormatter.stringFromDate(date!)
        
        numberOfLoopsLabel.text = formattedStringFromNumber(vine!.loops)
        numberOfLikesLabel.text = formattedStringFromNumber(vine!.likes)
        numberOfCommentsLabel.text = formattedStringFromNumber(vine!.comments)
        numberOfRepostsLabel.text = formattedStringFromNumber(vine!.reposts)
        
        userAvatarImageView.layer.cornerRadius = userAvatarImageView.frame.height/2
        userAvatarImageView.clipsToBounds = true
        userAvatarImageView.setImageWithURL(vine!.userAvatarUrl)
    }
    
    private func setupVideo() {
        
        let url = vine!.videoUrl
        let playerItem = AVPlayerItem(URL: url)
        
        if ((cellAVPlayer) != nil) {
            cellAVPlayer!.replaceCurrentItemWithPlayerItem(playerItem)
            
        } else {
            avPlayerLayer.videoGravity = kCAGravityResizeAspectFill
            
            cellAVPlayer = AVPlayer(playerItem: playerItem)
            avPlayerLayer.player = cellAVPlayer
            
            mediaView.layer.addSublayer(avPlayerLayer)
        }
    }
    
    override func layoutSublayersOfLayer(layer: CALayer) {
        
        super.layoutSublayersOfLayer(layer)
        
        avPlayerLayer.frame = mediaView.bounds
    }
    
    //MARK: - IBActions
    
    @IBAction func likeButtonTapped(sender: AnyObject) {
        
        if self.vine!.userHasLiked == true {
            JBFVineClient.sharedClient().unlikePost(vine!, withCompletion: { (success, error) in
                
                if success && error == nil {
                    self.updateCellForUnlike(self.likeButton)
                    
                } else {
                    if error != nil {
                        //send error to VC
                    }
                }
            })
            
        } else {
            JBFVineClient.sharedClient().likePost(vine!, withCompletion: { (success, error) in
                
                if success {
                    self.updateCellForLike(self.likeButton)
                    
                } else {
                    if error != nil {
                        self.delegate?.displayAlertForError(error)
                    }
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
            JBFVineClient.sharedClient().repost(vine!, withCompletion: { (success, error) in
                
                if success && error == nil {
                    self.updateCellForRepost(self.repostButton)
                    
                } else {
                    if error != nil {
                        self.delegate?.displayAlertForError(error)
                    }
                }
            })
        }
    }
    
    //MARK: - Update UI Methods
    
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
    
    //MARK: - Label Formatting Helper
    
    private func formattedStringFromNumber(num: NSNumber) -> String {
        
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        return numberFormatter.stringFromNumber(num)!
    }
}