//
//  CategoryView.swift
//  duotingFM
//
//  Created by enoughpower on 16/6/17.
//  Copyright © 2016年 enoughpower. All rights reserved.
//

import UIKit

class CategoryView: UIView {
    lazy var collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake((self.frame.size.width-84)/3, (self.frame.size.width-84)/3 + 30)
        layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
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
        self.backgroundColor = UIColor(white: 0.9, alpha: 1)
        self.addSubview(self.collectionView)
        collectionView.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }

}
