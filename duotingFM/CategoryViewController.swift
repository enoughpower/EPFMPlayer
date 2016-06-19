//
//  CategoryViewController.swift
//  duotingFM
//
//  Created by enoughpower on 16/6/16.
//  Copyright © 2016年 enoughpower. All rights reserved.
//

import UIKit
class CategoryViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var mainView: CategoryView!
    lazy var listArray: [CategoryModel] = {
        return []
    }()
    override func loadView() {
        mainView = CategoryView.init(frame: UIScreen.mainScreen().bounds)
        self.view = mainView
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
    }
    func initUI() {
        self.mainView.collectionView.delegate = self
        self.mainView.collectionView.dataSource = self;
        self.mainView.collectionView.registerClass(CategoryViewCell.self, forCellWithReuseIdentifier: CategoryReuseIdentifier)
    }

    func initData() {
        NetKit.requestWithMainCategory { (success, dataArr) in
            if success {
                self.listArray = dataArr!
                dispatch_async(dispatch_get_main_queue(), {
                    self.mainView.collectionView.reloadData()
                })
            } else {
                print("无网络")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: -collectionViewDatasource
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CategoryReuseIdentifier, forIndexPath: indexPath) as! CategoryViewCell
        let model: CategoryModel = self.listArray[indexPath.row]
        cell.passInfo(model)
        return cell
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listArray.count
    }

    

}
