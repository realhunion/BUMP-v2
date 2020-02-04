//
//  FeedCell.swift
//  BUMP
//
//  Created by Hunain Ali on 12/4/19.
//  Copyright © 2019 BUMP. All rights reserved.
//

import UIKit
import Firebase

class FeedCell: UITableViewCell {
    
    
    
    var circleTitleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .subheadline).pointSize, weight: .semibold)
//        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = false
        label.numberOfLines = 1
        label.textColor = UIColor.black
//        label.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.3)
        return label
    }()
    
    var firstMessageLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .subheadline).pointSize, weight: .regular)
//        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = false
        label.textColor = UIColor.black
        label.numberOfLines = 3
        
        let attributedString = NSMutableAttributedString(string: "-")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        label.attributedText = attributedString
        
        return label
    }()
    
    var followButton : UIButton = {
        let button = UIButton()
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .caption1).pointSize, weight: .semibold)
        button.setTitleColor(Constant.oBlue, for: .normal)
        button.setTitleColor(Constant.oBlue.withAlphaComponent(0.8), for: .highlighted)
        button.setTitle("Follow chat", for: .normal)
        button.setTitle("F✓", for: .selected)
        
        button.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        return button
    }()
    var followButtonAction : (() -> ())?
    @IBAction func followButtonTapped(_ sender: UIButton) {
        self.followButtonAction?()
    }
    
    
    var timeLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .caption1).pointSize, weight: .regular)
        label.adjustsFontSizeToFitWidth = false
        label.numberOfLines = 1
        label.textColor = UIColor.darkGray
        
        return label
    }()
    
    
    var cardView : UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        view.layer.shadowRadius = 2.0
        view.layer.shadowOpacity = 0.15
        view.layer.masksToBounds = false
        
        return view
    }()
    
    var cardContentView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupCell()
        
        self.layoutCell()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupCell() {
        
        self.selectionStyle = .none
        
        self.followButton.addTarget(self, action: #selector(followButtonTapped(_:)), for: .touchUpInside)
        
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        
    }
    
    
    
    func layoutCell() {
        cardContentView.addSubview(followButton)
        followButton.layoutToSuperview(.top, offset: 0)
        followButton.layoutToSuperview(.left, offset: 0)
        followButton.set(.height, of: 20.0)
        
        cardContentView.addSubview(timeLabel)
        timeLabel.layoutToSuperview(.top, offset: 0)
        timeLabel.layoutToSuperview(.right, offset: 0)
        timeLabel.set(.height, of: 20.0)
        
        cardContentView.addSubview(circleTitleLabel)
        circleTitleLabel.layout(.top, to: .bottom, of: followButton, offset: 3)
        circleTitleLabel.layout(.top, to: .bottom, of: timeLabel, offset: 3)
        circleTitleLabel.layoutToSuperview(.left, offset: 0)
        circleTitleLabel.layoutToSuperview(.right, offset: 0)
        
        
        cardContentView.addSubview(firstMessageLabel)
        firstMessageLabel.layout(.top, to: .bottom, of: circleTitleLabel, offset: 2)
        firstMessageLabel.layoutToSuperview(.left, offset: 0)
        firstMessageLabel.layoutToSuperview(.right, offset: 0)
        firstMessageLabel.layoutToSuperview(.bottom, offset: 0)
        
        cardView.addSubview(cardContentView)
        cardContentView.layoutToSuperview(.top, offset: 12) // 10
        cardContentView.layoutToSuperview(.bottom, offset: -16) //-15
        cardContentView.layoutToSuperview(.left, offset: 20) //20
        cardContentView.layoutToSuperview(.right, offset: -20) //-20
        
        self.contentView.addSubview(cardView)
        cardView.layoutToSuperview(.top, offset: 12) //15
        cardView.layoutToSuperview(.bottom, offset: -12) //-15
        cardView.layoutToSuperview(.left, offset: 24) //20
        cardView.layoutToSuperview(.right, offset: -24) //-20
    }
    
    
    
//    override func prepareForReuse() {
//        for i in self.cardView.subviews {
//            i.removeFromSuperview()
//        }
//    }
    
}
