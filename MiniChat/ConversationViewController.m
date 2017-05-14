//
//  ConversationViewController.m
//  MiniChat
//
//  Created by huangzy on 17/4/8.
//  Copyright © 2017年 huangzy. All rights reserved.
//

#import "ConversationViewController.h"
#import "EaseMob.h"
#import "MBProgressHUD+MJ.h"
#import "ConversationCell.h"
#import "ChatRoomController.h"

@interface ConversationViewController ()<EMChatManagerDelegate>
@property (nonatomic,strong)NSArray *conversation;

@end

@implementation ConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self loadConversations];
    
    self.tableView.separatorStyle = NO;
    self.tableView.rowHeight = 70;
}
-(void)loadConversations{
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    if(conversations.count == 0)
    {
        conversations = [[EaseMob sharedInstance].chatManager loadAllMyGroupsFromDatabaseWithAppend2Chat:YES];
    }
    for(EMConversation *conversation in conversations){
        NSLog(@"name:%@",conversation.chatter);
    }
    self.conversation = conversations;
    
    [self showTabbarBadge];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.conversation.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConversationCell *cell = [ConversationCell initWithTableView:tableView];
    
    EMConversation *conversations = self.conversation[indexPath.row];
    
    [cell setConversation:conversations];
    [cell setUnreadCount:conversations.unreadMessagesCount];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatRoomController *chatRomm = [[UIStoryboard storyboardWithName:@"main" bundle:nil] instantiateViewControllerWithIdentifier:@"chatRoom"];
    EMConversation *conversations = self.conversation[indexPath.row];
    EMBuddy *buddy =[EMBuddy buddyWithUsername:conversations.chatter];
    chatRomm.friendName =buddy.username;
    [chatRomm setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:chatRomm animated:YES];
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        EMConversation *conversation = self.conversation[indexPath.row];
        [[EaseMob sharedInstance].chatManager removeConversationByChatter:conversation.chatter deleteMessages:NO append2Chat:NO];
        [self loadConversations];
        [self.tableView reloadData];
    }
}
-(void)didUnreadMessagesCountChanged{
    [self.tableView reloadData];
    
    [self showTabbarBadge];
}

-(void)didUpdateConversationList:(NSArray *)conversationList{
    self.conversation = conversationList;
    [self.tableView reloadData];
    
    [self showTabbarBadge];
}

/*
-(void)didReceiveBuddyRequest:(NSString *)username message:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"好友申请" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"接受" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[EaseMob sharedInstance].chatManager acceptBuddyRequest:username error:nil];
    }];
    [alert addAction:action];
}
*/
- (void)showTabbarBadge{
    //遍历所有的会话记录,将未读消息数进行类加
    NSInteger totalUnreadCount = 0;
    for (EMConversation *conversation in self.conversation) {
        totalUnreadCount += conversation.unreadMessagesCount;
    }
    if (totalUnreadCount > 0) {
        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",totalUnreadCount];
    }else{
        self.navigationController.tabBarItem.badgeValue = nil;
    }
}
-(void)dealloc{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}
@end
