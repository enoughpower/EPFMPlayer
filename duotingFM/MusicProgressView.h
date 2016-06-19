//
//  MusicProgressView.h
//  AutoBot
//
//  Created by autobot on 16/3/9.
//  Copyright © 2016年 com.vgoapp.autobot. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MusicProgressView;
@protocol MusicProgressViewDelegate <NSObject>

- (void)MusicProgressViewDidClickButton:(UIButton *)playButton;

@end

@interface MusicProgressView : UIView
@property (nonatomic, assign)CGFloat progress;
@property (nonatomic, strong)UIButton *playStatusButon;
@property (nonatomic, weak)id<MusicProgressViewDelegate>delegate;
@end
