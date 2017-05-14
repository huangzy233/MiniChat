//
//  ConversionCell.m
//  MiniChat
//
//  Created by huangzy on 17/4/6.
//  Copyright © 2017年 huangzy. All rights reserved.
//

#import "ConversationCell.h"
#import "Masonry.h"
#import "EaseMob.h"
#import "BadgeView.h"

@interface ConversationCell ()

@property(nonatomic,weak) UIImageView *iconView;
@property(nonatomic,weak) UILabel *username;
@property(nonatomic,weak) UILabel *messageLabel;
@property(nonatomic,weak) BadgeView *badge;
@property(nonatomic,weak) UIView *divide;

@end
@implementation ConversationCell
+(instancetype)initWithTableView:(UITableView *)tableView{
    static NSString *cellIdentifier =@"conversionCell";
    ConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[ConversationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat margin = 8;
        
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.layer.cornerRadius = 50 * 0.5;
        imageView.clipsToBounds = YES;
        self.iconView =imageView;
        [self.contentView addSubview:self.iconView];
        
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.contentView).offset(margin);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        UILabel *username = [[UILabel alloc]init];
        username.font = [UIFont systemFontOfSize:16];
        username.textColor = [UIColor blackColor];
        self.username = username;
        [self.contentView addSubview:self.username];
        
        UILabel *message = [[UILabel alloc]init];
        message.font = [UIFont systemFontOfSize:14];
        message.textColor = [UIColor grayColor];
        self.messageLabel = message;
        [self.contentView addSubview:self.messageLabel];
        
        
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.5;
        self.divide = view;
        [self.contentView addSubview:self.divide];
        
        
        BadgeView *badge = [[BadgeView alloc]init];
        self.badge = badge;
        [self.contentView addSubview:self.badge];
        
        
        [self.divide mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.height.equalTo(@1);
            make.right.equalTo(self.contentView);
            make.left.equalTo(self.iconView.mas_right).offset(margin);
        }];
        [self.username mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconView.mas_right).offset(margin);
            make.top.equalTo(self.contentView.mas_top).offset(margin);
        }];
        [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.username);
            make.top.equalTo(self.username.mas_bottom).offset(margin);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-1.5 * margin);
            make.right.equalTo(self.contentView.mas_right).offset(-margin);
        }];
        [self.badge mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-2 * margin);
            make.top.equalTo(self.iconView.mas_top).offset(margin);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
    }
    return self;
}
-(void)setConversation:(EMConversation *)conversation{
    _conversation = conversation;
    
    self.iconView.image = [UIImage imageNamed:@"chatListCellHead"];
    
    self.username.text =conversation.chatter;
    
    id body= conversation.latestMessage.messageBodies[0];
    
    if([body isKindOfClass:[EMTextMessageBody class]]){
        EMTextMessageBody *textbody = body;
        self.messageLabel.text = textbody.text;
    }else if([body isKindOfClass:[EMVoiceMessageBody class]]){
        self.messageLabel.text = @"[语音]";
    }else if([body isKindOfClass:[EMImageMessageBody class]]){
        self.messageLabel.text = @"[图片]";
    }
   else
   {
       self.messageLabel.text =@"";
   }
}
-(void)setUnreadCount:(NSInteger)count{
    [self.badge setBadgeValue: [NSString stringWithFormat:@"%ld",(long)count]];
}
-(void) layoutSubviews{
    [super layoutSubviews];
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
