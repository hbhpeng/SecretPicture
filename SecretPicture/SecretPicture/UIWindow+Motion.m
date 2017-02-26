//
//  UIWindow+Motion.m
//  SecretPicture
//
//  Created by destiny1991 on 17/2/26.
//  Copyright © 2017年 鹏 侯. All rights reserved.
//

#import "UIWindow+Motion.h"

#import <FLEX/FLEXManager.h>

@implementation UIWindow (Motion)

- (BOOL)canBecomeFirstResponder {//默认是NO，所以得重写此方法，设成YES
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    [[FLEXManager sharedManager] showExplorer];
}

@end
