//
//  FriendsListViewController.m
//  MiniChat
//
//  Created by huangzy on 17/3/30.
//  Copyright © 2017年 huangzy. All rights reserved.
//

#import "FriendsListViewController.h"
#import "EaseMob.h"
#import "AddFriendsViewController.h"
#import "ContactCell.h"
#import "ChatRoomController.h"
#import "FriendRequestViewController.h"
#import "AppDelegate.h"


@interface FriendsListViewController () <EMChatManagerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) NSMutableArray *buddyList;
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addFriends;

@end

@implementation FriendsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = NO;
    if(self.buddyList.count == 0)
    {
        [self reloadData];
        [self.tableView reloadData];
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

-(NSMutableArray *)buddyList{
    if(!_buddyList){
        _buddyList =[NSMutableArray array];
    }
    return _buddyList;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tableView.rowHeight = 50;
    [self reloadData];
}


-(void)getData{
    NSArray *array = [[EaseMob sharedInstance].chatManager buddyList];
    for(EMBuddy *buddy in array)
    {
        [self.buddyList addObject:buddy.username];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
-(void)reloadData{
   
    [self.buddyList removeAllObjects];
    [self getData];
    NSLog(@"buddylist:%@",_buddyList);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 1;
    }
    else{
        return _buddyList.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath{
    if(indexPath.section == 0){
        ContactCell *cell = [ContactCell initWithTableView:tableView];
        
        AppDelegate *app = [[UIApplication sharedApplication]delegate];
        [cell setfunc:app.array.count];
        
        return cell;
    }
    else{
        ContactCell *cell = [ContactCell initWithTableView:tableView];
        [cell setBuddy:[_buddyList objectAtIndex:indexPath.row]] ;
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 1){
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSString *username = _buddyList[indexPath.row];
        [[EaseMob sharedInstance].chatManager removeBuddy:username removeFromRemote:YES error:nil];
        NSLog(@"被删除用户:%@",username);
        [self reloadData];
        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *buddy = [self.buddyList objectAtIndex:indexPath.row];
    ChatRoomController *chatVC = [[UIStoryboard storyboardWithName:@"main" bundle:nil] instantiateViewControllerWithIdentifier:@"chatRoom"];
    chatVC.friendName = buddy;
    [chatVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:chatVC animated:YES];
    }
    else{
        FriendRequestViewController *fqVC = [[UIStoryboard storyboardWithName:@"main" bundle:nil] instantiateViewControllerWithIdentifier:@"friendRequest"];
        [fqVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:fqVC animated:YES];
    }
}


-(void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error{
    if(!error){
        [self reloadData];
        [self.tableView reloadData];
        NSLog(@"好友：%@",_buddyList);
    }
}
-(void)didAcceptedByBuddy:(NSString *)username{
   
    [self loadBuddyListFromServer];
}
-(void)loadBuddyListFromServer{
    [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
        [self reloadData];
        [self.tableView reloadData];
    } onQueue:nil];
}

-(void)didUpdateBuddyList:(NSArray *)buddyList changedBuddies:(NSArray *)changedBuddies isAdd:(BOOL)isAdd{
    [self reloadData];
    [self.tableView reloadData];
}
-(void)didAcceptBuddySucceed:(NSString *)username{
    [self loadBuddyListFromServer];
}
-(void)didRemovedByBuddy:(NSString *)username{
    [self loadBuddyListFromServer];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    id vc = segue.destinationViewController;
    if([vc isKindOfClass: [ChatRoomController class]]){
        NSInteger selectedRow = [self.tableView indexPathForSelectedRow].row;
        
        ChatRoomController *chatRoom = vc;
        chatRoom.buddy = self.buddyList[selectedRow];
    }
}

@end
