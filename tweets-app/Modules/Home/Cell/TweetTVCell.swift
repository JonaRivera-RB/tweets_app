//
//  TweetTVCell.swift
//  tweets-app
//
//  Created by Misael Rivera on 10/04/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import UIKit
import Kingfisher

class TweetTVCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var tweetImageView: UIImageView!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    //MARK: - Properties
    private var videoUrl: URL?
    var needsToShowVideo: ((_ url: URL) -> Void)?
    
    //MARK: - IBActions
    @IBAction func openVideoAction() {
        guard let videoURL = videoUrl else { return }
        needsToShowVideo?(videoURL)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setupCellWith(tweet: Tweet) {
        nameLabel.text = tweet.author.names
        nicknameLabel.text = tweet.author.nickname
        tweetLabel.text = tweet.text
        
        if tweet.hasImage {
            tweetImageView.isHidden = false
            tweetImageView.kf.setImage(with: URL(string: tweet.imageUrl))
        }else {
            tweetImageView.isHidden = true
        }
        
        videoButton.isHidden = !tweet.hasVideo
        videoUrl = URL(string: tweet.videoUrl)
        
        dateLabel.text = tweet.createdAt
    }
}
