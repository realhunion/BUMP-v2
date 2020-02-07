//
//  PickCirclesTVC.swift
//  BUMP
//
//  Created by Hunain Ali on 1/21/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import Foundation
import UIKit

class PickCirclesTVC : MyCirclesTVC, UIAdaptivePresentationControllerDelegate {
    
    
    
    //MARK:- Dismiss
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag) {
            
            self.onDismissAction?()
            
        }
    }
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
//        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.flashScrollIndicators()
    }
    
    
    var onDismissAction : (() -> ())?

    
    
    //MARK:- MAIN
    
    lazy var doneButton : UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 8.0
        button.layer.masksToBounds = true
        return button
    }()


    
    override func setupBarButtons() {
        self.doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    @objc override func doneButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func layoutTableView() {
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false


        doneButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        doneButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true

        tableView!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView!.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView!.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView!.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -20).isActive = true
        
    }
    
    
    
    
}
