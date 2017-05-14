//
//  ChatRoomController.h
//  MiniChat
//
//  Created by huangzy on 17/4/8.
//  Copyright © 2017年 huangzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EaseMob.h"
@interface ChatRoomController : UIViewController

@property(copy,nonatomic) NSString *friendName;
@property(strong,nonatomic) EMBuddy *buddy;

@end
