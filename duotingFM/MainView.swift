//
//  MainView.swift
//  duotingFM
//
//  Created by enoughpower on 16/6/16.
//  Copyright © 2016年 enoughpower. All rights reserved.
//

import UIKit
import SnapKit

class MainView: UIView {
    lazy var collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake((self.frame.size.width-44)/3, (self.frame.size.width-44)/3 + 30)
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .Vertical
        var collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clearColor()
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initUI() {
        self.addSubview(self.collectionView)
        collectionView.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
}
