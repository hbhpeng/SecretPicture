//
//  TabBarViewController.h
//  SelfDrivingTour
//
//  Created by haiwei li on 12-3-26.
//  Copyright (c) 2012年 13awan. All rights reserved.
//

#import <UIKit/UIKit.h>

//工具和我的页面tab索引，tab功能位置有变化的时候，注意修改此索引

#define ToolTabBarIndex   @"2"
#define MoreTabeBarIndex  @"4"

@protocol MyTabBarDelegate;



@interface TabBarViewController : UIViewController
{
    int selectedInt;
}
@property (nonatomic, weak) id <MyTabBarDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIImageView *moreShowNew;
@property (nonatomic, retain) IBOutlet UIImageView *toolNewView;

/**
 *  刷新是否显示小红点
 */
- (void)freshNew;

- (IBAction)buttonAction:(id)sender;

@end

@protocol MyTabBarDelegate <NSObject>

- (void)tapWithIndex:(NSInteger)index;

@end