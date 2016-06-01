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
    private var vines: [JBFVine] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        JBFVineClient.sharedClient().getPopularVinesWithCompletion { (array, error) in
            
            if array.count > 0 && error == nil {
                self.vines = array
                
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.collectionView?.reloadData()
                })
                
            } else {
                let controller = UIAlertController.alertControllerWithTitle("Uh-oh!", message: "There was an error loading the timeline: \(error.localizedDescription)")
                
                self.presentViewController(controller, animated: true, completion: nil)
            }
        }

        self.collectionView!.registerClass(JBFVinePostCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(JBFVineFeedCollectionViewController.playerItemDidReachEnd(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object:currentCell.cellAVPlayer)
    }
    
    //MARK: - UICollectionViewDataSource
    
    private func vineForIndexPath(indexPath: NSIndexPath) -> JBFVine {
        
        return vines[indexPath.item]
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

        return vines.count
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

    //MARK: - UICollectionViewDelegateFlowLayout

extension JBFVineFeedCollectionViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(view.bounds.size.width, view.bounds.size.height)
    }
}