//
//  MusicInfoModel.h
//  AutoBot
//
//  Created by autobot on 16/3/8.
//  Copyright © 2016年 com.vgoapp.autobot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicInfoModel : NSObject
@property (nonatomic, copy)NSString *fileName;
@property (nonatomic, copy)NSString *songName;
@property (nonatomic, copy)NSString *songArtist;
@property (nonatomic, strong)NSURL *imageUrl;
@property (nonatomic, strong)NSURL *url;
- (instancetype)initWithfileName:(NSString *)fileName
                        songName:(NSString *)songName
                      songArtist:(NSString *)songArtist
                          urlStr:(NSURL *)url
                        imageUrl:(NSURL *)imageurl;


@end
