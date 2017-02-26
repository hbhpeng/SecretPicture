//
//  UIColor+Additions.h
//  autoPrice
//
//  Created by sky on 12-12-26.
//  Copyright (c) 2012年 Bitauto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Additions)
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;



#pragma mark - ThemeColor

/**
 *
 *  深黑色(主标题) #333333 (51, 51, 51)
 */
+ (UIColor *)BJ_TitleColor;


/**
 *
 *  浅黑色（标单标签，tab，segment 非当前颜色）, #666666 (102, 102, 102)
 */
+ (UIColor *)BJ_LightBlackColor;


/**
 *  灰色辅助信息，浅灰（地址，日期, 提示语,评论数）#b7b7b7 (183, 183, 183)
 */
+ (UIColor*)BJ_SubTilteGrayColor;

/**
 *
 *  辅助标题，深灰（销售区域,说明类文字） #999999 (153, 153, 153)
 */
+ (UIColor*)BJ_SubTilteDarkGrayColor;



#pragma mark - for segment

+ (UIColor*)BJ_SegmentNormalColor;

+ (UIColor*)BJ_SegmentSelectedColor;

#pragma mark - for button


#pragma mark - global

/**
 *  全局Cell选中的浅蓝色 (240, 244, 249)
 *
 */
+ (UIColor*)BJ_CellSelectedBGColor;




#pragma mark - 移动统一
/**
 *  全局分割线的颜色 (236, 236, 236)
 */
+ (UIColor *)BJ_lineColor;


/**
 *  列表section 背景色 (242, 242, 242)
 *
 */

+ (UIColor*)BJ_SectionBGColor;


/**
 * 全局UI的背景色 (242, 242, 242)
 */
+ (UIColor*)BJ_BgColor;


/**
 *  全局绿色字体颜色（降价） (0, 153, 0)
 */
+ (UIColor*)BJ_GreeColor;


/**
 *  全局蓝色字体颜色(询价，打电话....等) (51, 105, 177)
 *
 */
+ (UIColor*)BJ_BlueColor;


/**
 *  全局的红色(车型价格，热线电话...等) (221, 39, 39)
 */
+ (UIColor*)BJ_Redcolor;

/**
 *
 *  全局橙色 (255, 136, 0)
 */
+ (UIColor*)BJ_OrangeColor;

@end
