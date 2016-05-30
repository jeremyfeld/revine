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

class JBFVineFeedCollectionViewController: UICollectionViewController {
    
    var popularVines = JBFVineClient.sharedClient().popularVines
    var avPlayer = AVPlayer()
    var currentCell = JBFVinePostCollectionViewCell()
    var previousCell = JBFVinePostCollectionViewCell()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        
        JBFVineClient.sharedClient().getPopularVinesWithSessionID(JBFVineClient.sharedClient().returnUserKey()) { (success) in
            
            if (success) {
                
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    
                    self.collectionView?.reloadData()
                })
            }
        }

        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
     
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(JBFVineFeedCollectionViewController.playerItemDidReachEnd(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object:self.currentCell.cellAVPlayer)
    }
    
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
        
        let vine = vineForIndexPath(indexPath)
        
        var dateFormatter: NSDateFormatter = NSDateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.ssssss"
        var date: NSDate! = dateFormatter.dateFromString(vine.dateString)
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        cell.vine = vine
        cell.numberOfLoopsLabel.text = "\(vine.loops)"
        cell.datePostedLabel.text = dateFormatter.stringFromDate(date)
        cell.usernameLabel.text = vine.username
        cell.titleLabel.text = vine.title
        
        if vine.userHasLiked {
            
            cell.likeButtonContainerView.backgroundColor = UIColor.purpleColor()
            
        } else {
            
            cell.likeButtonContainerView.backgroundColor = UIColor.whiteColor()
        }
        
        if vine.userHasReposted {
            
            cell.repostButtonContainerView.backgroundColor = UIColor.purpleColor()
            
        } else {
            
            cell.repostButtonContainerView.backgroundColor = UIColor.whiteColor()
        }
        
        cell.numberOfLikesLabel.text = "\(vine.likes)"
        cell.numberOfCommentsLabel.text = "\(vine.comments)"
        cell.numberOfRepostsLabel.text = "\(vine.reposts)"
        cell.userAvatarImageView.image = vine.userAvatarImage
        //        cell.vineThumbnailImageView.image = vine.vineThumbnailImage
        
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
    
    //     MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return false
     }
     
     override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
     return false
     }
     
     override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
     
     }
     */
}
