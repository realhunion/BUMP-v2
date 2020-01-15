//
//  FeedTabVC.swift
//  BUMP
//
//  Created by Hunain Ali on 1/11/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import UIKit
import Tabman
import Pageboy

class FeedTabVC: TabmanViewController {
    
    
    var feedFetcher : FeedFetcher?
    
    
    var viewControllers = [FeedTVC(), FeedTVC(), FeedTVC()]
    var viewControllerNames = ["Following", "My Circles" ,"Campus"]
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.addStatusBarView()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.removeStatusBarView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.setupFeedTab()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabBar()
        
        self.setupFeedFetcher()
    }
    
    
    
    
    
    
    
    //MARK: - Status Bar
    
    lazy var statusBarView : UIView = {
        var v = UIView()
        v.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0)
        return v
    }()
    
    func addStatusBarView() {
        if #available(iOS 13, *)
        {
            self.statusBarView.frame = UIApplication.shared.statusBarFrame
            UIApplication.shared.keyWindow?.addSubview(self.statusBarView)
        } else {
            // ADD THE STATUS BAR AND SET A CUSTOM COLOR
            let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
            if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
                statusBar.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0)
            }
        }
    }
    func removeStatusBarView() {
        if #available(iOS 13, *)
        {
            self.statusBarView.removeFromSuperview()
        } else {
            // ADD THE STATUS BAR AND SET A CUSTOM COLOR
            let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
            if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
                statusBar.backgroundColor = UIColor.clear
            }
        }
    }
    
    
    //MARK: - Set up
    
    func setupFeedTab() {
        self.navigationController?.navigationBar.isHidden = true
        
        for v in viewControllers {
            let _ = v.tableView
        }
    }
    
    func setupTabBar() {
        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        
        bar.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0)
        bar.layout.contentMode = .fit
        bar.layout.transitionStyle = .progressive
        
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 10.0, bottom: 0, right: 10.0)
        
        bar.indicator.overscrollBehavior = .bounce
        bar.indicator.weight = .custom(value: 3.0)
        
        bar.buttons.customize { (button) in
            button.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .callout).pointSize, weight: .semibold)
            button.selectedFont = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .callout).pointSize, weight: .semibold)
            button.tintColor = UIColor.darkGray
            button.selectedTintColor = UIColor.systemBlue
        }
        
        self.addBar(bar, dataSource: self, at: .top)
    }
}


extension FeedTabVC: PageboyViewControllerDataSource, TMBarDataSource {
    
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let name = viewControllerNames[index]
        let item = TMBarItem(title: name)
        return item
    }
    
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .at(index: .init(bitPattern: 1))
    }
    
    func barItem(for tabViewController: TabmanViewController, at index: Int) -> TMBarItemable {
        let title = "Page \(index)"
        return TMBarItem(title: title)
    }
}




