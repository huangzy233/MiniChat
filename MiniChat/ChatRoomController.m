//
//  ChatRoomController.m
//  MiniChat
//
//  Created by huangzy on 17/4/8.
//  Copyright © 2017年 huangzy. All rights reserved.
//

#import "ChatRoomController.h"
#import "ChatCell.h"
#import "ISEmojiView.h"
#import "AudioView.h"
#import "AudioPlayTool.h"
#import "EMCDDeviceManager.h"

@interface ChatRoomController ()<UITableViewDelegate,UITableViewDataSource,EMChatManagerDelegate,UITextViewDelegate,UINavigationBarDelegate,ISEmojiViewDelegate,AudioDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *chatBar;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(strong,nonatomic) ISEmojiView *emoji;
@property (strong,nonatomic) AudioView *audio;
@property (strong,nonatomic) UIImagePickerController *imgPicker;

@property(strong,nonatomic) EMConversation *conversation;
@property(strong,nonatomic) NSMutableArray *dataArray;
@property(assign,nonatomic) CGRect myframe;
@property(assign,nonatomic) CGRect tableViewFrame;

//当前选中的btn
@property(nonatomic,strong) UIButton *selectedBtn;
@end

@implementation ChatRoomController

-(NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray =[NSMutableArray array];
    }
    return _dataArray;
}
-(ISEmojiView *)emoji{
    if(!_emoji){
        _emoji = [[ISEmojiView alloc] initWithTextField:self.textView delegate:self];
    }
    return _emoji;
}
-(AudioView *)audio{
    if(!_audio){
        _audio = [[AudioView alloc]init];
        _audio.delegate = self;
    }
    return _audio;
}
-(UIImagePickerController *)imgPicker{
    if(!_imgPicker){
        _imgPicker = [[UIImagePickerController alloc]init];
        _imgPicker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        _imgPicker.allowsEditing = YES;
        _imgPicker.delegate = self;
    }
    return _imgPicker;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self scrollToButtom];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _myframe = [UIScreen mainScreen].bounds;
    _tableViewFrame = self.tableView.frame;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = NO;
    
    self.textView.layer.borderColor = [UIColor grayColor].CGColor;
    self.textView.layer.cornerRadius = 5;
    self.textView.layer.borderWidth = 1;
    
    self.title  =_friendName;
    self.textView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    [self loadConversations];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    [[EaseMob sharedInstance].chatManager addDelegate: self delegateQueue:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KBShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KBHide:) name:UIKeyboardWillHideNotification object:nil];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
    [self.view addGestureRecognizer:tap];
    
}
-(void)click:(UITapGestureRecognizer *)tap{
    self.selectedBtn.selected = NO;
    self.selectedBtn = nil;
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)KBShow:(NSNotification *)notify{
    CGRect kbFrame = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
     CGFloat kbHeight = kbFrame.size.height;
    

    //CGFloat transY = kbHeight - self.view.frame.size.height;
    if(self.view.frame.size.height == self.myframe.size.height){
       [UIView animateWithDuration:0.25 animations:^{
           /*
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-kbHeight, self.view.frame.size.width, self.view.frame.size.height);
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y+kbHeight, self.tableView.frame.size.width, self.view.frame.size.height-kbHeight);
            */
           CGRect temp = self.view.frame;
           temp.origin.y =-(kbHeight);
           self.view.frame = temp;
           
           self.tableView.frame = CGRectMake(_tableViewFrame.origin.x, _tableViewFrame.origin.y+kbHeight, _tableViewFrame.size.width, _tableViewFrame.size.height-kbHeight);
           
            [self scrollToButtom];
      }];

    }
    NSLog(@"KBShow");
   }

-(void)KBHide:(NSNotification *) notify{

    /*
    CGRect kbFrame = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat kbHeight = kbFrame.size.height;
    */
    //CGFloat transY = kbHeight - self.view.frame.size.height;
        [UIView animateWithDuration:0.25 animations:^{
           self.view.frame = _myframe;
           self.tableView.frame = _tableViewFrame;
            /*
           self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+kbHeight, self.view.frame.size.width, self.view.frame.size.height);
           self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.view.frame.size.height+kbHeight);
             */
            [self scrollToButtom];
    }];
    NSLog(@"KBHide");
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    self.tableView.dataSource = nil;
}

-(void)scrollToButtom{
    if(self.dataArray.count == 0){
        return;
    }
    
   NSIndexPath *index =[NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0];
   [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:YES];
  
}

-(void)loadConversations{
    EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:_friendName conversationType:eConversationTypeChat];
    self.conversation =conversation;
    
    NSArray *messageArray = [conversation loadAllMessages];
    
    for(EMMessage *message in messageArray){
        [self addDataArrayWithMesssage:message];
    }
}

-(void)addDataArrayWithMesssage:(EMMessage *)message{
    
    [self.dataArray addObject:message];
    
    [self.conversation markMessageWithId:message.messageId asRead:YES];
}

//tableview delegate

/*
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count ;
}
-(UITableViewCell  *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ChatCell *cell =[ChatCell initWithTableView:tableView];
    EMMessage * message = self.dataArray[indexPath.row];
    
    if([message.from isEqualToString:self.friendName]){
        cell.isReceiver = YES;
    }else{
        cell.isReceiver = NO;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell setMessage:message];
    NSLog(@"%@ message is :%@",message.from,cell.messageLabel.text);
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatCell *cell = [self tableView : tableView cellForRowAtIndexPath:indexPath];
    return [cell cellHeight];
}

//UITextView delegate
-(void)textViewDidChange:(UITextView *)textView{

    if([textView.text hasSuffix:@"\n"]){
        
        [self sendText:textView.text];
        textView.text = nil;
        NSLog(@"消息发送成功");
    }
    CGRect frame =textView.frame;
    frame.size.height = 33;
    [UIView animateWithDuration:0.25 animations:^{
        textView.frame = frame;
    }];
    
    [textView setContentOffset:CGPointZero animated:YES];
    [textView scrollRangeToVisible:textView.selectedRange];
}
-(float)heightForTextView:(UITextView *)textView WithText:(NSString *)text{
    
    CGFloat maxHeight = 88;
    CGFloat minHeight = 33;
    
    CGSize contentSize = CGSizeMake(textView.contentSize.width, CGFLOAT_MAX);
    CGRect size = [text boundingRectWithSize:contentSize options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize :14]} context:nil];
    float textHeight = size.size.height + 22.0;
    if(textHeight > maxHeight){
        textHeight = maxHeight;
    }else if(textHeight < minHeight){
        textHeight = minHeight;
    }
    return textHeight;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    CGRect frame = textView.frame;
    CGFloat contentHeight = [self heightForTextView:textView WithText:text];
    frame.size.height = contentHeight;
    [UIView animateWithDuration:0.25 animations:^{
        textView.frame= frame;
    }];
    
    return YES;
}


-(void)sendText:(NSString *)text{
    text = [text substringToIndex:text.length -1];
    
    EMChatText *chatText = [[EMChatText
                             alloc]initWithText:text];
    
    EMTextMessageBody *body = [[EMTextMessageBody alloc ]initWithChatObject:chatText];
    [self sendMessage:body];
}
-(void)sendMessage:(id<IEMMessageBody>)body{
    EMMessage *message = [[EMMessage alloc]initWithReceiver:self.friendName bodies:@[body]];
    message.messageType = eMessageTypeChat;
    
    id msg = message.messageBodies[0];
    if([body isKindOfClass:[EMTextMessageBody class]]){
        EMTextMessageBody *textBody = msg;
        if(textBody.text.length == 0){
            return;
        }
    }
    [[EaseMob sharedInstance ].chatManager asyncSendMessage:message progress:nil];
    
    [self addDataArrayWithMesssage:message];
    [self.tableView reloadData];
    
    [self scrollToButtom];
}

-(void) didReceiveMessage:(EMMessage *)message{
    if([message.from isEqualToString:self.friendName]){
        [self addDataArrayWithMesssage:message];
        
        [self.tableView reloadData];
        [self scrollToButtom];
    }
}
//  表情键盘
- (IBAction)emojiBtnClicked:(UIButton *)sender {
    if(!sender.selected){
        self.selectedBtn.selected = NO;
        sender.selected = YES;
        self.selectedBtn = sender;
        
        [UIView animateWithDuration:0.25 animations:^{
        
            self.textView.inputView = self.emoji;
            
            if([self.textView isFirstResponder]){
                [self.textView reloadInputViews];
            }else{
                [self.textView becomeFirstResponder];
            }
        }];
    }else{
        sender.selected = NO;
        self.selectedBtn = nil;
        // [self.textView resignFirstResponder];
        self.textView.inputView = nil;
        if([self.textView isFirstResponder]){
            [self.textView reloadInputViews];
        }else{
            [self.textView becomeFirstResponder];
        }
    }
}
//emoji delegate
-(void)emojiView:(ISEmojiView *)emojiView didSelectEmoji:(NSString *)emoji{
    self.textView.text = [self.textView.text stringByAppendingString:emoji];
}

-(void)emojiView:(ISEmojiView *)emojiView didPressDeleteButton:(UIButton *)deletebutton{
    if (self.textView.text.length > 0) {
        NSRange lastRange = [self.textView.text rangeOfComposedCharacterSequenceAtIndex:self.textView.text.length-1];
        self.textView.text = [self.textView.text substringToIndex:lastRange.location];
    }
}

//语音
- (IBAction)voiceRecord:(UIButton *)sender {
    if(!sender.selected){
        
        self.selectedBtn.selected = NO;
        sender.selected = YES;
        self.selectedBtn = sender;
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.textView.inputView = self.audio;

            if([self.textView isFirstResponder]){
                [self.textView reloadInputViews];
            }else{
                [self.textView becomeFirstResponder];
            }
        }];
    }else{
        sender.selected = NO;
        self.selectedBtn = nil;
        // [self.textView resignFirstResponder];
        self.textView.inputView = nil;
        if([self.textView isFirstResponder]){
            [self.textView reloadInputViews];
        }else{
            [self.textView becomeFirstResponder];
        }
    }
}
- (void)sendVoice:(NSString *)recordPath duration:(NSInteger)duration{
    
    //1.构建一个语音的消息体
    EMChatVoice *chatVoice = [[EMChatVoice alloc] initWithFile:recordPath displayName:@"[语音]"];
    //    chatVoice.duration = duration;
    
    EMVoiceMessageBody *voiceBody = [[EMVoiceMessageBody alloc] initWithChatObject:chatVoice];
    voiceBody.duration = duration;
    
    [self sendMessage:voiceBody];
}
-(void)audioView:(AudioView *)audioView beginRecord:(UIButton *)recordBtn{
    int x = arc4random() % 100000;
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"%d%d",(int)time,x];
    
    [[EMCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:fileName completion:^(NSError *error) {
        if (!error) {
            NSLog(@"开始录音成功");
        }
    }];
}
-(void)audioView:(AudioView *)audioView endRecord:(UIButton *)recordBtn{
    [[EMCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
        if (!error) {
            NSLog(@"结束录音成功");
            NSLog(@"%@====%zd",recordPath,aDuration);
            //发送语音
            [self sendVoice:recordPath duration:aDuration];
        }
    }];
}
-(void)audioView:(AudioView *)audioView cancleRecord:(UIButton *)recordBtn{
    [[EMCDDeviceManager sharedInstance] cancelCurrentRecording];
}

//发送图片
- (IBAction)ImagePic:(UIButton *)sender {
    self.imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imgPicker animated:YES completion:nil];
}
-(void)sendImage:(UIImage *)image{
    EMChatImage *orginalImage = [[EMChatImage alloc] initWithUIImage:image displayName:@"图片"];
    
    EMImageMessageBody *imgBody = [[EMImageMessageBody alloc] initWithImage:orginalImage thumbnailImage:nil];

    [self sendMessage:imgBody];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info{
   
    UIImage *selectedImg = info[UIImagePickerControllerOriginalImage];
    //发送图片
    [self sendImage:selectedImg];
    //隐藏当前图片选择器
    [self dismissViewControllerAnimated:picker completion:NULL];
}
@end
