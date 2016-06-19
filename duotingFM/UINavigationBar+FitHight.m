//
//  UINavigationBar+FitHight.m
//  Cheche
//
//  Created by apple on 16/4/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UINavigationBar+FitHight.h"

@implementation UINavigationBar (FitHight)


- (CGSize)sizeThatFits:(CGSize)size
{
    
    CGSize s = [super sizeThatFits:size];
    
    if (size.height>0) {
        
        s.height = size.height;
        
    } else {
        
        s.height = 44;
        
    }
    
    return s;
    
}

@end
