//
//  AppDelegate.m
//  SecretPicture
//
//  Created by 鹏 侯 on 17/2/13.
//  Copyright © 2017年 鹏 侯. All rights reserved.
//

#import "AppDelegate.h"

#import "SPHotPictureViewController.h"

#import "SPPersonalPageViewController.h"

#import "SPSecondTabViewController.h"

#import "SPMorePlatesViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self constructTabbarControllers];
    self.window.rootViewController = self.tabController;
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)constructTabbarControllers
{
    //热门图片
    SPHotPictureViewController * hotCon = [[SPHotPictureViewController alloc] init];
    hotCon.hidesBottomBarWhenPushed = NO;
    UINavigationController *hotNav = [self navWithRootController:hotCon];
    
    SPSecondTabViewController *secondCon = [[SPSecondTabViewController alloc] init];
    secondCon.hidesBottomBarWhenPushed = NO;
    UINavigationController *secondNav = [self navWithRootController:secondCon];
    
    SPMorePlatesViewController *morePlatesCon = [[SPMorePlatesViewController alloc] init];
    morePlatesCon.hidesBottomBarWhenPushed = NO;
    UINavigationController *morePlatesNav = [self navWithRootController:morePlatesCon];
    
    SPPersonalPageViewController *personalCon = [[SPPersonalPageViewController alloc] init];
    personalCon.hidesBottomBarWhenPushed = NO;
    UINavigationController *personNav = [self navWithRootController:personalCon];
    
    UITabBarController *tabController = [[UITabBarController alloc] init];
    self.tabController = tabController;
    self.tabController.viewControllers = @[hotNav,secondNav,morePlatesNav,personNav];
    
    self.tabbarView = [[TabBarViewController alloc] init];
    self.tabbarView.delegate = self;
    self.tabbarView.view.frame = CGRectMake(0, 0, MAINWIDTH, 49);
    [self.tabController.tabBar addSubview:self.tabbarView.view];
}

- (UINavigationController *)navWithRootController:(UIViewController *)rootCon
{
    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:rootCon];
    [navCon.navigationBar setBackgroundImage:[[UIImage imageNamed:@"_nav7.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 200, 0, 20)]forBarMetrics:UIBarMetricsDefault];
    return navCon;
}

#pragma mark -
#pragma mark MyTabBarDelegate
- (void)tapWithIndex:(NSInteger)index {
    if (self.tabController.selectedIndex != index) {
        
        [self.tabController setSelectedIndex:index];
    }else {
        UINavigationController *itemNav = (UINavigationController *)[self.tabController.viewControllers objectAtIndex:index];
        [itemNav popToRootViewControllerAnimated:YES];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
