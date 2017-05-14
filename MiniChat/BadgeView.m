//
//  BadgeView.m
//  MiniChat
//
//  Created by huangzy on 17/5/6.
//  Copyright © 2017年 huangzy. All rights reserved.
//

#import "BadgeView.h"

@implementation BadgeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    if([super initWithFrame:frame]){
        [self setBackgroundImage:[UIImage imageNamed:@"tabbar_badge"] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        self.hidden = YES;
        self.userInteractionEnabled = NO;
    }
    return self;
}
-(void)setBadgeValue:(NSString *)badgeValue{
    _badgeValue = badgeValue.copy;
    if(![badgeValue isEqualToString:@"0"]){
        self.hidden = 0;
        if([badgeValue intValue] > 99){
            badgeValue = @"99+";
        }
        [self setTitle:badgeValue forState:UIControlStateNormal];
        CGFloat bandgeButtonH = self.currentBackgroundImage.size.height;
        CGFloat bandgeButtonW = self.currentBackgroundImage.size.width;
        if (badgeValue.length > 1) {
            CGSize badgeSize = [badgeValue sizeWithFont:self.titleLabel.font];
            bandgeButtonW = badgeSize.width + 10;
        }
        CGRect bandgeFrame = self.frame;
        bandgeFrame.size.width = bandgeButtonW;
        bandgeFrame.size.height = bandgeButtonH;
        self.frame = bandgeFrame;
    }else{
        self.hidden = YES;
    }
}

@end
