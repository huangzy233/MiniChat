//
//  LoginViewController.m
//  MiniChat
//
//  Created by huangzy on 17/3/25.
//  Copyright © 2017年 huangzy. All rights reserved.
//

#import "LoginViewController.h"
#import "MBProgressHUD+MJ.h"
#import "EMError.h"
#import "EaseMob.h"


@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@end

@implementation LoginViewController

@synthesize username = _username;
@synthesize password = _password;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.password.secureTextEntry = YES;
    self.icon.layer.cornerRadius = self.icon.frame.size.width/2;
    self.icon.layer.masksToBounds = YES;
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


- (IBAction)login:(id)sender {
    NSString *username = self.username.text;
    NSString *password = self.password.text;
    NSLog(@"%@", username);
    NSLog(@"%@", password);

    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername: username password:password
     completion:^(NSDictionary *loginInfo, EMError *error) {
         if(!error)
         {
             NSLog(@"登录成功 :%@",loginInfo);
             [MBProgressHUD showSuccess:@"登陆成功"];
             //auto login
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
             [[EaseMob sharedInstance].chatManager asyncFetchBuddyList];
             
             [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
             
             [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];
             self.view.window.rootViewController =[UIStoryboard storyboardWithName:@"main" bundle:nil].instantiateInitialViewController;
         }
         else
         {
             NSLog(@"登录失败 :%@",error);
             [MBProgressHUD showError:@"登陆失败"];
         }
     } onQueue:nil
     ];
    //}
}
- (IBAction)register:(id)sender {
    
    NSString *username = self.username.text;
    NSString *password = self.password.text;
    if(username.length == 0 || password.length == 0)
    {
        dispatch_after(0.2, dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"帐号或密码不能为空" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        });
        return;
    }
    //regist
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:_username.text password:_password.text
     withCompletion:^(NSString *username, NSString *password, EMError *error) {
         if(!error){
             NSLog(@"注册成功");
             [MBProgressHUD showSuccess:@"注册成功"];
         }
         else{
             NSLog(@"注册失败");
             [MBProgressHUD showError:@"注册失败"];
         }
     } onQueue:nil];
}

@end
