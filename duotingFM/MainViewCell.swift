//
//  MainViewCell.swift
//  duotingFM
//
//  Created by enoughpower on 16/6/17.
//  Copyright © 2016年 enoughpower. All rights reserved.
//

import UIKit

class MainViewCell: UICollectionViewCell {
    var titleLabel: UILabel!
    var imageView: UIImageView!
    var playCountLabel: UILabel!
    var playNumLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initUI() {
        self.backgroundColor = UIColor(white: 0.9, alpha: 1)
        
        imageView = UIImageView(frame: CGRectZero)
        imageView.clipsToBounds = true
        imageView.contentMode = .ScaleAspectFill
        self.contentView.addSubview(imageView)
        
        titleLabel = UILabel.init(frame: CGRectZero)
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.font = UIFont.systemFontOfSize(12)
        titleLabel.textColor = UIColor(white: 0.1, alpha: 1)
        titleLabel.textAlignment = .Center
        self.contentView.addSubview(titleLabel)
        
        playCountLabel = UILabel(frame: CGRectZero)
        playCountLabel.font = UIFont.systemFontOfSize(9)
        playCountLabel.textColor = UIColor(white: 0.2, alpha: 1)
        playCountLabel.textAlignment = .Left
        self.contentView.addSubview(playCountLabel)
        
        playNumLabel = UILabel(frame: CGRectZero)
        playNumLabel.font = UIFont.systemFontOfSize(9)
        playNumLabel.textColor = UIColor(white: 0.2, alpha: 1)
        playNumLabel.textAlignment = .Right
        self.contentView.addSubview(playNumLabel)

        imageView.snp_makeConstraints { (make) in
            make.top.left.right.equalTo(self.contentView)
            make.height.equalTo(self.contentView.snp_width)
        }
        titleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(imageView.snp_bottom)
            make.left.right.equalTo(self.contentView)
            make.height.equalTo(20)
        }
        playCountLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView)
            make.top.equalTo(titleLabel.snp_bottom)
            make.bottom.equalTo(self.contentView)
            make.width.equalTo(self.contentView.bounds.size.width * 6/10)
        }
        playNumLabel.snp_makeConstraints { (make) in
            make.right.equalTo(self.contentView)
            make.top.equalTo(titleLabel.snp_bottom)
            make.bottom.equalTo(self.contentView)
            make.width.equalTo(self.contentView.bounds.size.width * 4/10)
        }
    }
    func passInfo(info: AlbumModel) {
        imageView.sd_setImageWithURL(NSURL.init(string: info.img))
        titleLabel.text = info.name
        let playCount: Double = Double(info.playCount)
        playCountLabel.text = String(format: "播放:%.1f万", playCount / 10000)
        playNumLabel.text = "节目:\(info.contentCount)"
    }
}
