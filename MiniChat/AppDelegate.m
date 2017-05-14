//
//  AppDelegate.m
//  MiniChat
//
//  Created by huangzy on 17/3/23.
//  Copyright © 2017年 huangzy. All rights reserved.
//

#import "AppDelegate.h"
#import "EaseMob.h"
#import "LoginViewController.h"
#import "MBProgressHUD+MJ.h"
@interface AppDelegate ()<EMChatManagerDelegate>

@end

@implementation AppDelegate

  
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //initialize SDk
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"1180170322115618#minichat"apnsCertName:nil];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    //set loginviewcontroller as rootviewcontroller
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
   LoginViewController *rootViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    self.window.rootViewController = rootViewController;
    [self.window makeKeyAndVisible];
    
    // Override point for customization after application launch.
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
    if([[EaseMob sharedInstance].chatManager isAutoLoginEnabled]){
        self.window.rootViewController = [UIStoryboard storyboardWithName:@"main" bundle:nil].instantiateInitialViewController;
    }
    
    
    //set navitionBar's attributes
    [self setNB];
    return YES;
    
}
     
-(void)setNB{
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.barTintColor = [UIColor colorWithRed:20/255.0 green:133/255.0 blue:213/255.0 alpha:1.0];
    
    bar.tintColor = [UIColor whiteColor];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}
-(void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    if(!error){
        [MBProgressHUD showSuccess:@"自动登录成功"];
    }
    else
    {
        [MBProgressHUD showError:@"自动登录失败"];
    }
}

-(void)didReceiveBuddyRequest:(NSString *)username message:(NSString *)message{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:username,@"username",message,@"message",nil];
    _array =[[NSMutableArray alloc]init];
    [_array addObject:dic];
}
-(void)dealloc
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
   
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];

}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[EaseMob sharedInstance ] applicationWillTerminate:application];
}


@end
