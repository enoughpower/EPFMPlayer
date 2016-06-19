//
//  LocalMusicPlayerTool.m
//  music
//
//  Created by autobot on 16/1/27.
//  Copyright © 2016年 autobot. All rights reserved.
//

#import "LocalMusicPlayerTool.h"
#import <SDWebImage/SDWebImageManager.h>
static LocalMusicPlayerTool * mp = nil;
@interface LocalMusicPlayerTool ()
@property (nonatomic,strong)NSTimer * timer;
@property (nonatomic, assign)BOOL isWait;
@end


@implementation LocalMusicPlayerTool
-(void)dealloc
{
    [_player removeObserver:self forKeyPath:@"rate"];
}


+(instancetype)shareMusicPlay
{
    if (mp == nil) {
        static dispatch_once_t token ;
        dispatch_once(&token, ^{
            mp = [[LocalMusicPlayerTool alloc]init];
        });
    }
    return mp;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _player = [[AVPlayer alloc] init];
        _currentItem = 0;
        _mode = 0;
        _currentMusicInfo = nil;
        [self setPlayingSession];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endOfPlay:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        [_player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

// 后台播放
- (void)setPlayingSession
{
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback withOptions:0 error:nil];
    [session setActive:YES error:nil];

    

}
// 关闭后台播放
- (void)endPlayingSession
{
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
}


-(void)endOfPlay:(NSNotification *)sender
{
    if (_mode == 1) {
        _currentItem = [self randomItem];
        [self musicPause];
        [self musicPrePlay];
    }else {
        [self next];
    }

}
// 准备播放
-(void)musicPrePlay
{
    if (self.player.currentItem != nil) {
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    }
    if (_MusicList.count > 0) {
        MusicInfoModel *info = _MusicList[_currentItem];
        NSURL *url = info.url;
        AVPlayerItem * item = [[AVPlayerItem alloc ]initWithURL:url];
        [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [self.player replaceCurrentItemWithPlayerItem:item];
    }
}

// 观察者的处理方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        switch ([[change valueForKey:@"new"] integerValue]) {
            case AVPlayerItemStatusUnknown:
                NSLog(@"log_no_know_error");
                break;
            case AVPlayerItemStatusFailed:
                NSLog(@"log_prepare_faild");
                break;
            case AVPlayerItemStatusReadyToPlay:
            {
                NSLog(@"log_prepare_success");
                self.currentMusicInfo = _MusicList[_currentItem];
                [self musicPlay];
                break;
        }
            default:
                break;
        }
    }
    if ([keyPath isEqualToString:@"rate"]) {
        if ([change[@"new"] floatValue] == 0) {
            if (self.isWait == YES) {
                self.playStatus = Wait;
            }else {
                self.playStatus = Stop;
            }
        }else {
            self.playStatus = Play;
        }
        if ([self.delegate respondsToSelector:@selector(musicDidChangePlayStatus:)]) {
            [self.delegate musicDidChangePlayStatus:_playStatus];
        }
        if ([self.twoDelegate respondsToSelector:@selector(musicDidChangePlayStatus:)]) {
            [self.twoDelegate musicDidChangePlayStatus:_playStatus];
        }
    }
}

// 开始播放
-(void)musicPlay
{
    if (self.timer != nil) {
        return;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:.5f target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    
    [self.player play];
    MusicInfoModel *info = _MusicList[_currentItem];
    if ([self.delegate respondsToSelector:@selector(musicDidChangeSong:musicInfo:)]) {
        [self.delegate musicDidChangeSong:_currentItem musicInfo:info];
    }
    if ([self.twoDelegate respondsToSelector:@selector(musicDidChangeSong:musicInfo:)]) {
        [self.twoDelegate musicDidChangeSong:_currentItem musicInfo:info];
    }
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:self.currentMusicInfo.imageUrl
                          options:0
                         progress:nil
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            if (image) {
                                self.currentImg = image;
                            }
                        }];
    
}

-(void)timerAction:(NSTimer *)sender
{
    MPMediaItemArtwork * mArt = [[MPMediaItemArtwork alloc] initWithImage:self.currentImg];
    NSDictionary *nowPlaying = @{MPMediaItemPropertyArtist: self.currentMusicInfo.songArtist,
                                 MPMediaItemPropertyTitle: self.currentMusicInfo.songName,
                                 MPMediaItemPropertyPlaybackDuration:@([self getTotleTime]),
                                 MPNowPlayingInfoPropertyElapsedPlaybackTime:@([self getCurTime]),
                                 MPMediaItemPropertyArtwork:mArt
                                 };
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:nowPlaying];
    if ([self.delegate respondsToSelector:@selector(musicCurrentTime:totle:progress:)]) {
        [self.delegate musicCurrentTime:[self intToString:[self getCurTime]] totle:[self intToString:[self getTotleTime]] progress:[self getProgress]];
    }
    if ([self.twoDelegate respondsToSelector:@selector(musicCurrentTime:totle:progress:)]) {
        [self.twoDelegate musicCurrentTime:[self intToString:[self getCurTime]] totle:[self intToString:[self getTotleTime]] progress:[self getProgress]];
    }
}

-(NSString * )intToString:(NSInteger)value
{
    return [NSString stringWithFormat:@"%.2ld:%.2ld",value/60, value%60];
}

// 暂停播放
-(void)musicPause
{
    [self.timer invalidate];
    self.timer = nil;
    [self.player pause];
    
}
// 暂停当前播放等待语音播放
- (void)musicWait
{
    self.isWait = YES;
    [self musicPause];
}
// 播放跳转
-(void)seekTotimeWithValue:(CGFloat)value;
{
    // 先暂停
    [self musicPause];
    
    // 跳转
    [self.player seekToTime:CMTimeMake(value * [self getTotleTime], 1) completionHandler:^(BOOL finished) {
        if (finished == YES) {
            [self musicPlay];
        }
    }];
}
// 上一曲
-(void)previous
{
    if (_mode == 1) {
        _currentItem = [self randomItem];
    }else {
        if (_currentItem == 0) {
            _currentItem = _MusicList.count -1;
        }else
        {
            _currentItem --;
        }
    }
    [self musicPause];
    [self musicPrePlay];
}
// 下一曲
- (void)next
{
    
    if (_mode == 1) {
        _currentItem = [self randomItem];
    }else {
        if (_currentItem == _MusicList.count -1) {
            _currentItem = 0;
        }else
        {
            _currentItem ++;
        }
    }
    [self musicPause];
    [self musicPrePlay];
    
}
// 选定曲目播放找不到返回NO
- (BOOL)playWithIndex:(NSInteger)item
{
    if (item >=_MusicList.count) {
        return NO;
    }else {
        _currentItem = item;
        [self musicPause];
        [self musicPrePlay];
        return YES;
    }
}



// 获取当前歌曲总时长
-(NSInteger)getTotleTime
{
    CMTime totleTime = [self.player.currentItem duration];
    if (totleTime.timescale == 0) {
        return 1;
    }else{
        return (NSInteger)(totleTime.value / totleTime.timescale);
    }
}

// 获取当前播放时间
-(NSInteger)getCurTime
{
    if (self.player.currentItem) {
        // 用value/scale,就是AVPlayer计算时间的算法. 它就是这么规定的.
        // 下同.
        return (NSInteger)(self.player.currentTime.value / self.player.currentTime.timescale);
    }
    return 0;
}

// 当前播放进度(0-1)
-(CGFloat)getProgress
{
    // 当前播放时间 / 播放总时间, 得到一个0-1的进度百分比即可.
    // 注意类型, 两个整型做除, 得到仍是整型. 所以要强转一下.
    return (CGFloat)[self getCurTime] / (CGFloat)[self getTotleTime];
}

- (NSUInteger)randomItem
{
    NSInteger item = _MusicList.count;
    NSInteger randomItem = arc4random()%item;
    return randomItem;
}




@end
