//
//  ClubsCell.swift
//  BUMP
//
//  Created by Hunain Ali on 10/24/19.
//  Copyright © 2019 BUMP. All rights reserved.
//

import Firebase
import QuickLayout

class ClubCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    var initialized : Bool = false
    
    var clubTitleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        label.textColor = UIColor.darkText
        return label
    }()
    var numMembersLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10.0, weight: .semibold)
        label.textColor = UIColor.gray
        label.numberOfLines = 1
        return label
    }()
    var usersHereLabel : InsetLabel = {
        let label = InsetLabel()
        label.contentInsets = UIEdgeInsets(top: 3.0, left: 6.0, bottom: 3.0, right: 6.0)
        label.backgroundColor = UIColor.systemPink
        label.font = UIFont.systemFont(ofSize: 10.0, weight: .semibold)
        label.textColor = .white
        label.textAlignment = NSTextAlignment.center
        
        let frameHeight = label.estimateFrameForText("4 HERE", textFont: label.font).height + label.contentInsets.top + label.contentInsets.bottom
            
        label.layer.cornerRadius = frameHeight/2
        label.layer.masksToBounds = true
        
        return label
    }()
    var followButton : UIButton = {
        let button = UIButton()
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11.0, weight: .semibold)
        button.setTitleColor(UIColor(red:0.00, green:0.69, blue:1.00, alpha:1.0), for: .normal)
        
        return button
    }()
    
    
    
    func layoutCell() {
        
        self.followButton.addTarget(self, action: #selector(self.tappedFollowButton(_:)), for: .touchUpInside)
        
        self.contentView.backgroundColor = UIColor.white
        self.contentView.layer.cornerRadius = 12
        self.contentView.layer.masksToBounds = true
        
        
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.15
        self.layer.masksToBounds = false
        
        initialized = true
    }
    
    
    func setupXView() {
        
        self.contentView.addSubview(followButton)
        followButton.layoutToSuperview(.top, offset: 10)
        followButton.layoutToSuperview(.right, offset: -15)
        
        let x = UIView()
        
        x.addSubview(clubTitleLabel)
        clubTitleLabel.layoutToSuperview(.top, offset: 0)
        clubTitleLabel.layoutToSuperview(.left, offset: 0)
        clubTitleLabel.layoutToSuperview(.right, offset: 0)
        
        x.addSubview(numMembersLabel)
        numMembersLabel.layout(.top, to: .bottom, of: clubTitleLabel, offset: 5)
        numMembersLabel.layoutToSuperview(.left, offset: 0)
        numMembersLabel.layoutToSuperview(.right, offset: 0)
    
        
        x.addSubview(usersHereLabel)
        usersHereLabel.layout(.top, to: .bottom, of: numMembersLabel, offset: 7)
        usersHereLabel.layoutToSuperview(.left, offset: 0)
        usersHereLabel.layoutToSuperview(.bottom, offset: 0)
        
        self.contentView.addSubview(x)
        x.layoutToSuperview(.left, offset: 20)
        x.layoutToSuperview(.right, offset: -20)
        x.layoutToSuperview(.centerY)
        
    }
    
    func setupXAloneView() {
        
        self.contentView.addSubview(followButton)
        followButton.layoutToSuperview(.top, offset: 10)
        followButton.layoutToSuperview(.right, offset: -15)
        
        let x = UIView()
        
        x.addSubview(clubTitleLabel)
        clubTitleLabel.layoutToSuperview(.top, offset: 0)
        clubTitleLabel.layoutToSuperview(.left, offset: 0)
        clubTitleLabel.layoutToSuperview(.right, offset: 0)
        
        x.addSubview(numMembersLabel)
        numMembersLabel.layout(.top, to: .bottom, of: clubTitleLabel, offset: 5)
        numMembersLabel.layoutToSuperview(.left, offset: 0)
        numMembersLabel.layoutToSuperview(.right, offset: 0)
        numMembersLabel.layoutToSuperview(.bottom, offset: 0)
        
        self.contentView.addSubview(x)
        x.layoutToSuperview(.left, offset: 20)
        x.layoutToSuperview(.right, offset: -20)
        x.layoutToSuperview(.centerY)
    }
    
    
    
    
    func setupCell(clubTitle: String, numMembers: Int, numUsersHere: Int, isFollowing : Bool) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.clubTitleLabel.text = nil
        self.numMembersLabel.text = nil
        self.usersHereLabel.text = nil
        self.followButton.setTitle(nil, for: .normal)
    }
    
}

