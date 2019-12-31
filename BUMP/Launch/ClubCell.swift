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
    
    
    var circleTitleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        label.textColor = UIColor.darkText
        return label
    }()
    
    var numMembersLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11.0, weight: .medium)
        label.textColor = UIColor.gray
        label.numberOfLines = 1
        return label
    }()
    
    var followButton : UIButton = {
        let button = UIButton()
//        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11.0, weight: .semibold)
//        button.setTitleColor(UIColor(red:0.00, green:0.69, blue:1.00, alpha:1.0), for: .normal)
//        button.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
        
        button.setTitleColor(Constant.oBlue, for: .normal)
        button.setTitleColor(Constant.oBlue.withAlphaComponent(0.8), for: .highlighted)
        button.setTitle("Follow", for: .normal)
        button.setTitle("F✓", for: .selected)
        return button
    }()
    
    var followButtonAction : (() -> ())?
    @IBAction func followButtonTapped(_ sender: UIButton) {
        self.followButtonAction?()
    }
    
    var centerView : UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.clear
        return v
    }()

    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupCell()
        self.layoutCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    func setupCell() {
        
        self.followButton.addTarget(self, action: #selector(followButtonTapped(_:)), for: .touchDown)
        
        self.contentView.backgroundColor = UIColor.white
        self.contentView.layer.cornerRadius = 12
        self.contentView.layer.masksToBounds = true
        
        
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.15
        self.layer.masksToBounds = false
    }
    
    
    
    func layoutCell() {
        
        self.contentView.addSubview(followButton)
        followButton.layoutToSuperview(.top, offset: 12)
        followButton.layoutToSuperview(.right, offset: -16)
        followButton.set(.height, of: 20.0)
        
        
        //
        self.centerView.addSubview(circleTitleLabel)
//        circleTitleLabel.layout(.top, to: .bottom, of: followButton, offset: 0)
        circleTitleLabel.layoutToSuperview(.top, offset: 0)
        circleTitleLabel.layoutToSuperview(.left, offset: 0)
        circleTitleLabel.layoutToSuperview(.right, offset: 0)
        
        self.centerView.addSubview(numMembersLabel)
        numMembersLabel.layout(.top, to: .bottom, of: circleTitleLabel, offset: 5)
        numMembersLabel.layoutToSuperview(.left, offset: 0)
        numMembersLabel.layoutToSuperview(.right, offset: 0)
        numMembersLabel.layoutToSuperview(.bottom, offset: 0)
        
        self.contentView.addSubview(centerView)
        centerView.layoutToSuperview(.centerY)
        centerView.layoutToSuperview(.left, offset: 20)
        centerView.layoutToSuperview(.right, offset: -20)
        
//        bottomContainer.addSubview(x)
////        x.layoutToSuperview(.top, offset: 20)
////        x.layoutToSuperview(.bottom, offset: 0)
//        x.layoutToSuperview(.left, offset: 0)
//        x.layoutToSuperview(.right, offset: 0)
//        x.layoutToSuperview(.centerY)
    }
    
    
    
    
    
    
    
}

