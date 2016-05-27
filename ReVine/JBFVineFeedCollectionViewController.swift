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
    
    var popularVines = JBFVineClient.sharedDataStore().popularVines
    var avPlayer = AVPlayer()
    var avPlayerLayer: AVPlayerLayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        
        
        JBFVineClient.sharedDataStore().getPopularVinesWithCompletion { (success) in
            
            if (success) {
                NSOperationQueue .mainQueue().addOperationWithBlock({
                    
                    self.collectionView?.reloadData()
                    print(JBFVineClient.sharedDataStore().popularVines.count)
                })
            }
        }
        
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
    }
    
//     MARK: UICollectionViewDataSource
    
    func vineForIndexPath(indexPath: NSIndexPath) -> JBFVine {
        return popularVines[indexPath.item] as! JBFVine
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return JBFVineClient.sharedDataStore().popularVines.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("JBFVinePostCollectionViewCell", forIndexPath: indexPath) as! JBFVinePostCollectionViewCell
        
        let vine = vineForIndexPath(indexPath)
        cell.numberOfLoopsLabel.text = "\(vine.loops)"
        cell.datePostedLabel.text = "\(indexPath.item)"
        cell.usernameLabel.text = vine.username
        cell.titleLabel.text = vine.title
        cell.numberOfLikesLabel.text = "\(vine.likes)"
        cell.numberOfCommentsLabel.text = "\(vine.comments)"
        cell.numberOfRepostsLabel.text = "\(vine.reposts)"
        
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        cell.cvCellMediaView.layer.insertSublayer(avPlayerLayer, atIndex: 0)
        avPlayerLayer.frame = cell.cvCellMediaView.bounds
        cell.cvCellView.layoutSubviews()
        
        let url = vine.videoUrl
        let playerItem = AVPlayerItem(URL: url)
        avPlayer.replaceCurrentItemWithPlayerItem(playerItem)
        
        avPlayer.play()
        return cell
        
        //i should add the thumbnail here instead... then elsewhere make a queue, play the queue when scrolls, and adjust queue accordingly
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        //access content offset?
    }
    
    func scrollToItemAtIndexPath(indexPath: NSIndexPath, atScrollPosition scrollPosition: UICollectionViewScrollPosition, animated: Bool) {
        
        
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
