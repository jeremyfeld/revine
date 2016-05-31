//
//  JBFVineFeedCollectionViewController.swift
//  ReVine
//
//  Created by Jeremy Feld on 5/25/16.
//  Copyright © 2016 JBF. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AVFoundation

private let reuseIdentifier = "Cell"

protocol UpdateButtonTintProtocol {
    
    func updateCellForUnlike(button:UIButton, cell: JBFVinePostCollectionViewCell)
    func updateCellForLike(button:UIButton, cell: JBFVinePostCollectionViewCell)
    func updateCellForRepost(button:UIButton, cell: JBFVinePostCollectionViewCell)
}

class JBFVineFeedCollectionViewController: UICollectionViewController, UpdateButtonTintProtocol {
    
    var popularVines = JBFVineClient.sharedClient().popularVines
    var avPlayer = AVPlayer()
    var currentCell = JBFVinePostCollectionViewCell()
    var previousCell = JBFVinePostCollectionViewCell()
    let originalLikeImage = UIImage(named: "like");
    let originalRepostImage = UIImage(named: "repost")
    var tintedLikeImage = UIImage()
    var tintedRepostImage = UIImage()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        
        self.tintedLikeImage = (originalLikeImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate))!
        self.tintedRepostImage = (originalRepostImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate))!
        
        JBFVineClient.sharedClient().getPopularVinesWithSessionID(JBFVineClient.sharedClient().returnUserKey()) { (success) in
            
            if (success) {
                
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    
                    self.collectionView?.reloadData()
                })
                
            } else {
                
                let controller = UIAlertController.alertControllerWithTitle("Error", message: "There was an error loading the timeline")
                
                self.presentViewController(controller, animated: true, completion: nil)
            }
        }
        
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(JBFVineFeedCollectionViewController.playerItemDidReachEnd(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object:self.currentCell.cellAVPlayer)
    }
    
    //     MARK: UICollectionViewDataSource
    
    func vineForIndexPath(indexPath: NSIndexPath) -> JBFVine {
        
        return popularVines[indexPath.item] as! JBFVine
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return JBFVineClient.sharedClient().popularVines.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("JBFVinePostCollectionViewCell", forIndexPath: indexPath) as! JBFVinePostCollectionViewCell
        
        cell.updateButtonDelegate = self
        
        let vine = vineForIndexPath(indexPath)
        
        var dateFormatter: NSDateFormatter = NSDateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.ssssss"
        var date: NSDate! = dateFormatter.dateFromString(vine.dateString)
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        cell.vine = vine
        cell.numberOfLoopsLabel.text = cell.returnFormattedStringFromNumber(vine.loops)
        cell.datePostedLabel.text = dateFormatter.stringFromDate(date)
        cell.usernameLabel.text = vine.username
        cell.titleLabel.text = vine.title
        
        if vine.userHasLiked {
            
            cell.likeButton.setImage(tintedLikeImage, forState: UIControlState.Normal)
            cell.likeButton.tintColor = UIColor.redColor()
            
        } else {
            
            cell.likeButton.setImage(originalLikeImage, forState: UIControlState.Normal)
        }
        
        if vine.userHasReposted {
            
            cell.repostButton.setImage(tintedLikeImage, forState: UIControlState.Normal)
            cell.repostButton.tintColor = UIColor.purpleColor()
            
        } else {
            
            cell.repostButton.setImage(originalRepostImage, forState: UIControlState.Normal)
        }
    
        cell.numberOfLikesLabel.text = cell.returnFormattedStringFromNumber(vine.likes)
        cell.numberOfCommentsLabel.text = cell.returnFormattedStringFromNumber(vine.comments)
        cell.numberOfRepostsLabel.text = cell.returnFormattedStringFromNumber(vine.reposts)
        cell.userAvatarImageView.image = vine.userAvatarImage
        cell.userAvatarImageView.layer.cornerRadius = cell.userAvatarImageView.frame.height/2
        cell.userAvatarImageView.clipsToBounds = true
        //cell.vineThumbnailImageView.image = vine.vineThumbnailImage
        
        let url = vine.videoUrl
        let playerItem = AVPlayerItem(URL: url)
        
        if ((cell.cellAVPlayer) != nil) {
            
            cell.cellAVPlayer!.replaceCurrentItemWithPlayerItem(playerItem)
            
        } else {
            
            cell.cellAVPlayer = AVPlayer(playerItem: playerItem)
            
            var avPlayerLayer = AVPlayerLayer(player: cell.cellAVPlayer)
            cell.mediaView.layer.insertSublayer(avPlayerLayer, atIndex: 0)
            avPlayerLayer.frame = cell.mediaView.bounds
        }
        
        return cell
    }
    
//    MARK: AVPlayer Methods
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        //        if indexPath.section == 0 {
        
        self.currentCell = cell as! JBFVinePostCollectionViewCell
        
        self.currentCell.cellAVPlayer!.play()
        //        }
    }
    
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        self.previousCell = cell as! JBFVinePostCollectionViewCell
        
        self.previousCell.cellAVPlayer!.pause()
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        //        for cell in (self.collectionView?.visibleCells())! {
        //
        //            let cellToPlay = cell as! JBFVinePostCollectionViewCell
        //
        //            cellToPlay.cellAVPlayer!.pause()
        //        }
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        //        for cell in (self.collectionView?.visibleCells())! {
        //
        //            self.currentCell = cell as! JBFVinePostCollectionViewCell
        //
        //            self.currentCell.cellAVPlayer!.play()
        //        }
    }
    
    func playerItemDidReachEnd(notification: NSNotification) {
        
        self.currentCell.cellAVPlayer!.seekToTime(kCMTimeZero)
        self.currentCell.cellAVPlayer!.play()
    }
    
//    MARK: Update Button Tint Methods
    
    func updateCellForUnlike(button:UIButton, cell: JBFVinePostCollectionViewCell) {
        
        cell.likeButton.setImage(originalLikeImage, forState: UIControlState.Normal)
        cell.vine?.userHasLiked = false
    }
    
    func updateCellForLike(button:UIButton, cell: JBFVinePostCollectionViewCell) {
        
        cell.likeButton.setImage(tintedLikeImage, forState: UIControlState.Normal)
        cell.likeButton.tintColor = UIColor.redColor()
        cell.vine?.userHasLiked = true
    }
    
    func updateCellForRepost(button:UIButton, cell: JBFVinePostCollectionViewCell) {
        
        cell.repostButton.setImage(tintedRepostImage, forState: UIControlState.Normal)
        cell.repostButton.tintColor = UIColor.purpleColor()
        cell.vine?.userHasReposted = true
    }
}
