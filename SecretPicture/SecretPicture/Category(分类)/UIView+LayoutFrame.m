//
//  UIView+LayoutFrame.m
//  Lottery
//
//  Created by houpeng on 13-8-8.
//  Copyright (c) 2013年 houpeng. All rights reserved.
//

#import "UIView+LayoutFrame.h"

@implementation UIView (LayoutFrame)

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}
- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}


- (void)addSubView:(UIView *)bView frameBottomView:(UIView *)sView
{
    [self addSubView:bView frameBottomView:sView offset:0];
}

- (void)addSubView:(UIView *)bView frameBottomView:(UIView *)sView offset:(CGFloat)offset
{
    bView.y = sView.y + sView.height + offset;
    if (bView.superview == self) {
        return;
    }
    [self addSubview:bView];
}

@end
