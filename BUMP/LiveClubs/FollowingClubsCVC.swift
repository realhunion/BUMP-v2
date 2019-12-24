//
//  ClubsFollowingCVC.swift
//  BUMP
//
//  Created by Hunain Ali on 11/12/19.
//  Copyright © 2019 BUMP. All rights reserved.
//

import Foundation


class FollowingClubsCVC : CampusClubsCVC {
    
    
    override func setupClubsFetcher() {
        
        self.clubsFetcher = ClubsFetcher()
        self.clubsFetcher?.delegate = self
        self.clubsFetcher?.monitorClubsFollowing()
        
    }
    
}
