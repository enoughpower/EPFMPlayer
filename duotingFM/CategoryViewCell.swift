//
//  CategoryViewCell.swift
//  duotingFM
//
//  Created by enoughpower on 16/6/17.
//  Copyright © 2016年 enoughpower. All rights reserved.
//

import UIKit

class CategoryViewCell: UICollectionViewCell {
    var bgView: UIView!
    var titleLabel: UILabel!
    var imageView: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initUI() {
        self.backgroundColor = UIColor(white: 0.9, alpha: 1)
        bgView = UIView.init(frame: CGRectZero)
        bgView.backgroundColor = UIColor.whiteColor()
        bgView.layer.masksToBounds = true
        bgView.layer.cornerRadius = self.contentView.bounds.size.width / 2
        self.contentView.addSubview(bgView)
        
        titleLabel = UILabel.init(frame: CGRectZero)
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.font = UIFont.systemFontOfSize(20)
        titleLabel.textColor = UIColor(white: 0.1, alpha: 1)
        titleLabel.textAlignment = .Center
        self.contentView.addSubview(titleLabel)
        
        imageView = UIImageView(frame: CGRectZero)
        self.contentView.addSubview(imageView)
        
        bgView.snp_makeConstraints { (make) in
            make.left.top.right.equalTo(self.contentView)
            make.height.equalTo(bgView.snp_width)
        }
        titleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(bgView.snp_bottom).offset(10)
            make.width.right.bottom.equalTo(self.contentView)
        }
        imageView.snp_makeConstraints { (make) in
            make.center.equalTo(bgView)
            make.width.height.equalTo(self.contentView.bounds.size.width - 20)
        }
    }
    
    func passInfo(info: CategoryModel) {
        imageView.sd_setImageWithURL(NSURL.init(string: info.image_url))
        titleLabel.text = info.title
    }
}
