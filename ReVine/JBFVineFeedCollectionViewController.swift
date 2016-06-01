//
//  JBFVineFeedCollectionViewController.swift
//  ReVine
//
//  Created by Jeremy Feld on 5/25/16.
//  Copyright © 2016 JBF. All rights reserved.
//

import UIKit
import AVFoundation

private let reuseIdentifier = "vinePostCellReuseId"

class JBFVineFeedCollectionViewController: UICollectionViewController {
    
    private var currentCell = JBFVinePostCollectionViewCell()
    private var previousCell = JBFVinePostCollectionViewCell()
    private var offsetForNextCell: CGFloat = CGFloat()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height)
        
        JBFVineClient.sharedClient().getPopularVinesWithCompletion { (success) in
            
            if (success) {
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.collectionView?.reloadData()
                })
                
            } else {
                let controller = UIAlertController.alertControllerWithTitle("Error", message: "There was an error loading the timeline")
                
                self.presentViewController(controller, animated: true, completion: nil)
            }
        }
        
        self.collectionView!.registerClass(JBFVinePostCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(JBFVineFeedCollectionViewController.playerItemDidReachEnd(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object:currentCell.cellAVPlayer)
    }
    
    //MARK: - UICollectionViewDataSource
    
    private func vineForIndexPath(indexPath: NSIndexPath) -> JBFVine {
        
        return JBFVineClient.sharedClient().popularVines[indexPath.item] as! JBFVine
    }
    
    //MARK: - AVPlayer Methods
    
    func playerItemDidReachEnd(notification: NSNotification) {
        
        currentCell.cellAVPlayer!.seekToTime(kCMTimeZero)
        currentCell.cellAVPlayer!.play()
    }
    
    //MARK: - Helper Methods
    
    private func contentOffsetForIndexPath(indexPath: NSIndexPath) -> CGFloat {
        
        return view.frame.height * CGFloat(indexPath.item)
    }
}

//MARK: - UICollectionViewDataSource

extension JBFVineFeedCollectionViewController {
    
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
}

//MARK: - UICollectionViewDelegate

extension JBFVineFeedCollectionViewController {
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        currentCell = cell as! JBFVinePostCollectionViewCell
        currentCell.cellAVPlayer!.play()
        
        offsetForNextCell = contentOffsetForIndexPath(indexPath)
    }
    
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        previousCell = cell as! JBFVinePostCollectionViewCell
        previousCell.cellAVPlayer!.pause()
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if collectionView?.contentOffset.y > (offsetForNextCell - (view.frame.height / 2)) {
            
            collectionView?.setContentOffset(CGPointMake(0, offsetForNextCell), animated: true)
        }
    }
}