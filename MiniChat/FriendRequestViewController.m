//
//  FriendRequestViewController.m
//  MiniChat
//
//  Created by huangzy on 17/4/27.
//  Copyright © 2017年 huangzy. All rights reserved.
//

#import "FriendRequestViewController.h"
#import "ConversationViewController.h"
#import "AppDelegate.h"
#import "EaseMob.h"
#import "RequestCell.h"

@interface FriendRequestViewController ()<EMChatManagerDelegate,UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic) NSMutableArray *data;



@end

@implementation FriendRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [self loadFriendRequest];
    
    self.tableView.separatorStyle = NO;
    self.tableView.rowHeight = 70;
}
-(void) loadFriendRequest{
   // NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    _data = app.array;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    RequestCell *cell = [RequestCell intiWithTableView:tableView];
    NSDictionary *dic = _data[indexPath.row];
    cell.dic = dic;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    NSDictionary *dic = self.data[indexPath.row];
    
    if(editingStyle == UITableViewCellEditingStyleDelete ){
        EMError *error = nil;
        BOOL isSuccess = [[EaseMob sharedInstance].chatManager rejectBuddyRequest:[dic objectForKey:@"username"] reason:nil error:&error];
        if(isSuccess && !error){
            NSLog(@"已拒绝好友申请");
            [self.data removeObject:dic];
            [self.tableView reloadData];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source


@end
