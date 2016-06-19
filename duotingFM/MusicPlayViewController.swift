//
//  MusicPlayViewController.swift
//  duotingFM
//
//  Created by enoughpower on 16/6/19.
//  Copyright © 2016年 enoughpower. All rights reserved.
//

import UIKit

class MusicPlayViewController: BaseViewController, MusicPlayViewDelegate, LocalMusicPlayerToolDelegate {
    private var playView: MusicPlayView!
    private var musicManager: LocalMusicPlayerTool! = {
        return LocalMusicPlayerTool.shareMusicPlay()
    }()
    private  lazy var dataArray: [MusicInfoModel] = {
        return []
    }()
    private var currentIndex: Int = 0
    
    deinit {
        self.musicManager.delegate = nil
    }
    
    override func loadView() {
        self.playView = MusicPlayView(frame: UIScreen.mainScreen().bounds)
        self.playView.delegate = self
        self.view = playView
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        app.bottonBar.hidden = true
        let color = UIColor(255, green: 100, blue: 78)
        self.navigationController!.navigationBar.cnSetBackgroundColor(color.colorWithAlphaComponent(0))

    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        app.bottonBar.hidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.musicManager.delegate = self
        if let arr = self.musicManager.MusicList as? [MusicInfoModel] {
            self.dataArray += arr
        }
        self.currentIndex = self.musicManager.currentItem
        if (self.dataArray.count > 0) {
            if (self.musicManager.player.rate != 0) {
                playView.playButton.selected = true;
            }
            let info = self.dataArray[self.currentIndex];
            playView.nameLabel.text = info.songName;
            playView.artistLabel.text = info.songArtist;
            playView.albumImage.sd_setImageWithURL(info.imageUrl)
            playView.bgImage.sd_setImageWithURL(info.imageUrl)
        }
        // Do any additional setup after loading the view.
    }
    func startPlayingSong() {
        if (self.currentIndex == self.musicManager.currentItem){
            if (self.musicManager.player.rate == 0) {
                if (self.musicManager.currentMusicInfo != nil) {
                    self.musicManager.musicPause()
                    self.musicManager.musicPlay()
                }else {
                    self.musicManager.playWithIndex(self.currentIndex)
                }
            }else {
                
            }
        }
        self.musicManager.playWithIndex(self.currentIndex)
    }
    //MARK: - playViewDelegate
    func musicPlayViewDidClickPlayButton(playButton: UIButton) {
        if (self.dataArray.count>0) {
            if (self.musicManager.player.rate != 0) {
                self.musicManager.musicPause()
            }else{
                self.startPlayingSong()
            }
        }
    }
    func musicPlayViewDidClickNextButton(nextButton: UIButton) {
        if (self.dataArray.count>0) {
            self.musicManager.next()
        }
    }
    func musicPlayViewDidClickPreviousButton(previousButton: UIButton) {
        if (self.dataArray.count>0) {
            self.musicManager.previous()
        }
    }
    func musicPlayViewDidChangeProgress(progress: UISlider) {
        self.musicManager.seekTotimeWithValue(CGFloat(progress.value))
    }
    func musicPlayViewDidClickListButton(listButton: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)

    }
    
    //MARK: - musicManagerDelegate
    func musicCurrentTime(curTime: String!, totle: String!, progress: CGFloat) {
        playView.progressSlider.value = Float(progress);
        playView.currentTimeLabel.text = curTime;
        playView.totalTimeLabel.text = totle;
        UIView.animateWithDuration(0.5, delay: 0, options: .CurveLinear, animations: {
            self.playView.albumImage.transform = CGAffineTransformRotate(self.playView.albumImage.transform, M_PI/20);
            }, completion: nil)
    }
    func musicDidChangePlayStatus(playStatus: PlayStatus) {
        if playStatus == .Play {
            self.playView.playButton.selected = true;
        }else {
            self.playView.playButton.selected = false;
        }
    }
    func musicDidChangeSong(itemIndex: Int, musicInfo info: MusicInfoModel!) {
        self.currentIndex = itemIndex;
        playView.nameLabel.text = info.songName;
        playView.artistLabel.text = info.songArtist;
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
