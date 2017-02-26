//
//  UIColor+Additions.m
//  autoPrice
//
//  Created by sky on 12-12-26.
//  Copyright (c) 2012年 Bitauto. All rights reserved.
//

#import "UIColor+Additions.h"

#define DEFAULT_VOID_COLOR [UIColor whiteColor]

@implementation UIColor (Additions)
//字符串转颜色
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
#pragma mark  - theme color

+ (UIColor*)BJ_BgColor
{
//    return [UIColor colorWithHexString:@"#ffffff"];
    return [UIColor colorWithHexString:@"#f2f2f2"];
}

+ (UIColor *)BJ_TitleColor
{
    return [UIColor colorWithHexString:@"#333333"];
}

/**
 *
 *  浅黑色
 */
+ (UIColor *)BJ_LightBlackColor
{
    return [UIColor colorWithHexString:@"#666666"];
}


+ (UIColor*)BJ_SubTilteGrayColor
{
    return [UIColor colorWithHexString:@"#b7b7b7"];
}
+ (UIColor*)BJ_SubTilteDarkGrayColor
{
    return [UIColor colorWithHexString:@"#999999"];
}

+ (UIColor*)BJ_Redcolor
{
    return [UIColor colorWithHexString:@"#dd2727"];
}
+ (UIColor*)BJ_GreeColor
{

    return [UIColor colorWithHexString:@"#009900"];
}
+ (UIColor*)BJ_CellSelectedBGColor
{
    return [UIColor colorWithHexString:@"#ececec"];
}

+ (UIColor*)BJ_BlueColor
{
    return [UIColor colorWithHexString:@"#3369b1"];
}

+ (UIColor*)BJ_lineColor
{
    return [UIColor colorWithHexString:@"#ececec"];
}

/**
 *  列表section 背景色
 *
 */

+ (UIColor*)BJ_SectionBGColor{

    return [UIColor colorWithHexString:@"#f2f2f2"];
}

/**
 *
 *  全局橙色
 */
+ (UIColor*)BJ_OrangeColor
{
    return [UIColor colorWithHexString:@"#ff8800"];
}

@end
