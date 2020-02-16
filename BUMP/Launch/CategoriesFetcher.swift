//
//  CategoriesFetcher.swift
//  BUMP
//
//  Created by Hunain Ali on 2/12/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import Foundation
import Firebase

protocol CategoriesFetcherDelegate : class {
    func categoriesFetched(categoryArray : [CircleCategory])
}

class CategoriesFetcher {
    
    var db = Firestore.firestore()
    
    weak var delegate : CategoriesFetcherDelegate?
    

    func shutDown() {
        self.delegate = nil
    }
    
    func fetchCategories() {
        
        db.collection("LaunchCategories").getDocuments { (snap, err) in
            guard let docs = snap?.documents else { return }
            
            var cArray : [CircleCategory] = []
            for doc in docs {
                
                if let categoryName = doc.data()["categoryName"] as? String {
                    let category = CircleCategory(categoryName: categoryName, categoryID: doc.documentID, numCircles: 60)
                    cArray.append(category)
                    print("potter 0")
                }
                
            }
            
            print("potter 1 \(cArray)")
            
            self.delegate?.categoriesFetched(categoryArray: cArray)
            
        }
        
    }
    
    
    
    
    
}
