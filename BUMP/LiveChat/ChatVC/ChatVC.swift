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

class ChatVC: SwipeRightToPopCVC, UIGestureRecognizerDelegate, SPStorkControllerDelegate {
    
    
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
    var chatFollower : ChatFollower!
    
    var msgArray : [[Message]] = [] // Each item is Msg Group Array.
    
    var chatID : String = "Error Club"
    var chatName : String = "Error Club"
    var circleID : String = "Error Club"
    var circleName : String = "Error Club"
    var circleEmoji : String = "🤙"
    
    let navBarHeight : CGFloat = 44.0
    lazy var navBar: UINavigationBar = UINavigationBar()
    
    let subNavBarHeight : CGFloat = 34.0 //0.092 * self.view.bounds.width //36.0
    lazy var subNavBar : UIView = UIView()
    
    lazy var followChatButton : UIButton = {
        
        //FIX: when F chec, make go to the left. align to the left
        
        let button = UIButton()
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
        self.setupChatFollower()

        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.updateFeedMsgsRead()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.updateFeedMsgsRead()
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.shutDown()
    }
    
    func updateFeedMsgsRead() {
        //FIX: what other progression
        CircleManager.shared.updateFeedRead(chatID: chatID)
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
        
        self.collectionView.register(IncomingTextMessageCell.self, forCellWithReuseIdentifier: incomingTextMessageCellID)
        self.collectionView!.register(OutgoingTextMessageCell.self, forCellWithReuseIdentifier: outgoingTextMessageCellID)
        
        let tapG = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
        collectionView.addGestureRecognizer(tapG)
        tapG.delegate = self
        
        self.edgesForExtendedLayout = []
        view.backgroundColor = UIColor.white
        collectionView?.indicatorStyle = .default
        collectionView?.backgroundColor = view.backgroundColor
        collectionView?.contentInset = UIEdgeInsets(top: navBarHeight+subNavBarHeight+10, left: 0, bottom: 10, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: navBarHeight+subNavBarHeight, left: 0, bottom: 0, right: 0)
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
