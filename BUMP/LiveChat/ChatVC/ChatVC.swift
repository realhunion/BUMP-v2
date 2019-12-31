//  ChatLogVC.swift
//  OASIS2
//
//  Created by Honey on 5/25/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import UIKit
import SPStorkController
import Firebase
import QuickLayout

class ChatVC: SwipeRightToPopViewController, UIGestureRecognizerDelegate, SPStorkControllerDelegate {
//
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        SPStorkController.scrollViewDidScroll(scrollView)
//    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    deinit {
        print("\n CHATVC is DE INIT \n")
    }
    
    let incomingTextMessageCellID = "incomingTextMessageCellID"
    let outgoingTextMessageCellID = "outgoingTextMessageCellID"
    
    //FIX: better solution??
    var msgFetcher : MessageFetcher!
    var msgSender : MessageSender!
    
    var msgArray : [[Message]] = [] // Each item is Msg Group Array.
    
    var chatID : String = "Error Club"
    var chatName : String = "Error Club"
    var circleID : String = "Error Club"
    var circleName : String = "Error Club"
    var circleEmoji : String = "🤙"
    
    
    lazy var navBar: UINavigationBar = UINavigationBar()
    lazy var subNavBar : UIView = UIView()
    
    lazy var followChatButton : UIButton = {
        
        let button = UIButton()
        button.titleLabel?.textAlignment = .right
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10.0, weight: .semibold)
        button.setTitleColor(Constant.oBlue, for: .normal)
        button.setTitleColor(Constant.oBlue.withAlphaComponent(0.8), for: .highlighted)
        button.setTitle("Follow chat", for: .normal)
        button.setTitle("F✓", for: .selected)
        
        button.titleLabel?.numberOfLines = 1
        
        button.addTarget(self, action: #selector(followChatButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    let inputBarHeight : CGFloat = 50.0
    lazy var inputBarView: InputBarView = {
        var inputBarView = InputBarView()
        inputBarView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.inputBarHeight)
        inputBarView.translatesAutoresizingMaskIntoConstraints = false
        inputBarView.chatVC = self
        return inputBarView
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCollectionView()
        self.setupNavBar()
        self.setupSubNavBar()
        
        self.setupKeyboardObservers()
        
        self.setupMessageFetcher()
            
        self.setupMessageSender()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.updateFeedLastSeen()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        self.updateFeedLastSeen()
    }
    
    func updateFeedLastSeen() {
        CircleManager.shared.updateFeedLastSeen(chatID: chatID)
    }
    
    
    
    func shutDown () {
        
        self.inputBarView.shutDown()
        
        self.msgFetcher.shutDown()
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    
    
    
    // MARK: - Set-Up
    
    var inputBarBottomAnchor: NSLayoutConstraint?
    func setupCollectionView () {
        
        let tapG = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
        collectionView.addGestureRecognizer(tapG)
        tapG.delegate = self
        
        self.edgesForExtendedLayout = []
        view.backgroundColor = UIColor.white
        collectionView?.indicatorStyle = .default
        collectionView?.backgroundColor = view.backgroundColor
        collectionView?.contentInset = UIEdgeInsets(top: 44+36+10, left: 0, bottom: 10, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 44+36, left: 0, bottom: 0, right: 0)
        collectionView?.keyboardDismissMode = .none
        collectionView?.delaysContentTouches = false
        collectionView?.alwaysBounceVertical = true
        collectionView?.isPrefetchingEnabled = false
        
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(inputBarView)

        inputBarView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        inputBarView.heightAnchor.constraint(equalToConstant: self.inputBarHeight).isActive = true
        inputBarBottomAnchor = inputBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        inputBarBottomAnchor?.isActive = true
//
//
//
        collectionView!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView!.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        collectionView!.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        collectionView!.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -self.inputBarView.bounds.height).isActive = true
        
//        inputBarView.layout(.top, to: .bottom, of: inputBarView, offset: 5)
//        inputBarView.set(.height, of: 50.0)
//        inputBarView.layoutToSuperview(.left, offset: 0)
//        inputBarView.layoutToSuperview(.right, offset: 0)
//        inputBarView.layoutToSuperview(.bottom, offset: 0)
                                    
        
        collectionView?.register(IncomingTextMessageCell.self, forCellWithReuseIdentifier: incomingTextMessageCellID)
        collectionView?.register(OutgoingTextMessageCell.self, forCellWithReuseIdentifier: outgoingTextMessageCellID)
        
        collectionView.isScrollEnabled = true
        
        collectionView.delegate = self
    }
    
    func setupMessageSender() {
        guard msgSender == nil else { return }
        
        self.msgSender = MessageSender(chatID: self.chatID)
    }
    
    func setupMessageFetcher() {
        guard msgFetcher == nil else { return }
        
        self.msgFetcher = MessageFetcher(chatID: chatID)
        self.msgFetcher.delegate = self
    }
    
    
    
    //MARK: - Helper Methods
    
    func scrollToBottom(at position: UICollectionView.ScrollPosition, isAnimated : Bool) {
        guard let lastMsgGroup = msgArray.last else { return }
        
        let item = lastMsgGroup.count - 1
        let section = msgArray.count - 1
        
        if(section < 0 || item < 0) {
            return
        }
        
        let indexPath = IndexPath(item: item, section: section)
        
        DispatchQueue.main.async {
            self.collectionView?.scrollToItem(at: indexPath, at: position, animated: isAnimated)
        }
    }
    
}
