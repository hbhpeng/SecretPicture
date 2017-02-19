//
//  UIView+LayoutFrame.h
//  Lottery
//
//  Created by houpeng on 13-8-8.
//  Copyright (c) 2013年 houpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LayoutFrame)

- (CGFloat)x;
- (CGFloat)y;

- (CGFloat)height;

- (CGFloat)width;

- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;

- (void)setWidth:(CGFloat)width;

- (void)setHeight:(CGFloat)height;

- (void)setSize:(CGSize)size;

- (CGSize)size;

- (void)setOrigin:(CGPoint)origin;

- (CGPoint)origin;

- (void)addSubView:(UIView *)bView frameBottomView:(UIView *)sView;

- (void)addSubView:(UIView *)bView frameBottomView:(UIView *)sView offset:(CGFloat)offset;

@end
