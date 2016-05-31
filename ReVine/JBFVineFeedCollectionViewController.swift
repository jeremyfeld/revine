//
//  JBFVineFeedCollectionViewController.swift
//  ReVine
//
//  Created by Jeremy Feld on 5/25/16.
//  Copyright © 2016 JBF. All rights reserved.
//

import UIKit
import AVFoundation

private let reuseIdentifier = "Cell"

class JBFVineFeedCollectionViewController: UICollectionViewController {
    
    private var popularVines = JBFVineClient.sharedClient().popularVines
    private var avPlayer = AVPlayer()
    private var currentCell = JBFVinePostCollectionViewCell()
    private var previousCell = JBFVinePostCollectionViewCell()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height)
        
        JBFVineClient.sharedClient().getPopularVinesWithSessionID(JBFVineClient.sharedClient().currentUserKey()) { (success) in
            
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(JBFVineFeedCollectionViewController.playerItemDidReachEnd(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object:currentCell.cellAVPlayer)
    }
    
    //     MARK: UICollectionViewDataSource
    
    private func vineForIndexPath(indexPath: NSIndexPath) -> JBFVine {
        
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
        cell.vine = vine
        
        return cell
    }
    
    //    MARK: AVPlayer Methods
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        //        if indexPath.section == 0 {
        
        currentCell = cell as! JBFVinePostCollectionViewCell
        
        currentCell.cellAVPlayer!.play()
        //        }
    }
    
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        previousCell = cell as! JBFVinePostCollectionViewCell
        
        previousCell.cellAVPlayer!.pause()
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
        
        //                for cell in (self.collectionView?.visibleCells())! {
        //
        //                    self.currentCell = cell as! JBFVinePostCollectionViewCell
        //
        //                    self.currentCell.cellAVPlayer!.play()
        //                }
    }
    
    func playerItemDidReachEnd(notification: NSNotification) {
        
        currentCell.cellAVPlayer!.seekToTime(kCMTimeZero)
        currentCell.cellAVPlayer!.play()
    }
    
}
