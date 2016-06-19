//
//  ContentCell.swift
//  duotingFM
//
//  Created by enoughpower on 16/6/18.
//  Copyright © 2016年 enoughpower. All rights reserved.
//

import UIKit

class ContentCell: UITableViewCell {
    private var nameLabel: UILabel!
    private var playCount: UILabel!
    private var duration: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initUI()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI() {
        nameLabel = UILabel(frame: CGRectZero)
        nameLabel.textColor = UIColor.blackColor()
        nameLabel.font = UIFont.systemFontOfSize(16)
        nameLabel.numberOfLines = 0;
        self.contentView.addSubview(nameLabel)
        
        playCount = UILabel(frame: CGRectZero)
        playCount.textColor = UIColor.grayColor()
        playCount.font = UIFont.systemFontOfSize(10)
        self.contentView.addSubview(playCount)
        
        duration = UILabel(frame: CGRectZero)
        duration.textColor = UIColor.grayColor()
        duration.font = UIFont.systemFontOfSize(10)
        self.contentView.addSubview(duration)
        
        let line = UIView(frame: CGRectZero)
        line.backgroundColor = UIColor.lightGrayColor()
        line.alpha = 0.4;
        self.contentView.addSubview(line)
        
        nameLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(20);
            make.top.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-20);
        }
        playCount.snp_makeConstraints { (make) in
            make.left.equalTo(nameLabel);
            make.top.equalTo(nameLabel.snp_bottom).offset(10);
        }
        duration.snp_makeConstraints { (make) in
            make.left.equalTo(nameLabel).offset(100);
            make.top.equalTo(nameLabel.snp_bottom).offset(10);
        }
        line.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView).offset(-20);
            make.height.equalTo(1);
            make.top.equalTo(duration.snp_bottom).offset(10);
            make.bottom.equalTo(self.contentView);
            }
    }
    
    func passInfo(info: ContentModel) {
        nameLabel.text = info.name;
        var playCount: Double = Double(info.playCount)
        if (playCount > 11000) {
            playCount /= 10000;
            self.playCount.text = String(format: "播放:%.2f万",playCount)
        }else {
            self.playCount.text = String(format: "播放:%.f",playCount)
        }
        let duration: Int = info.duration
        var hour = 0;
        var mins = 0;
        var sec = 0;
        if (duration >= 3600) {
            hour = duration/3600;
            mins = (duration % 3600) / 60;
            sec =  (duration % 3600) % 60;
        }else if (duration >= 60 && duration < 3600) {
            mins = duration / 60;
            sec =  duration % 60;
        }else {
            sec = duration;
        }
        self.duration.text = String(format: "%02ld:%02ld:%02ld",hour,mins,sec)
        nameLabel.sizeToFit()
    }
    func setColor() {
        nameLabel.textColor = UIColor.orangeColor()

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if (selected) {
            nameLabel.textColor = UIColor.orangeColor()
        }else {
            nameLabel.textColor = UIColor.blackColor()
        }
    }

}
