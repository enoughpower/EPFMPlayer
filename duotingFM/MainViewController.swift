//
//  MainViewController.swift
//  duotingFM
//
//  Created by enoughpower on 16/6/16.
//  Copyright © 2016年 enoughpower. All rights reserved.
//

import UIKit


class MainViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var mainView: MainView!
    lazy var listArray: [AlbumModel] = {
        return []
    }()

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
        NetKit.requestWithMain(1) { (success, dataArr) in
            if success {
                //                for model:CategoryModel in dataArr! {
                //                    print(model.id)
                //                    print(model.image_url)
                //                    print(model.title)
                //                }
                self.listArray = dataArr!
                dispatch_async(dispatch_get_main_queue(), {
                    self.mainView.collectionView.reloadData()
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
