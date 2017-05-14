//
//  RequestCell.m
//  MiniChat
//
//  Created by huangzy on 17/4/27.
//  Copyright © 2017年 huangzy. All rights reserved.
//

#import "RequestCell.h"
#import "Masonry.h"
#import "EaseMob.h"
#import "AppDelegate.h"

@interface RequestCell ()<EMChatManagerDelegate>
@property (strong,nonatomic) UIImageView *headerView;
@property (strong,nonatomic) UILabel *buddyName;
@property (strong,nonatomic) UILabel *extraMessage;
@property(strong,nonatomic) UIButton *addBtn;

//@property (strong,nonatomic) UIButton *cancelBtn;

//@property (strong,nonatomic) UILabel *stateLabel;
@end

@implementation RequestCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        CGFloat margin = 10;
        
        UIImageView *img = [[UIImageView alloc]init];
        img.layer.cornerRadius = 25.0f;
        [self.contentView addSubview: img];
        self.headerView = img;
        
        UILabel *buddyname = [[UILabel alloc]init];
        buddyname.font = [UIFont systemFontOfSize:16];
        buddyname.textColor = [UIColor blueColor];
        [self.contentView addSubview: buddyname];
        self.buddyName = buddyname;
        
        UILabel *msg = [[UILabel alloc]init];
        msg.font =[UIFont systemFontOfSize: 14];
        msg.textColor = [UIColor grayColor];
        [self.contentView addSubview:msg];
        self.extraMessage = msg;
        
        UIButton *addBtn = [[UIButton alloc]init];
        addBtn.backgroundColor = [UIColor blueColor];
        [addBtn setTitle:@"同意" forState:UIControlStateNormal ];
        [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView addSubview: addBtn];
        self.addBtn = addBtn;
        
        /*
        UIButton *cancelBtn = [[UIButton alloc]init];
        cancelBtn.titleLabel.text = @"拒绝";
        cancelBtn.backgroundColor = [UIColor blueColor];
        [self.contentView addSubview: cancelBtn];
        self.cancelBtn = cancelBtn;
         
        
        UILabel *state = [[UILabel alloc]init];
        state.font =[UIFont systemFontOfSize:16];
        state.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview: state];
        self.stateLabel = state;
         */
        
        [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.contentView).offset(margin);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
          [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-2 * margin);
              make.top.equalTo(self.headerView.mas_top).offset(margin);
            make.size.mas_equalTo(CGSizeMake(50, 30));
        }];
        
        [self.buddyName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(margin);
            make.left.equalTo(self.headerView.mas_right).offset(margin);
        }];
    
        [self.extraMessage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-margin);
            make.left.equalTo(self.buddyName.mas_left);
            make.top.equalTo(self.buddyName.mas_bottom).offset(margin);
        }];
    }
    return self;
}
+(instancetype)intiWithTableView:(UITableView *)tableView{
    NSString *identifier =@"requestCell";
    
    RequestCell *cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[RequestCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
-(void)setDic:(NSDictionary *)dic{
    
    self.headerView.image =[UIImage imageNamed:@"chatListCellHead"];
    
    NSString *buddyName = [dic objectForKey:@"username"];
    NSString *message = [dic objectForKey:@"message"];
    
    self.buddyName.text = buddyName;
    self.extraMessage.text = message;
    
    [self.addBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)btnClick:(UIButton *)btn{
    
    NSString *username =self.buddyName.text;
    NSString *message = self.extraMessage.text;
    EMError *error = nil;
    NSLog(@"username:%@",username);
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager acceptBuddyRequest:username error:&error];
    if(isSuccess && !error){
        NSLog(@"添加好友成功");
    }
    self.addBtn.userInteractionEnabled = NO;
    self.addBtn.font = [UIFont systemFontOfSize:14];
    [self.addBtn setTitle:@"已同意" forState:UIControlStateNormal];
    [self.addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.addBtn.alpha = 0.6;
    self.addBtn.backgroundColor =[UIColor whiteColor];
    
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:username , @"username" ,message, @"message",nil];
    [app.array removeObject: dic];
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
