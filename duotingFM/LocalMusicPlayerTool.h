//
//  LocalMusicPlayerTool.h
//  music
//
//  Created by autobot on 16/1/27.
//  Copyright © 2016年 autobot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MusicInfoModel.h"

typedef NS_OPTIONS(NSInteger, PlayStatus)
{
    Stop = 0,
    Play,
    Wait
};

@protocol LocalMusicPlayerToolDelegate <NSObject>
@optional
// 播放进度
- (void)musicCurrentTime:(NSString *)curTime totle:(NSString *)totle progress:(CGFloat)progress;
// 换到下一首歌
- (void)musicDidChangeSong:(NSInteger)itemIndex musicInfo:(MusicInfoModel *)info;
- (void)musicDidChangePlayStatus:(PlayStatus)playStatus;
@end

@interface LocalMusicPlayerTool : NSObject
@property(nonatomic,strong)AVPlayer * player;
// 播放列表信息，数组里面存放若干个MusicInfoModel对象
@property(nonatomic, strong)NSArray *MusicList;
@property(nonatomic, assign)NSInteger currentItem;
@property(nonatomic, strong)MusicInfoModel *currentMusicInfo;
@property(nonatomic,assign)id delegate;
@property(nonatomic,assign)id twoDelegate;
//  0代表顺序循环  1代表随机
@property(nonatomic,assign)NSInteger mode;
// 当前歌曲专辑图片
@property(nonatomic, strong)UIImage *currentImg;
@property (nonatomic, assign)PlayStatus playStatus;
// 构造方法
+(instancetype)shareMusicPlay;
// 准备播放，准备完毕自动播放
-(void)musicPrePlay;
// 恢复播放(用于恢复暂停播放)
-(void)musicPlay;
// 暂停播放
-(void)musicPause;
// 暂停当前播放等待语音播放
- (void)musicWait;
// 跳转播放进度
-(void)seekTotimeWithValue:(CGFloat)value;
// 上一曲
-(void)previous;
// 下一曲
- (void)next;
// 选定曲目播放找不到返回NO
- (BOOL)playWithIndex:(NSInteger)item;



@end
