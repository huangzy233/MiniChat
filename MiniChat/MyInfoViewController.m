//
//  MyInfoViewController.m
//  MiniChat
//
//  Created by huangzy on 17/3/30.
//  Copyright © 2017年 huangzy. All rights reserved.
//

#import "MyInfoViewController.h"
#import "EaseMob.h"
#import "LoginViewController.h"
#import "MBProgressHUD+MJ.h"
@interface MyInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *headIcon;

@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userName.text = [[EaseMob sharedInstance].chatManager loginInfo][@"username"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Logout:(id)sender {
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES/NO completion:^(NSDictionary *info, EMError *error) {
        if(!error)
        {
            [MBProgressHUD showSuccess:@"退出登陆成功"];
             [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:NO];
            self.view.window.rootViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        }
        else
        {
            NSLog(@"注销失败%@",error);
            [MBProgressHUD showError:@"注销帐号失败"];
        }
    } onQueue:nil];
}


@end
