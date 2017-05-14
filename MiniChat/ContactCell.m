//
//  ContactCell.m
//  MiniChat
//
//  Created by huangzy on 17/4/6.
//  Copyright © 2017年 huangzy. All rights reserved.
//

#import "ContactCell.h"
#import "ContactModel.h"
#import "Masonry.h"
#import "BadgeView.h"

@interface ContactCell()
@property(nonatomic,strong) UIImageView *icon;
@property(nonatomic,strong) UILabel *nameLable;
@property(nonatomic,weak) BadgeView *badge;
@end

@implementation ContactCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.layer.cornerRadius = 25.0;
        [self.contentView addSubview:iconView];
        self.icon = iconView;
        
        CGFloat margin = 8;
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(35,35));
            make.left.mas_equalTo(self.contentView).with.offset(margin);
            make.centerY.mas_equalTo(self.contentView);
        }];
        
        UILabel *nameLable = [[UILabel alloc]init];
        [self.contentView addSubview:nameLable];
        self.nameLable = nameLable;
        [nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).with.offset(margin);
            make.centerY.mas_equalTo(iconView);
        }];
        
        BadgeView *badge = [[BadgeView alloc]init];
        self.badge = badge;
        [self.contentView addSubview:self.badge];
        [self.badge mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-2 * margin);
            make.top.equalTo(self.icon.mas_top).offset(margin);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];    }
    return self;
}
-(void)setBuddy:(NSString *)buddy{
    self.icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"chatListCellHead"]];
    self.nameLable.text = buddy;
}
-(void)setfunc:(NSInteger)requestCount{
    self.icon.image = [UIImage imageNamed:@"plugins_FriendNotify"];
    self.nameLable.text = @"好友请求";
    
    [self.badge setBadgeValue: [NSString stringWithFormat:@"%ld",(long)requestCount]];
}
+(instancetype) initWithTableView:(UITableView *)tableView{
    static NSString *cellIdentifier = @"buddyCell";
    id cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
