//
//  MusicInfoModel.m
//  AutoBot
//
//  Created by autobot on 16/3/8.
//  Copyright © 2016年 com.vgoapp.autobot. All rights reserved.
//

#import "MusicInfoModel.h"

@implementation MusicInfoModel
- (instancetype)initWithfileName:(NSString *)fileName
                        songName:(NSString *)songName
                      songArtist:(NSString *)songArtist
                          urlStr:(NSURL *)url
                        imageUrl:(NSURL *)imageurl;

{
    if (self = [super init]) {
        if (fileName) {
            _fileName = fileName;
        }else {
            _fileName = @"未知歌曲";
        }
        if (songName) {
            _songName = songName;
        }else {
            _songName = @"未知歌曲";
        }
        if (songArtist) {
            _songArtist = songArtist;
        }else {
            _songArtist = @"未知艺术家";
        }
        if (url) {
            _url = url;
        }
        if (imageurl) {
            _imageUrl = imageurl;
        }
    }
    return self;
}
@end
