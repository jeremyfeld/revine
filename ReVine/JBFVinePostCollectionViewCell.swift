//
//  JBFVinePostCollectionViewCell.swift
//  ReVine
//
//  Created by Jeremy Feld on 5/25/16.
//  Copyright © 2016 JBF. All rights reserved.
//

import UIKit

class JBFVinePostCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cvCellView: UIView!
    @IBOutlet weak var cvCellMediaView: UIView!
    @IBOutlet weak var numberOfLoopsLabel: UILabel!
    @IBOutlet weak var datePostedLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numberOfLikesLabel: UILabel!
    @IBOutlet weak var numberOfCommentsLabel: UILabel!
    @IBOutlet weak var numberOfRepostsLabel: UILabel!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    
    enum buttonTypes {
        case like
        case repost
        case comment
    }
    
    @IBAction func likeButtonTapped(sender: AnyObject)
    {
    }

    @IBAction func commentButtonTapped(sender: AnyObject)
    {
    }
    @IBOutlet weak var repostButtonTapped: UIButton!
}
