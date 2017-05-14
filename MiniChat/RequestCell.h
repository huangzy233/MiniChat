//
//  RequestCell.h
//  MiniChat
//
//  Created by huangzy on 17/4/27.
//  Copyright © 2017年 huangzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequestCell : UITableViewCell
//model
@property(strong,nonatomic) NSDictionary *dic;

+(instancetype)intiWithTableView:(UITableView *)tableView;
@end
