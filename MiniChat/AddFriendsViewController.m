//
//  AddFriendsViewController.m
//  MiniChat
//
//  Created by huangzy on 17/4/5.
//  Copyright © 2017年 huangzy. All rights reserved.
//

#import "AddFriendsViewController.h"
#import "EaseMob.h"
#import "MBProgressHUD+MJ.h"

@interface AddFriendsViewController ()<EMChatManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation AddFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)addFriends:(id)sender {
    NSString *username = _textField.text;
    //NSString *myName = [[EaseMob sharedInstance].chatManager loginInfo][@"username"];
    NSString *message =@"请求添加好友";
    EMError *error = nil;
    BOOL isSuccess =[[EaseMob sharedInstance].chatManager addBuddy:username message:message error:&error];
    if(isSuccess && !error){
        [MBProgressHUD showSuccess:@"好友请求发送成功"];
    }else
    {

        NSLog(@"添加好友出错:%@",error);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
