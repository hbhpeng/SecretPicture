//
//  AppDelegate.h
//  SecretPicture
//
//  Created by 鹏 侯 on 17/2/13.
//  Copyright © 2017年 鹏 侯. All rights reserved.
//

#import <UIKit/UIKit.h>‘

#import "TabBarViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, MyTabBarDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) TabBarViewController * tabbarView;

@property (nonatomic, retain) UITabBarController * tabController;

@end

