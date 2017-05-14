//
//  ChatCell.h
//  MiniChat
//
//  Created by huangzy on 17/4/9.
//  Copyright © 2017年 huangzy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EaseMob.h"

@interface ChatCell : UITableViewCell

@property(strong,nonatomic) UIImageView *headView;
@property(strong,nonatomic) UIImageView *bubbleView;
@property(strong,nonatomic) UILabel *messageLabel;
@property(assign,nonatomic) BOOL isReceiver;
@property (strong,nonatomic) EMMessage *message;


-(CGFloat)cellHeight;
+(instancetype)initWithTableView:(UITableView *)tableView;// andIdentifity:(NSString *)identifier;
@end
