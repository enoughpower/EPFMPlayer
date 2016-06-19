//
//  MainViewController.swift
//  duotingFM
//
//  Created by enoughpower on 16/6/16.
//  Copyright © 2016年 enoughpower. All rights reserved.
//

import UIKit
import MJRefresh

class MainViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private var mainView: MainView!
    private lazy var listArray: [AlbumModel] = {
        return []
    }()
    private var currentPage: Int = 1

    override func loadView() {
        mainView = MainView.init(frame: UIScreen.mainScreen().bounds)
        self.view = mainView
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
        // Do any additional setup after loading the view.
    }
    func initUI() {
        self.mainView.collectionView.delegate = self
        self.mainView.collectionView.dataSource = self;
        self.mainView.collectionView.registerClass(MainViewCell.self, forCellWithReuseIdentifier: MainReuseIdentifier)
    }
    func initData() {
        self.networkManager.setReachabilityStatusChangeBlock { [unowned self] (status) in
            switch(status) {
            case .NotReachable, .Unknown:
                print("无网络")
                let alert = UIAlertController(title: "提示", message: "请检查网络是否连接", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "我知道了", style: .Cancel, handler: { (action) in
                    
                }))
                self.presentViewController(alert, animated: true, completion: nil)
            case .ReachableViaWiFi, .ReachableViaWWAN:
                print("有网络")
                let mjrefresh = MJRefreshAutoNormalFooter(refreshingBlock: { 
                    self.currentPage += 1
                    self.loadDataWithIndex(index: self.currentPage)
                })
                self.mainView.collectionView.mj_footer = mjrefresh;
                self.loadDataWithIndex(index: self.currentPage)
            }
        }
    }

    func loadDataWithIndex(index index: Int) {
        NetKit.requestWithMain(index) { (success, dataArr) in
            if success {
                self.listArray += dataArr!
                dispatch_async(dispatch_get_main_queue(), {
                    self.mainView.collectionView.reloadData()
                    self.mainView.collectionView.mj_footer.endRefreshing()
                })
            } else {
                print("无网络")
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MainReuseIdentifier, forIndexPath: indexPath) as! MainViewCell
        let model: AlbumModel = self.listArray[indexPath.row]
        cell.passInfo(model)
        return cell
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listArray.count
    }
    // MARK: -collectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        let info = listArray[indexPath.item];
        let contentVC = ContentViewController()
        contentVC.albuminfo = info;
        self.navigationController?.pushViewController(contentVC, animated: true)
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
