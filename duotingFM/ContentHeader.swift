//
//  ContentHeader.swift
//  duotingFM
//
//  Created by enoughpower on 16/6/17.
//  Copyright © 2016年 enoughpower. All rights reserved.
//

import UIKit

class ContentHeader: UIView {
    private var sv: UIScrollView!
    private var effect: UIVisualEffectView!
    private var bgImageVIew: UIImageView!
    private var bgView: UIView!
    private var albumImageVIew: UIImageView!
    private var categoryLabel: UILabel!
    private var contectCountLabel: UILabel!
    private var playCountLabel: UILabel!
    private var updateDate: UILabel!
    private var userLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var dessv: UIScrollView!
    private var desbgView: UIView!
    var albumInfo: AlbumModel! {
        set(value) {
            let albumInfo = value
            var playCount: Double = Double(albumInfo.playCount)
            if (playCount > 11000) {
                playCount /= 10000;
                playCountLabel.text = String(format: "播放:%.2f万",playCount)
            }else {
                playCountLabel.text = String(format: "播放:%.f",playCount)
            }
            bgImageVIew.sd_setImageWithURL(NSURL.init(string: albumInfo.img))
            albumImageVIew.sd_setImageWithURL(NSURL.init(string: albumInfo.img))
            categoryLabel.text = String(format: "%@-%@",albumInfo.category,albumInfo.subCategory)
            contectCountLabel.text = String(format: "节目:%ld",albumInfo.contentCount)
            updateDate.text = String(format: "上次更新:\n%@",albumInfo.updateDate)
            userLabel.text = String(format: "主播:%@",albumInfo.user)
            
            let attribute: NSMutableAttributedString = NSMutableAttributedString(string: userLabel.text!)
            attribute.addAttribute(NSForegroundColorAttributeName, value: UIColor.orangeColor(), range: NSMakeRange(0, 2))
            self.userLabel.attributedText = attribute;
            self.descriptionLabel.text = albumInfo.Description;
        }
        get {
            return self.albumInfo
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        bgImageVIew.snp_remakeConstraints { (make) in
            make.edges.equalTo(self);
        }
        effect.snp_remakeConstraints { (make) in
            make.edges.equalTo(self);
        }
        sv.snp_remakeConstraints { (make) in
            make.edges.equalTo(self);
        }
        bgView.snp_remakeConstraints { (make) in
            make.edges.equalTo(sv);
            make.width.equalTo(self.bounds.size.width*2);
            make.height.equalTo(self.bounds.size.height);
        }
        albumImageVIew.snp_remakeConstraints { (make) in
            make.top.equalTo(bgView).offset(64);
            make.left.equalTo(bgView).offset(5);
            make.bottom.equalTo(userLabel.snp_top).offset(-10);
            let width = self.bounds.size.height;
            make.width.equalTo(width*4/6);
            //        make.width.equalTo(self.bounds.size.width*4/9);
        }
        categoryLabel.snp_remakeConstraints { (make) in
            make.left.equalTo(albumImageVIew.snp_right).offset(10);
            make.top.equalTo(albumImageVIew);
            make.width.equalTo(self.bounds.size.width*4/9);
        }
        contectCountLabel.snp_remakeConstraints { (make) in
            make.top.equalTo(categoryLabel.snp_bottom).offset(10);
            make.left.equalTo(categoryLabel);
        }
        playCountLabel.snp_remakeConstraints { (make) in
            make.top.equalTo(contectCountLabel.snp_bottom).offset(10);
            make.left.equalTo(categoryLabel);
        }
        updateDate.snp_remakeConstraints { (make) in
            make.top.equalTo(playCountLabel.snp_bottom).offset(10);
            make.left.equalTo(categoryLabel);
        }
        userLabel.snp_remakeConstraints { (make) in
            make.bottom.equalTo(self).offset(-10);
            make.left.equalTo(albumImageVIew).offset(10);
        }
        dessv.snp_remakeConstraints { (make) in
            make.right.equalTo(bgView.snp_right);
            make.top.equalTo(bgView).offset(64);
            make.width.equalTo(self.bounds.size.width);
            make.height.equalTo(self.bounds.size.height-64-20);
        }
        descriptionLabel.snp_remakeConstraints { (make) in
            make.top.equalTo(desbgView);
            make.left.equalTo(desbgView).offset(20)
            make.width.equalTo(self.bounds.size.width-40)
        }
        desbgView.snp_remakeConstraints { (make) in
            make.edges.equalTo(dessv);
            make.bottom.equalTo(descriptionLabel);
        }
    }
    
    func initUI() {
        bgImageVIew = UIImageView(frame: CGRectZero)
        bgImageVIew.contentMode = .ScaleAspectFill
        bgImageVIew.clipsToBounds = true
        self.addSubview(bgImageVIew)
        
        let beffect = UIBlurEffect(style: .Light)
        effect = UIVisualEffectView(frame: CGRectZero)
        effect.backgroundColor = UIColor(white: 0, alpha: 0.3)
        effect.effect = beffect
        effect.alpha = 1;
        bgImageVIew.addSubview(effect)
        
        sv = UIScrollView(frame: CGRectZero)
        sv.backgroundColor = UIColor.clearColor()
        sv.pagingEnabled = true
        sv.showsHorizontalScrollIndicator = false
        self.addSubview(sv)
        
        bgView = UIView(frame: CGRectZero)
        sv.addSubview(bgView)
        
        albumImageVIew = UIImageView(frame: CGRectZero)
        albumImageVIew.contentMode = .ScaleAspectFill
        albumImageVIew.clipsToBounds = true
        bgView.addSubview(albumImageVIew)
        
        categoryLabel = UILabel(frame: CGRectZero)
        categoryLabel.textColor = UIColor.whiteColor()
        categoryLabel.font = UIFont.systemFontOfSize(20)
        bgView.addSubview(categoryLabel)
        
        contectCountLabel = UILabel(frame: CGRectZero)
        contectCountLabel.textColor = UIColor.whiteColor()
        contectCountLabel.font = UIFont.systemFontOfSize(15)
        bgView.addSubview(contectCountLabel)
        
        playCountLabel = UILabel(frame: CGRectZero)
        playCountLabel.textColor = UIColor.whiteColor()
        playCountLabel.font = UIFont.systemFontOfSize(15)
        bgView.addSubview(playCountLabel)
        
        updateDate = UILabel(frame: CGRectZero)
        updateDate.textColor = UIColor.whiteColor()
        updateDate.font = UIFont.systemFontOfSize(15)
        updateDate.numberOfLines = 0;
        bgView.addSubview(updateDate)
        
        userLabel = UILabel(frame: CGRectZero)
        userLabel.textColor = UIColor.whiteColor()
        userLabel.font = UIFont.systemFontOfSize(20)
        bgView.addSubview(userLabel)
        
        dessv = UIScrollView(frame: CGRectZero)
        bgView.addSubview(dessv)
        desbgView = UIView(frame: CGRectZero)
        dessv.addSubview(desbgView)
        
        descriptionLabel = UILabel(frame: CGRectZero)
        descriptionLabel.textColor = UIColor.whiteColor()
        descriptionLabel.font = UIFont.systemFontOfSize(15)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.clipsToBounds = true
        desbgView.addSubview(descriptionLabel)
    }
}
