//
//  ConversionCell.h
//  MiniChat
//
//  Created by huangzy on 17/4/6.
//  Copyright © 2017年 huangzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EaseMob.h"
@interface ConversationCell : UITableViewCell

+(instancetype)initWithTableView:(UITableView *)tableView;
@property(nonatomic,strong)EMConversation *conversation;
-(void)setUnreadCount:(NSInteger)count;

@end
