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

protocol AlertProtocol: class {
    
    func displayAlertForError(error:NSError)
    func displayAlertForComment()
}

enum ScrollDirection: String {
    case ScrollingDown = "scrollingDown"
    case ScrollingUp = "scrollingUp"
}

class JBFVineFeedCollectionViewController: UICollectionViewController, AlertProtocol {
    
    private var currentCell = JBFVinePostCollectionViewCell()
    private var previousCell = JBFVinePostCollectionViewCell()
    private var offsetForNextCell = CGFloat()
    private var directionalContentOffset = CGFloat()
    private var vines = [JBFVine]()
    private var scrollDirection = String()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        JBFVineClient.sharedClient().getPopularVinesWithCompletion { (array, error) in
            
            if array.count > 0 && error == nil {
                self.vines = array
                self.collectionView?.reloadData()
                self.collectionView?.layoutIfNeeded()
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.currentCell.cellAVPlayer!.play()
                }
                
            } else {
                let controller = UIAlertController.alertControllerWithTitle("Uh-oh!", message: "There was an error loading the timeline: \(error.localizedDescription)")
                
                self.presentViewController(controller, animated: true, completion: nil)
            }
        }
        
        self.collectionView!.registerClass(JBFVinePostCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(JBFVineFeedCollectionViewController.playerItemDidReachEnd(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object:currentCell.cellAVPlayer)
        
        customizeNavigationBar()
    }
    
    //MARK: - UICollectionViewDataSource
    
    private func vineForIndexPath(indexPath: NSIndexPath) -> JBFVine {
        
        return vines[indexPath.item]
    }
    
    //MARK: - AVPlayer Methods
    
    func playerItemDidReachEnd(notification: NSNotification) {
        
        currentCell.cellAVPlayer?.seekToTime(kCMTimeZero)
        currentCell.cellAVPlayer?.play()
    }
    
    //MARK: - Helper Methods
    
    private func contentOffsetForIndexPath(indexPath: NSIndexPath) -> CGFloat {
        
        return view.frame.size.height * CGFloat(indexPath.item)
    }
    
    func postComment() {
    
    }
    
    //MARK: - AlertProtocol
    
    func displayAlertForError(error: NSError) {
        
        let controller = UIAlertController.alertControllerWithTitle("Oops!", message: "There was an error: \(error.localizedDescription)")
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
    func displayAlertForComment() {
        
        let controller = UIAlertController(title: "Comment", message: nil, preferredStyle: .Alert)
        
        controller.addTextFieldWithConfigurationHandler { (text) in
            text.placeholder = "Enter your comment:"
        }
        controller.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler:nil))
        controller.addAction(UIAlertAction(title: "Post", style: .Default, handler: { (action) in
        }))
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
    //MARK: - Deinitialization
    
    deinit {
        
        removeObserver(self, forKeyPath: AVPlayerItemDidPlayToEndTimeNotification)
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
        cell.delegate = self
        
        return cell
    }
}

    //MARK: - UICollectionViewDelegate

extension JBFVineFeedCollectionViewController {
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        currentCell = cell as! JBFVinePostCollectionViewCell
        
        offsetForNextCell = contentOffsetForIndexPath(indexPath)
    }
    
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        previousCell = cell as! JBFVinePostCollectionViewCell
        previousCell.cellAVPlayer!.pause()
    }
    
    
    override func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if  scrollDirection == ScrollDirection.ScrollingDown.rawValue &&
            collectionView?.contentOffset.y > (offsetForNextCell - (view.frame.size.height / 2)) {
            
            collectionView?.setContentOffset(CGPointMake(0, offsetForNextCell), animated: true)
            currentCell.cellAVPlayer?.play()
            
        } else if scrollDirection == ScrollDirection.ScrollingUp.rawValue &&
            collectionView?.contentOffset.y < (offsetForNextCell + (view.frame.size.height / 2)) {
            
            collectionView?.setContentOffset(CGPointMake(0, offsetForNextCell), animated: true)
            currentCell.cellAVPlayer?.play()
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {

        if (directionalContentOffset > collectionView!.contentOffset.y) {
            scrollDirection = ScrollDirection.ScrollingUp.rawValue
  
        } else if (directionalContentOffset < collectionView!.contentOffset.y) {
            scrollDirection = ScrollDirection.ScrollingDown.rawValue
        }
        
        directionalContentOffset = collectionView!.contentOffset.y
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

    //MARK: - Nav Bar Customization

extension JBFVineFeedCollectionViewController {
    
    func customizeNavigationBar() {
        
        let logo = UIImage(named: "vine-med")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
    }
}