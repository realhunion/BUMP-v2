//
//  HubCell.swift
//  BUMP
//
//  Created by Hunain Ali on 1/6/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import Firebase
import QuickLayout

class HubCell: UICollectionViewCell {
    
    
    var titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        label.textColor = Constant.oBlack
        return label
    }()
    
    
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
        
        self.centerView.addSubview(titleLabel)
        titleLabel.layoutToSuperview(.top, offset: 0)
        titleLabel.layoutToSuperview(.left, offset: 0)
        titleLabel.layoutToSuperview(.right, offset: 0)
        titleLabel.layoutToSuperview(.bottom, offset: 0)
        
        self.contentView.addSubview(centerView)
        centerView.layoutToSuperview(.centerY)
        centerView.layoutToSuperview(.left, offset: 20)
        centerView.layoutToSuperview(.right, offset: -20)
    }
    
    
    
    
    
    
    
}

