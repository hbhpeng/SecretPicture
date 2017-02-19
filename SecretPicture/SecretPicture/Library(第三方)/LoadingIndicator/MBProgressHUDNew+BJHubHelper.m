//
//  MBProgressHUDNew+BJHubHelper.m
//  autoPrice
//
//  Created by mac on 15/7/23.
//  Copyright (c) 2015年 Bitauto. All rights reserved.
//

#import "MBProgressHUDNew+BJHubHelper.h"
static const float khubHideDelayTime = 2.0f;

@implementation MBProgressHUDNew (BJHubHelper)

+ (void)bjShowMessageHubWithMessage:(NSString *)message
                             toView:(UIView *)view {
    [self bjShowMessageHubWithMessage:message
                        detailMessage:nil
                      customImageName:nil
                               toView:view];
}

+ (void)bjShowMessageHubWithMessage:(NSString *)message
                      detailMessage:(NSString *)detailMsg
                    customImageName:(NSString *)imgName
                             toView:(UIView *)view {
    
    UIView *targetView = [self bjAddToTargertView:view];
    
    MBProgressHUDNew *hub = [MBProgressHUDNew HUDForView:targetView];
    if (!hub) {
        hub = [MBProgressHUDNew showHUDAddedTo:targetView animated:YES];
    }
    
    hub.labelText = message;
    if (detailMsg) {
        hub.detailsLabelText = detailMsg;
    }
    
    if (imgName) {
        hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    }
    
    hub.mode = MBProgressHUDNewModeCustomView;
    
    // 隐藏时候从父控件中移除
    hub.removeFromSuperViewOnHide = YES;

    // 之后再消失
    [hub hide:YES afterDelay:khubHideDelayTime];
}

+ (void)bjShowLoadingHubWithMessage:(NSString *)message
                             toView:(UIView *)view {
    [self bjShowLoadingHubWithMessage:message toView:view allowUserInteraction:YES];
}

+ (void)bjShowLoadingHubWithMessage:(NSString *)message
                             toView:(UIView *)view
               allowUserInteraction:(BOOL)allow {
    UIView *targetView = [self bjAddToTargertView:view];
    
    //先取消view中所有的hub 防止重复添加
    [MBProgressHUDNew hideAllHUDsForView:targetView animated:NO];

    MBProgressHUDNew *hub = [[MBProgressHUDNew alloc] initWithView:targetView];
    hub.userInteractionEnabled = !allow;
    
    hub.labelText = message;
    hub.square = YES;
    hub.removeFromSuperViewOnHide = YES;
    
    
    [targetView addSubview:hub];
    [targetView bringSubviewToFront:hub];
    [hub show:YES];
}

+ (void)bjHideHubInView:(UIView *)view {
    [MBProgressHUDNew hideAllHUDsForView:[self bjAddToTargertView:view] animated:YES];
}

+ (void)bjHideHubInView:(UIView *)view animation:(BOOL)animation {
    [MBProgressHUDNew hideAllHUDsForView:[self bjAddToTargertView:view] animated:NO];
}
#pragma mark - Helper
+ (UIView *)bjAddToTargertView:(UIView *)view {
    if (view == nil) {
        return [UIApplication sharedApplication].keyWindow;
    }
    
    return view;
}
@end
