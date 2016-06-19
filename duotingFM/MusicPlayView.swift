//
//  MusicPlayView.swift
//  duotingFM
//
//  Created by enoughpower on 16/6/19.
//  Copyright © 2016年 enoughpower. All rights reserved.
//

import UIKit

@objc protocol MusicPlayViewDelegate: NSObjectProtocol {
    func musicPlayViewDidClickPlayButton(playButton: UIButton)
    func musicPlayViewDidClickPreviousButton(previousButton: UIButton)
    func musicPlayViewDidClickNextButton(nextButton: UIButton)
    func musicPlayViewDidClickListButton(listButton: UIButton)
    func musicPlayViewDidChangeProgress(progress: UISlider)
}

class MusicPlayView: UIView {
    var nameLabel: UILabel!
    var artistLabel: UILabel!
    var currentTimeLabel: UILabel!
    var totalTimeLabel: UILabel!
    var previousButton: UIButton!
    var nextButton: UIButton!
    var playButton: UIButton!
    var listButton: UIButton!
    var progressSlider: UISlider!
    var albumImage: UIImageView!
    var bgImage: UIImageView!
    weak var delegate: MusicPlayViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initUI() {
        bgImage = UIImageView(frame: CGRectZero)
        bgImage.contentMode = .ScaleAspectFill;
        bgImage.clipsToBounds = true;
        self.addSubview(bgImage)
        
        let blur = UIBlurEffect(style: .Light)
        
        let bgView = UIVisualEffectView(effect: blur)
        bgView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        bgView.frame = CGRectZero;
        bgImage.addSubview(bgView)
        
        let albumBg = UIVisualEffectView(effect: blur)
        albumBg.frame = CGRectZero;
        albumBg.alpha = 0.5;
        albumBg.layer.masksToBounds = true;
        albumBg.layer.cornerRadius = (self.frame.size.width - 55) / 2;
        self.addSubview(albumBg)
        
        albumImage = UIImageView(frame: CGRectZero)
        albumImage.layer.masksToBounds = true;
        albumImage.contentMode = .ScaleAspectFill;
        albumImage.layer.cornerRadius = (self.frame.size.width - 75) / 2;
        self.addSubview(albumImage)
        
        nameLabel = UILabel(frame: CGRectZero)
        nameLabel.textColor = UIColor.whiteColor();
        nameLabel.font = UIFont.systemFontOfSize(18)
        nameLabel.numberOfLines = 0;
        nameLabel.textAlignment = .Center;
        self.addSubview(nameLabel)
        
        artistLabel = UILabel(frame: CGRectZero)
        artistLabel.textColor = UIColor.whiteColor()
        artistLabel.font = UIFont.systemFontOfSize(12)
        artistLabel.textAlignment = .Center;
        self.addSubview(artistLabel)
        
        currentTimeLabel = UILabel(frame: CGRectZero)
        currentTimeLabel.textColor = UIColor.whiteColor()
        currentTimeLabel.font = UIFont.systemFontOfSize(12)
        currentTimeLabel.text = "00:00";
        currentTimeLabel.textAlignment = .Right;
        self.addSubview(currentTimeLabel)
        
        progressSlider = UISlider(frame: CGRectZero)
        progressSlider.minimumTrackTintColor = UIColor(0, green: 184, blue: 235)
        progressSlider.maximumTrackTintColor = UIColor(white: 0.5, alpha: 1)
        progressSlider.setThumbImage(UIImage.init(named: "ic_drving_music_handle"), forState:.Normal)
        progressSlider.addTarget(self, action: #selector(MusicPlayView.progressChanged(_:)), forControlEvents: .TouchUpInside)
        self.addSubview(progressSlider)
        
        totalTimeLabel = UILabel(frame: CGRectZero)
        totalTimeLabel.textColor = UIColor.whiteColor()
        totalTimeLabel.font = UIFont.systemFontOfSize(12)
        totalTimeLabel.text = "00:00";
        self.addSubview(totalTimeLabel)
        
        playButton = UIButton(type: .Custom)
        playButton.setBackgroundImage(UIImage(named: "iconfont-kaishi"), forState:.Normal)
        playButton.setBackgroundImage(UIImage(named: "iconfont-bofangqizanting"), forState: .Selected)
        playButton.addTarget(self, action: #selector(MusicPlayView.playAction(_:)), forControlEvents: .TouchUpInside)
        self.addSubview(playButton)
        
        previousButton = UIButton(type: .Custom)
        previousButton.setImage(UIImage(named:"iconfont-zhutishangyiqu"), forState:.Normal)
        previousButton.addTarget(self,action:#selector(MusicPlayView.previousAction(_:)), forControlEvents:.TouchUpInside)
        self.addSubview(previousButton)
        
        nextButton = UIButton(type: .Custom)
        nextButton.setImage(UIImage(named:"iconfont-zhutixiayiqu"), forState:.Normal)
        nextButton.addTarget(self, action:#selector(MusicPlayView.nextAction(_:)), forControlEvents:.TouchUpInside)
        self.addSubview(nextButton)
        
        bgImage.snp_makeConstraints { (make) in
        make.edges.equalTo(self);
        }
        bgView.snp_makeConstraints { (make) in
        make.edges.equalTo(bgImage);
        }
        albumBg.snp_makeConstraints { (make) in
        make.left.equalTo(self).offset(55/2);
        make.width.height.equalTo(self.frame.size.width - 55);
        make.top.equalTo(self).offset(94);
        }
        albumImage.snp_makeConstraints { (make) in
        make.left.equalTo(self).offset(75/2);
        make.width.height.equalTo(self.frame.size.width - 75);
        make.centerY.equalTo(albumBg);
        }
        nameLabel.snp_makeConstraints { (make) in
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(albumBg.snp_bottom).offset(20);
        }
        artistLabel.snp_makeConstraints { (make) in
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(nameLabel.snp_bottom).offset(5);
        }
        
        progressSlider.snp_makeConstraints { (make) in
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-90);
        make.width.equalTo(self.frame.size.width-120);
        make.height.equalTo(44);
        }
        currentTimeLabel.snp_makeConstraints { (make) in
        make.right.equalTo(progressSlider.snp_left).offset(-5);
        make.width.equalTo(50);
        make.centerY.equalTo(progressSlider);
        }
        totalTimeLabel.snp_makeConstraints { (make) in
        make.centerY.equalTo(progressSlider);
        make.width.equalTo(50);
        make.left.equalTo(progressSlider.snp_right).offset(5);
        }
        playButton.snp_makeConstraints { (make) in
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-20);
        make.width.equalTo(80);
        make.height.equalTo(80);
        }
        previousButton.snp_makeConstraints { (make) in
        make.centerY.equalTo(playButton);
        make.right.equalTo(playButton.snp_left).offset(-30);
        }
        nextButton.snp_makeConstraints { (make) in
        make.centerY.equalTo(playButton);
        make.left.equalTo(playButton.snp_right).offset(30);
        }
    }
    
    func playAction(sender: UIButton) {
        if self.delegate!.respondsToSelector(#selector(MusicPlayViewDelegate.musicPlayViewDidClickPlayButton(_:))) {
            self.delegate?.musicPlayViewDidClickPlayButton(sender)
        }
    }
    func previousAction(sender: UIButton) {
        if self.delegate!.respondsToSelector(#selector(MusicPlayViewDelegate.musicPlayViewDidClickPreviousButton(_:))) {
            self.delegate?.musicPlayViewDidClickPreviousButton(sender)
        }
    }
    func nextAction(sender: UIButton) {
        if self.delegate!.respondsToSelector(#selector(MusicPlayViewDelegate.musicPlayViewDidClickNextButton(_:))) {
            self.delegate?.musicPlayViewDidClickNextButton(sender)
        }
    }
    func listAction(sender: UIButton) {
        if self.delegate!.respondsToSelector(#selector(MusicPlayViewDelegate.musicPlayViewDidClickListButton(_:))) {
            self.delegate?.musicPlayViewDidClickListButton(sender)
        }
    }
    func progressChanged(sender: UISlider) {
        if self.delegate!.respondsToSelector(#selector(MusicPlayViewDelegate.musicPlayViewDidChangeProgress(_:))) {
            self.delegate?.musicPlayViewDidChangeProgress(sender)
        }
    }
    
}
