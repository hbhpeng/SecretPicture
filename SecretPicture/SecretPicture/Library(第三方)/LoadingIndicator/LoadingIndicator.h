//
//  LoadingIndicator.h
//  CloudBook
//
//  Created by fuacici on 10/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
     LoadingIndicatorModeIndeterminate,/*菊花 + 正在载入...文字*/
     LoadingIndicatorModeIndicator,/*只显示菊花*/
	 LoadingIndicatorModeAction,/*显示载入失败点击屏幕重新载入,*/
}  LoadingIndicatorMode;


@interface LoadingIndicator : UIView
{
	UILabel * instructions;
	UIActivityIndicatorView * indicator;
    UIButton *_actionButton;
    
}
@property (readonly,retain) UILabel * instructions;
@property (readonly,retain)  UIActivityIndicatorView * indicator;
@property (nonatomic,assign) LoadingIndicatorMode mode;

@property (nonatomic,copy) NSString *loadingText;
@property (nonatomic,copy) NSString *actionText;

@property (nonatomic, assign) float loadingOffsetY;

- (void)showLoading;
- (void)hideLoading;
- (BOOL) isAnimating;

- (void)addActionTarget:(id)target action:(SEL)sel;

@end
