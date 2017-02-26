//
//  TabBarViewController.m
//  SelfDrivingTour
//
//  Created by haiwei li on 12-3-26.
//  Copyright (c) 2012年 13awan. All rights reserved.
//

#import "TabBarViewController.h"
#import <QuartzCore/QuartzCore.h>
//#import "ForumUserManager.h"
#import "DeviceModel.h"

static const NSString *tabBarNameArray[] = {
    [0] = @"热门",
    [1] = @"资源",
    [2] = @"板块",
    [3] = @"我的",
};

@interface TabBarViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *tabBarButtonCollection;
@end

@implementation TabBarViewController

@synthesize delegate;
@synthesize moreShowNew;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabSwitch:) name:@"tabSwitch" object:nil];
    }
    return self;
}

-(void)tabSwitch:(NSNotification *)noti{
    NSLog(@"noti.userInfo :%@ --- id:%@",noti.userInfo,noti.object);
    
    UIButton *button = (UIButton *)[self.view viewWithTag:[noti.object intValue]];
    
    NSLog(@"butto .tag :%d",(int)button.tag);
    
    if (selectedInt != button.tag) {
        
            // 设置新选中button的highlight image
        NSString *selectBtnImage = [self imageNameForButtonTag:button.tag status:YES];
        [button setImage:[UIImage imageNamed:selectBtnImage] forState:UIControlStateNormal];
//        [button setTitleColor:TextColorBlue forState:UIControlStateNormal];
        
        
            // 设置上次选中button的normal image
        selectBtnImage = [self imageNameForButtonTag:selectedInt status:NO];
        UIButton *_btn = (UIButton *)[self.view viewWithTag:selectedInt];
        [_btn setImage:[UIImage imageNamed:selectBtnImage] forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:UIControlStateNormal];
        
        selectedInt = (int)button.tag;
    }
    
    if (delegate && [delegate respondsToSelector:@selector(tapWithIndex:)]) {
        [delegate tapWithIndex:(button.tag-1)];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initTabBarVC];
    [self freshNew];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) initTabBarVC
{
    // 默认选择第一个tabBar
    selectedInt = 1;
    UIButton *button = (UIButton *)[self.view viewWithTag:selectedInt];
    NSString *selectBtnImage = [self imageNameForButtonTag:button.tag status:YES];
    [button setImage:[UIImage imageNamed:selectBtnImage] forState:UIControlStateNormal];
//    [button setTitleColor:TextColorBlue forState:UIControlStateNormal];
    [button setTitle:(NSString *)tabBarNameArray[0] forState:UIControlStateNormal];

    CGFloat margin = (MAINWIDTH - 64*4)/4;
    
    int index = 0;
    for (UIButton *btn in _tabBarButtonCollection) {
        if (index == 0) {
            btn.center = CGPointMake( margin/2 + index * (64 + margin) + 64/2, 25);
            index++;
            continue;
        }
        
        btn.center = CGPointMake( margin/2 + index * (64 + margin) + 64/2, 25);
        if (index == 2) {
            self.toolNewView.center = CGPointMake(btn.center.x + 15, 9);
        }else if(index == 4){
            self.moreShowNew.center = CGPointMake(btn.center.x + 15, 9);
        }
        
        [btn setTitle:(NSString *)tabBarNameArray[index] forState:UIControlStateNormal];
        NSString *imageName = [self imageNameForButtonTag:btn.tag status:NO];
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:UIControlStateNormal];
        index++;
    }
    
    if (delegate && [delegate respondsToSelector:@selector(tapWithIndex:)]) {
        [delegate tapWithIndex:(button.tag-1)];
    }
}

- (void)freshNew {
//        self.toolNewView.hidden = ![USER_DEFAULT boolForKey:kShowNewVote];
//        if ([[ForumUserManager sharedForumUserManager] isShowRedPoint] || [USER_DEFAULT boolForKey:kShowNewAD]) {
//            self.moreShowNew.hidden = NO;
//        } else {
//            self.moreShowNew.hidden = YES;
//        }
    /*
    if ([[USER_DEFAULT stringForKey:kCommunitySwitch] isEqualToString:@"1"]) {//论坛开启
    } else{
        if ([USER_DEFAULT boolForKey:kShowNewVote]) {
            self.toolNewView.hidden = NO;
        }else{
            self.toolNewView.hidden = ![USER_DEFAULT boolForKey:kShowNewTool];
        }
    }*/
}

- (IBAction)buttonAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    if (selectedInt != button.tag) {
        
        // 设置新选中button的highlight image
        NSString *selectBtnImage = [self imageNameForButtonTag:button.tag status:YES];
        [button setImage:[UIImage imageNamed:selectBtnImage] forState:UIControlStateNormal];
//        [button setTitleColor:TextColorBlue forState:UIControlStateNormal];

        
        // 设置上次选中button的normal image
        selectBtnImage = [self imageNameForButtonTag:selectedInt status:NO];
        UIButton *_btn = (UIButton *)[self.view viewWithTag:selectedInt];
        [_btn setImage:[UIImage imageNamed:selectBtnImage] forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:UIControlStateNormal];

        selectedInt = (int)button.tag;
    }

    
    if (delegate && [delegate respondsToSelector:@selector(tapWithIndex:)]) {
        [delegate tapWithIndex:(button.tag-1)];
    }
}

// 返回tabBar对应状态下的图片 tabBar_press_5 tabBar_nor_5.png
- (NSString *)imageNameForButtonTag:(NSInteger)tag status:(BOOL)highlighted
{
    NSString *imageName;
    if (highlighted) {
        imageName = [NSString stringWithFormat:@"tabBar_press_%d",(int)(tag)];
    }else {
        imageName = [NSString stringWithFormat:@"tabBar_nor_%d",(int)(tag)];
    }
    return imageName;
}


-(void)dealloc{
    self.moreShowNew = nil;
    self.toolNewView = nil;
    self.tabBarButtonCollection = nil;
}

@end
