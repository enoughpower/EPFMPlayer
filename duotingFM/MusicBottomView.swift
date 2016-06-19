//
//  MusicBottomView.swift
//  duotingFM
//
//  Created by enoughpower on 16/6/18.
//  Copyright © 2016年 enoughpower. All rights reserved.
//

import UIKit

class MusicBottomView: UIView, MusicProgressViewDelegate, LocalMusicPlayerToolDelegate {
    var progressView: MusicProgressView!
    var nameLabel: UILabel!
    var bottomBar: UIVisualEffectView!
    var nextButton: UIButton!
    
    lazy var musicManager: LocalMusicPlayerTool! = {
        let manager = LocalMusicPlayerTool.shareMusicPlay()
        return manager
    }()
    var songsItem: NSInteger! = 0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        self.musicManager.twoDelegate = self

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initUI() {
         let beffect = UIBlurEffect(style: .Light)
        bottomBar = UIVisualEffectView(frame: CGRectZero)
        bottomBar.backgroundColor = UIColor(255, green: 255, blue: 255, alpha: Int(255*0.5))
        bottomBar.effect = beffect
        bottomBar.alpha = 1;
        self.addSubview(bottomBar)
        let tap = UITapGestureRecognizer(target: self, action: #selector(MusicBottomView.bottomAction(_:)))
        bottomBar.addGestureRecognizer(tap)
        
        progressView = MusicProgressView(frame: CGRectZero)
        progressView.delegate = self;
        bottomBar.addSubview(progressView)
        
        nameLabel = UILabel(frame: CGRectZero)
        nameLabel.textColor = UIColor(72, green: 96, blue: 109)
        nameLabel.font = UIFont.systemFontOfSize(15)
        nameLabel.lineBreakMode = .ByClipping;
        bottomBar.addSubview(nameLabel)
        
        nextButton = UIButton(type: .Custom)
        nextButton.setImage(UIImage(named: "btn_music_list_next"), forState: .Normal)
        nextButton.setImage(UIImage(named: "btn_music_list_next_pressed"), forState: .Highlighted)
        nextButton.addTarget(self, action: #selector(MusicBottomView.nextAction(_:)), forControlEvents: .TouchUpInside)
        bottomBar.addSubview(nextButton)
        
        bottomBar.snp_makeConstraints { (make) in
            make.bottom.equalTo(self);
            make.left.right.equalTo(self);
            make.height.equalTo(60);
        }
        progressView.snp_makeConstraints { (make) in
            make.centerY.equalTo(bottomBar);
            make.left.equalTo(bottomBar).offset(17);
            make.width.height.equalTo(40);
        }
        nextButton.snp_makeConstraints { (make) in
            make.right.equalTo(bottomBar).offset(-25);
            make.centerY.equalTo(bottomBar);
            make.width.height.equalTo(28);
        }
        nameLabel.snp_makeConstraints { (make) in
            make.centerY.equalTo(bottomBar);
            make.left.equalTo(progressView.snp_right).offset(20);
            make.right.equalTo(nextButton.snp_left).offset(-16);
        }
    }
    //MARK: - method
    // 开始播放
    func startPlayingSong() {
        if (self.songsItem == self.musicManager.currentItem){
            if (self.musicManager.player.rate == 0) {
                if (self.musicManager.currentMusicInfo != nil) {
                    self.musicManager.musicPause()
                     self.musicManager.musicPlay()
                }else {
                    self.musicManager.playWithIndex(self.songsItem)
                }
            }else {
                
            }
        }
        self.musicManager.playWithIndex(self.songsItem)
    }
    // MARK: - action
    func bottomAction(tapGestureRecognizer: UITapGestureRecognizer) {
        
    }
    func nextAction(sender: UIButton) {
        self.musicManager.next()
    }
    // MARK: - progressViewDelegate
    func MusicProgressViewDidClickButton(playButton: UIButton!) {
        if (self.musicManager.player.rate != 0) {
            self.musicManager.musicPause()
        }else{
            self.startPlayingSong()
        }
    }
    // MARK: - musicManagerDelegate
    func musicCurrentTime(curTime: String!, totle totleTime: String!, progress: CGFloat) {
        dispatch_async(dispatch_get_main_queue()) { 
            self.progressView.progress = progress
        }

    }
    func musicDidChangePlayStatus(playStatus: PlayStatus) {
        dispatch_async(dispatch_get_main_queue()) {
            if playStatus == .Play {
                self.progressView.playStatusButon.selected = true
            }else {
                self.progressView.playStatusButon.selected = false
            }
        }
    }
    func musicDidChangeSong(itemIndex: Int, musicInfo info: MusicInfoModel!) {
        dispatch_async(dispatch_get_main_queue()) {
        self.songsItem = itemIndex;
        self.nameLabel.text = info.songName;
        }
    }
}








