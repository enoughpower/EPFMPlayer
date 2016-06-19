//
//  BaseViewController.swift
//  duotingFM
//
//  Created by enoughpower on 16/6/16.
//  Copyright © 2016年 enoughpower. All rights reserved.
//

import UIKit
import AFNetworking


class BaseViewController: UIViewController {
    lazy var networkManager: AFNetworkReachabilityManager = {
        let manager = AFNetworkReachabilityManager.sharedManager()
        manager.startMonitoring()
        return manager
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.respondsToSelector(Selector("edgesForExtendedLayout")) {
            if let vc = self.navigationController?.visibleViewController {
                if vc.isKindOfClass(ContentViewController.self) || vc.isKindOfClass(MusicPlayViewController.self) {
                    self.edgesForExtendedLayout = UIRectEdge.All
                }else {
                    self.edgesForExtendedLayout = UIRectEdge.None
                }
            }else {
                self.edgesForExtendedLayout = UIRectEdge.None
            }
        }
        
        
 

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let color = UIColor(255, green: 100, blue: 78)
        self.navigationController!.navigationBar.cnSetBackgroundColor(color.colorWithAlphaComponent(1))
        self.navigationController!.navigationBar.shadowImage = UIImage()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
