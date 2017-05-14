//
//  AudioView.h
//  MiniChat
//
//  Created by huangzy on 17/5/9.
//  Copyright © 2017年 huangzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AudioDelegate;

@interface AudioView : UIView

@property (nonatomic,strong) UIButton *recordBtn;
@property (nonatomic,assign) id<AudioDelegate> delegate;

@end
@protocol AudioDelegate <NSObject>

-(void)audioView:(AudioView *)audioView beginRecord:(UIButton *)recordBtn;
-(void)audioView:(AudioView *)audioView endRecord:(UIButton *)recordBtn;
-(void)audioView:(AudioView *)audioView cancleRecord:(UIButton *)recordBtn;

@end

