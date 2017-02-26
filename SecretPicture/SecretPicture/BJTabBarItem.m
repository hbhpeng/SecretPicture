//
//  BJTabBarItem.m
//  autoPrice
//
//  Created by apple on 15/1/26.
//  Copyright (c) 2015年 Bitauto. All rights reserved.
//

#import "BJTabBarItem.h"

@implementation BJTabBarItem

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)layoutSubviews{

    [super layoutSubviews];
    float topMargin = 2.f;
    float bottomMargin = 4.f;
    UILabel *titleLabel = self.titleLabel;
    UIImageView *iconView = self.imageView;
    
    //iconView.backgroundColor = [UIColor redColor];
    //titleLabel.backgroundColor = [UIColor greenColor];
    iconView.center = CGPointMake(self.bounds.size.width/2, topMargin + iconView.bounds.size.height/2);
    titleLabel.center = CGPointMake(self.bounds.size.width/2,
                                    self.bounds.size.height - bottomMargin - titleLabel.bounds.size.height/2);
}
@end
