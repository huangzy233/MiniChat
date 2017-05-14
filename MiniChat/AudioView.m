//
//  AudioView.m
//  MiniChat
//
//  Created by huangzy on 17/5/9.
//  Copyright © 2017年 huangzy. All rights reserved.
//

#import "AudioView.h"
#import "Masonry.h"

#define width 120
#define height 120
@interface AudioView()
@property (nonatomic,strong) UILabel *tipLabel;

@end
@implementation AudioView
- (CGRect)defaultFrame {
    return CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 216);
}
- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUIWithFrame:frame];
    }
    return self;
}
-(void)initUIWithFrame:(CGRect)frame{
    if (CGRectEqualToRect(frame, CGRectZero)) {
        frame = [self defaultFrame];
    }
    self.backgroundColor = [UIColor whiteColor];
    self.frame = frame;
    
    __weak typeof(self) weakSelf = self;
    UILabel *tip = [[UILabel alloc]init];
    tip.text = @"按住说话";
    tip.font = [UIFont systemFontOfSize:16];
    tip.textColor = [UIColor grayColor];
    self.tipLabel = tip;
    [self addSubview:self.tipLabel];
    
    UIButton *btn = [[UIButton alloc] init];
    btn.layer.cornerRadius = width/2;
    btn.layer.masksToBounds = width/2;
    [btn setImage:[UIImage imageNamed:@"VoiceSearchFeedback001"] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor cyanColor]];
    self.recordBtn = btn;
    [self addSubview: self.recordBtn];
    
    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.mas_top).offset(20);
    }];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(width,height));
        make.top.equalTo(tip.mas_bottom).offset(10);
        make.centerX.equalTo(weakSelf);
    }];
    
    [self.recordBtn addTarget:self action:@selector(beginRecord:) forControlEvents:UIControlEventTouchDown];
    [self.recordBtn addTarget:self action:@selector(endRecord:) forControlEvents:UIControlEventTouchUpInside];
    [self.recordBtn addTarget:self action:@selector(cancleRecord:) forControlEvents:UIControlEventTouchUpOutside];
}
//开始录音
-(void)beginRecord:(UIButton *) btn{
    if ([self.delegate respondsToSelector:@selector(audioView:beginRecord:)]) {
        [self.delegate audioView:self beginRecord:btn];
    }
}
//录音结束
-(void)endRecord:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(audioView:endRecord:)]) {
        [self.delegate audioView:self endRecord:btn];
    }
}
//取消录音
-(void)cancleRecord:(UIButton *) btn{
    if ([self.delegate respondsToSelector:@selector(audioView:cancleRecord:)]) {
        [self.delegate audioView:self cancleRecord:btn];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
