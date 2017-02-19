//
//  MBProgressHUDNew+BJHubHelper.h
//  autoPrice

//  快速显示/隐藏Hub、并可设置提示语

//  Created by mac on 15/7/23.
//  Copyright (c) 2015年 Bitauto. All rights reserved.
//

#import "MBProgressHUDNew.h"

@interface MBProgressHUDNew (BJHubHelper)


#pragma mark - 显示Message HUB

/**
 *   显示MessageHub(不带菊花) 
 *   默认2s自动隐藏 调用者无需手动添加隐藏逻辑
 *
 *  @param message message
 *  @param view     需要将hub加载到那个view上面 如果为nil则默认加载到keywindow上
 *                  一般view 为viewcontroller.view 或者NavigationController.view
 */
+ (void)bjShowMessageHubWithMessage:(NSString *)message
                             toView:(UIView *)view;


/**
 *  显示MessageHub(不带菊花) 
 *  默认 2s自动隐藏 调用者无需手动添加隐藏逻辑
 *
 *  @param message   title 第一行文字
 *  @param detailMsg detail Message 第二行文字
 *  @param imgName   custom 图片
 *  @param view     需要将hub加载到那个view上面 如果为nil则默认加载到keywindow上
 *                  一般view 为viewcontroller.view 或者NavigationController.view
 */
+ (void)bjShowMessageHubWithMessage:(NSString *)message
                      detailMessage:(NSString *)detailMsg
                    customImageName:(NSString *)imgName
                             toView:(UIView *)view;


#pragma mark - 显示Loading Message HUB
/**
 *  显示loadingHUB 不阻塞页面
 *  调用者需要手动添加隐藏逻辑（隐藏方法bjHideHubInView:）
 *
 *  @param message message
 *  @param view     需要将hub加载到那个view上面 如果为nil则默认加载到keywindow上
 *                  一般view 为viewcontroller.view 或者NavigationController.view
 */
+ (void)bjShowLoadingHubWithMessage:(NSString *)message
                             toView:(UIView *)view;

/**
 *  显示loadingHUB 调用者需要手动添加隐藏逻辑（隐藏方法bjHideHubInView:）
 *
 *  @param message 显示文字
 *  @param view     需要将hub加载到那个view上面 如果为nil则默认加载到keywindow上
 *                  一般view 为viewcontroller.view 或者NavigationController.view
 *  @param allow   是否允许阻塞页面
 */
+ (void)bjShowLoadingHubWithMessage:(NSString *)message
                             toView:(UIView *)view
               allowUserInteraction:(BOOL)allow;

#pragma mark - 隐藏HUB
/**
 *  hide views hub
 *
 *  @param view 需要将hub加载到哪个view上面 如果为nil 则默认加载到keywindow上
                一般view 为viewcontroller.view 或者NavigationController.view
 */
+ (void)bjHideHubInView:(UIView *)view;

/**
 *  hide views hub
 *
 *  @param view 需要将hub加载到哪个view上面 如果为nil 则默认加载到keywindow上
 一般view 为viewcontroller.view 或者NavigationController.view
 *  @param animation 如果调bjHideHubInView隐藏后马上调bjShowMessageHubWithMessage此时HUB会马上消失，需要设置animation为NO
 */
+ (void)bjHideHubInView:(UIView *)view animation:(BOOL)animation;


@end
