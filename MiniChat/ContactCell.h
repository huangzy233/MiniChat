//
//  ContactCell.h
//  MiniChat
//
//  Created by huangzy on 17/4/6.
//  Copyright © 2017年 huangzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ContactModel;
@interface ContactCell : UITableViewCell

@property(nonatomic,strong) NSString *buddy;
+(instancetype)initWithTableView:(UITableView *)tableView;

-(void)setfunc:(NSInteger)requestCount;
@end
