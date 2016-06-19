//
//  MusicProgressView.m
//  AutoBot
//
//  Created by autobot on 16/3/9.
//  Copyright © 2016年 com.vgoapp.autobot. All rights reserved.
//

#import "MusicProgressView.h"
#import "UIColor+InnerBand.h"
@interface MusicProgressView()
@property (nonatomic,assign)CGFloat centerX;
@property (nonatomic, assign)CGFloat centerY;
@property (nonatomic, assign)CGFloat radius;
@property (nonatomic, assign)CGFloat lineWidth;
@end

@implementation MusicProgressView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.backgroundColor = [UIColor clearColor];
    _playStatusButon = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playStatusButon setImage:[UIImage imageNamed:@"btn_music_list_play"] forState:UIControlStateNormal];
    [_playStatusButon setImage:[UIImage imageNamed:@"btn_music_list_stop"] forState:UIControlStateSelected];
    [_playStatusButon addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_playStatusButon];
    
    
}

- (void)playAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(MusicProgressViewDidClickButton:)]) {
        [self.delegate MusicProgressViewDidClickButton:sender];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _centerX = self.bounds.size.width /2;
    _centerY = self.bounds.size.height / 2;
    _radius = self.bounds.size.width >= self.bounds.size.height ? self.bounds.size.height/2 :self.bounds.size.width/2;
    if (_radius > 50) {
        _lineWidth = 2.f;
    }else {
        _lineWidth = 1.f;
    }
    _playStatusButon.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    _playStatusButon.center = CGPointMake(_centerX, _centerY);
    
    
}

-(void)setProgress:(CGFloat)progress
{
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(ctx, kCGLineCapButt);
    CGContextSetLineJoin(ctx, kCGLineJoinBevel);
    CGContextSetLineWidth(ctx, _lineWidth);
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWith256Red:159 green:174 blue:185].CGColor);
    CGContextSetFillColorWithColor(ctx, [UIColor colorWith256Red:231 green:236 blue:241].CGColor);
    CGContextAddArc(ctx, _centerX, _centerY, _radius-_lineWidth*5/2, -M_PI_2, M_PI_2*3, 0);
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWith256Red:27 green:195 blue:237].CGColor);
    CGContextAddArc(ctx, _centerX, _centerY, _radius-_lineWidth*5/2, -M_PI_2, -M_PI_2+_progress*M_PI*2, 0);
    CGContextDrawPath(ctx, kCGPathStroke);

    CGPoint currentPoint = [self getEndPoint:_progress];
    CGContextSetFillColorWithColor(ctx, [UIColor colorWith256Red:27 green:195 blue:237].CGColor);
    CGContextAddArc(ctx, currentPoint.x, currentPoint.y, _lineWidth*5/2, -M_PI_2, M_PI_2*3, 0);
    CGContextDrawPath(ctx, kCGPathFill);
}

//计算小圆点的圆心位置
- (CGPoint)getEndPoint:(CGFloat)progress
{
    CGFloat endX = 0;
    CGFloat endY = 0;
    endY = _centerY + sin(-M_PI_2+_progress*M_PI*2)*(_radius-_lineWidth*5/2);
    endX = _centerX + cos(-M_PI_2+_progress*M_PI*2)*(_radius-_lineWidth*5/2);
    CGPoint point = CGPointMake(endX, endY);
    return point;
}



@end
