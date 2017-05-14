//
//  ChatCell.m
//  MiniChat
//
//  Created by huangzy on 17/4/9.
//  Copyright © 2017年 huangzy. All rights reserved.
//

#import "ChatCell.h"
#import "PhotoContainerView.h"
#import "Masonry.h"
#import "AudioPlayTool.h"
@interface ChatCell ()

@property (strong,nonatomic) UIImageView *imgView;
@property(strong,nonatomic) PhotoContainerView *photoView;

@end

@implementation ChatCell

-(UIImageView *)imgView{
    if(!_imgView ){
        _imgView = [[UIImageView alloc]init];
        
    }
    return _imgView;
}
-(PhotoContainerView *)photoView{
    if(!_photoView){
        _photoView = [[PhotoContainerView alloc]init];
        
    }
    return _photoView;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        self.frame = CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
        UIImageView *head = [[UIImageView alloc]init];
        head.layer.cornerRadius = 25.0f;
        head.layer.borderWidth = 1.0f;
        head.clipsToBounds = YES;
        self.headView = head;
        [self.contentView addSubview:self.headView];
        
        self.bubbleView = [[UIImageView alloc]init];
        self.bubbleView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.bubbleView];
        
        UILabel *message = [[UILabel alloc]init];
        message.numberOfLines = 0;
        message.font = [UIFont systemFontOfSize:17.0f];
        message.userInteractionEnabled = YES;
        [message setPreferredMaxLayoutWidth: self.frame.size.width - 60];
        self.messageLabel = message;
        [self.bubbleView addSubview: self.messageLabel];
        //为label添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
        [tap addTarget:self action:@selector(messageLabelTap:)];
        [self.messageLabel addGestureRecognizer:tap];
        
    }
    return self;
}
+(instancetype)initWithTableView:(UITableView *)tableView {
    NSString *identifier = @"chatCell";
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[ChatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    return cell;
}
/*
-(void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(messageLabelTap:)];
    [self.messageLabel addGestureRecognizer:tap];
    self.messageLabel.userInteractionEnabled = YES;
    NSLog(@"添加点击事件");
}
*/
-(void)messageLabelTap:(UITapGestureRecognizer *) recoginer{
    
    id body = self.message.messageBodies[0];
    NSLog(@"播放");
    if([body isKindOfClass:[EMVoiceMessageBody class]]){
        [AudioPlayTool playWithMessage:self.message messageLabel:self.messageLabel receiver:_isReceiver];
       
    }
}

-(CGFloat)cellHeight{
    /*
    CGRect rect = [self.messageLabel.text boundingRectWithSize:CGSizeMake(200, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil];
    
    // 文本内容的frame
    self.messageLabel.frame = CGRectMake(13, 5, rect.size.width, rect.size.height);
     */
    [self layoutIfNeeded];
    return 30+self.messageLabel.bounds.size.height+30;
}

-(void) setMessage:(EMMessage *)message{
    
    [self.photoView removeFromSuperview];
    
    _message = message;
    id body = message.messageBodies[0];
    if([body isKindOfClass:[EMTextMessageBody class]]){
        EMTextMessageBody *text = body;
        [self refreshCell:text.text];
        self.messageLabel.text = text.text;
        
    }else if([body isKindOfClass:[EMVoiceMessageBody class]]){
        [self setBubbleFrame:CGRectMake(0, 0, 50, 40)];
        self.messageLabel.attributedText = [self voiceAttribute];
    }else if([body isKindOfClass:[EMImageMessageBody class]]){
 
        [self showImage];
        [self setBubbleFrame:self.photoView.frame];
    }else{
        self.messageLabel.text = @"未知的消息类型";
    }

}
-(void)setBubbleFrame:(CGRect)rect{
    UIImage * img = nil;
    UIImage * headImg = [UIImage imageNamed:@"chatListCellHead"];
    if(_isReceiver){
        self.headView.frame = CGRectMake(10,rect.size.height - 18, 50, 50);
        self.bubbleView.frame = CGRectMake(60,10, rect.size.width+20, rect.size.height + 20);
        img = [UIImage imageNamed:@"chat_receiver_bg"];
    }else{
        self.headView.frame = CGRectMake(self.frame.size.width-60, rect.size.height - 18, 50, 50);
        self.bubbleView.frame = CGRectMake(self.frame.size.width-60 -rect.size.width - 20, 10, rect.size.width +20, rect.size.height +20);
        img= [UIImage imageNamed:@"chat_sender_bg"];
    }
    
    img = [img stretchableImageWithLeftCapWidth:img.size.height/2 topCapHeight:img.size.height/2];
    
    self.bubbleView.image = img;
    self.headView.image = headImg;
    self.messageLabel.frame = CGRectMake(_isReceiver? 13: 5,5, rect.size.width, rect.size.height);
}
-(void)refreshCell:(NSString *)text{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(200, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    [self setBubbleFrame:rect];
    
}
-(void)showImage{
    
    EMImageMessageBody *imgBody = self.message.messageBodies[0];
    CGRect thumbnailFrame = (CGRect){0,0,imgBody.thumbnailSize};
    
    NSTextAttachment *imgAttach = [[NSTextAttachment alloc] init];
    imgAttach.bounds = thumbnailFrame;
    NSAttributedString *imgAtt = [NSAttributedString attributedStringWithAttachment:imgAttach];
    self.messageLabel.attributedText = imgAtt;
    
    [self.messageLabel addSubview:self.photoView];
    
    /*
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.messageLabel);
        make.edges.equalTo(@0);
    }];
     */
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:imgBody.thumbnailLocalPath]) {
            self.photoView.picPathStringsArray = @[imgBody.thumbnailLocalPath];
     }else{
        self.photoView.picPathStringsArray = @[imgBody.thumbnailRemotePath];
    }
}
-(NSAttributedString *)voiceAttribute{
    NSMutableAttributedString *voice =[[NSMutableAttributedString alloc]init];
    if (_isReceiver) {
        
        UIImage *receiveImg = [UIImage imageNamed:@"chat_receiver_audio_playing_full"];

        NSTextAttachment *imageAttachment = [[NSTextAttachment alloc]init];
        imageAttachment.image = receiveImg;
        imageAttachment.bounds = CGRectMake(0, -10, 30, 30);

        NSAttributedString *imgAtt = [NSAttributedString attributedStringWithAttachment:imageAttachment];
        [voice appendAttributedString:imgAtt];
        
        EMVoiceMessageBody *voiceBody = self.message.messageBodies[0];
        NSInteger duaration = voiceBody.duration;
        NSString *timeStr = [NSString stringWithFormat:@"%ld'",duaration];

        NSAttributedString *timeAttribute = [[NSAttributedString alloc] initWithString:timeStr];
        [voice appendAttributedString:timeAttribute];
        
    }else{
        EMVoiceMessageBody *voiceBody = self.message.messageBodies[0];
        NSInteger duaration = voiceBody.duration;
        NSString *timeStr = [NSString stringWithFormat:@"%ld'",duaration];

        NSAttributedString *timeAttribute = [[NSAttributedString alloc] initWithString:timeStr];
        [voice appendAttributedString:timeAttribute];

        UIImage *receiveImg = [UIImage imageNamed:@"chat_sender_audio_playing_full"];

        NSTextAttachment *imageAttachment = [[NSTextAttachment alloc]init];
        imageAttachment.image = receiveImg;
        imageAttachment.bounds = CGRectMake(0, -10, 30, 30);
        NSAttributedString *imgAtt = [NSAttributedString attributedStringWithAttachment:imageAttachment];
        [voice appendAttributedString:imgAtt];
    }
    return [voice copy];
}
@end
