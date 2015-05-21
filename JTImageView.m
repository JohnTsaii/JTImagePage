//
//  JTImageView.m
//  JTImagePage
//
//  Created by CC on 15/5/21.
//  Copyright (c) 2015年 John TSai. All rights reserved.
//

#import "JTImageView.h"

@implementation JTImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setIsVisible:(BOOL)isVisible {
    _isVisible = isVisible;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"index=%li,page=%li,<%f,%f,%f,%f>",self.index,self.page,self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height];
}

@end
