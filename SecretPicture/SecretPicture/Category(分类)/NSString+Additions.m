//
//  NSString+Additions.m
//  SelfDrivingTour
//
//  Created by haiwei li on 12-3-30.
//  Copyright (c) 2012年 13awan. All rights reserved.
//

#import "NSString+Additions.h"
#import <CommonCrypto/CommonDigest.h>
#import "Base64Extension.h"

#define Md5SecretString      @"2CB3147B-D93C-964B-47AE-EEE448C84E3C"

static NSString *_key = @"139E53F54A1DB2B0C850F728FD828456DABD1849420BC454F5F3CB147356EF369421899328DB3A48DE2A387C57E96949F7D76E2BBC2DFA8BB24764029AB80199";

@implementation NSString (MD5)

/* "3.5.1" -> 3.51f,  移除首个点之外的所有点*/
- (float)floatValueFromItunesAppVersionString{
   
    
    NSArray *components = [self componentsSeparatedByString:@"."];
    if (components.count >= 3) {
        NSRange lastComponentsRange = [self rangeOfString:components[components.count -1] options:NSBackwardsSearch];
        NSRange lastDotRange = NSMakeRange(lastComponentsRange.location-1,1);
        NSString *floatStr = [self stringByReplacingCharactersInRange:lastDotRange
                                                           withString:@""];
        if ([floatStr componentsSeparatedByString:@"."].count>=3) {
            return [floatStr floatValueFromItunesAppVersionString];
        }else{
            return [floatStr floatValue];
        }
    }else{
        return [self floatValue];
    }
}

#pragma mark md5

- (NSString *)checkInMd5{

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:[NSDate date]];
    NSInteger day = [components day];
    
    NSString *keyPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/%@",@"checkInKey.txt"];
    
    NSString *keys = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:keyPath]
                                              encoding:NSUTF8StringEncoding
                                                 error:nil];
    
    NSArray *keyArray = [keys componentsSeparatedByString:@","];
    
    NSString *md5Source = [self stringByAppendingFormat:@"%@",keyArray[day]];
    
    return [md5Source md5_origin];
    
}

- (NSString *)sha1
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        {
        [output appendFormat:@"%02x", digest[i]];
        }
    
    return output;
}

-(NSString*)md5{
    
    NSString *md5Source = [self stringByAppendingFormat:@"%@",Md5SecretString];
    
    const char *cStr = [md5Source UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    NSString * str = [NSString stringWithFormat:
                      @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                      result[0], result[1], result[2], result[3],
                      result[4], result[5], result[6], result[7],
                      result[8], result[9], result[10], result[11],
                      result[12], result[13], result[14], result[15]
                      ];
    return [str lowercaseString];
    
}
- (NSString *)md5_origin{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    NSString * str = [NSString stringWithFormat:
                      @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                      result[0], result[1], result[2], result[3],
                      result[4], result[5], result[6], result[7],
                      result[8], result[9], result[10], result[11],
                      result[12], result[13], result[14], result[15]
                      ];
    
    return [str lowercaseString];

}

#pragma mark -
- (BOOL) isValidEmail:(BOOL)stricterFilter{  
    NSString * stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";  
    NSString * laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";  
    NSString * emailRegex = stricterFilter ? stricterFilterString : laxString;  
    NSPredicate * emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];  
    return [emailTest evaluateWithObject:self];  
}

- (BOOL) isMobilePhone
{
    NSString * phoneRegex = @"1[0-9]{10}";
    NSPredicate * phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];  
    return [phoneTest evaluateWithObject:self]; 
}
- (BOOL)isEmptyOrWhitespace {
	return !self.length ||
	![self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length;
}

- (BOOL) isdigitalString{

    NSString *testStr = [self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    
    return !testStr.length;
}

#pragma mark -
+(NSString*)decryptStr:(NSString *)desStr{
    
    NSData *data = [desStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *resultStr = nil;
    
    if (data.length>32) {
        
        
        u_int8_t *_input = (u_int8_t *)[data bytes];
        
        NSData *md5Data = [NSData dataWithBytes:_input length:32];
        NSString *md5Str = [[NSString alloc] initWithData:md5Data encoding:NSUTF8StringEncoding];
        
        
        _input+=32;
        
        NSData *desData = [NSData dataWithBytes:_input length:data.length-32];        
        
        NSData *base64Data = [[[NSString alloc] initWithData:desData
                                                   encoding:NSUTF8StringEncoding]base64DecodedData];
        
    
        NSMutableData *outPutData = [NSMutableData dataWithData:base64Data];
        u_int8_t *_out = (u_int8_t *)[outPutData mutableBytes];
        _input = (u_int8_t *)[base64Data bytes];
       
        const char *keyByte = [_key UTF8String];
        
        int start = 0;
        
        for (int index = 0; index < outPutData.length; index ++) {
            int singleByte = _input[index] - (int)keyByte[start];
            
            if (singleByte<0) {
                singleByte += 0xff;
            }
            
            _out[index] = (Byte)singleByte;
            
            if ((start + 1) == _key.length)
                start = -1;
            
             start++;
        }
        
        //校验解密后的MD5值和传入的md5值是否一致
        NSString *temp = [[NSString alloc] initWithData:outPutData encoding:NSUTF8StringEncoding];
        if ([[temp md5_origin] isEqualToString:[md5Str lowercaseString]]) {
            resultStr = temp;
        }
    }
    

    return resultStr;
    
}

#pragma mark -
//取得字符串的高度
//注: 2000px 是写死的一个最大高度,如果超过2000就按2000算
+ (int)getStringLines:(NSString *)string withFont:(UIFont *)font withWidth:(int)width{
	CGSize temp = CGSizeMake(width, 2000);
	CGSize stringSize;
#ifdef __IPHONE_7_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        stringSize = [[NSString stringWithFormat:@"%@",string]
                      boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                      options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                      attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,UITextAttributeFont, nil] context:nil].size;
        //stringSize = CGSizeMake(ceilf(stringSize.width), ceilf(stringSize.height));
        
        if ([string length] == 0) {
            return 0;
        }
        return ceilf(stringSize.height/([@"Sample样本" boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                               attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,UITextAttributeFont, nil] context:nil].size.height));
        
    }else{
        stringSize = [string sizeWithFont:font
                        constrainedToSize:temp
                            lineBreakMode:NSLineBreakByWordWrapping];
        return ceilf(stringSize.height/[@"Sample样本" sizeWithFont:font].height);
    }
#else
    stringSize = [string sizeWithFont:font
                    constrainedToSize:temp
                        lineBreakMode:NSLineBreakByWordWrapping];
    return ceilf(stringSize.height/[@"Sample样本" sizeWithFont:font].height);
#endif

}

+ (CGSize)getStringSize:(NSString *)string withFont:(UIFont *)font withWidth:(int)width{
	CGSize temp = CGSizeMake(width, 2000);
	CGSize stringSize;
#ifdef __IPHONE_7_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        stringSize = [[NSString stringWithFormat:@"%@",string]
                      boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                      options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                      attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,UITextAttributeFont, nil] context:nil].size;
        
        stringSize = CGSizeMake(ceilf(stringSize.width), ceilf(stringSize.height));
        
        if ([string length] == 0) {
            return CGSizeZero;
        }
        return stringSize;
        
    }else{
        stringSize = [string sizeWithFont:font
                        constrainedToSize:temp
                            lineBreakMode:NSLineBreakByWordWrapping];
        return stringSize;
    }
#else
    stringSize = [string sizeWithFont:font
                    constrainedToSize:temp
                        lineBreakMode:NSLineBreakByWordWrapping];
    return ceilf(stringSize.height/[@"Sample样本" sizeWithFont:font].height);
#endif
    
}

+ (float)getStringWidth:(NSString *)string withFont:(UIFont *)font
{
    CGSize stringSize;
    
    if ([string length] == 0) {
        return 0;
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        
        stringSize = [string sizeWithAttributes:@{UITextAttributeFont: font}];
        return ceilf(stringSize.width);
        
    }else{
        stringSize = [string sizeWithFont:font];
     
    }
    
    stringSize = CGSizeMake(ceilf(stringSize.width), ceilf(stringSize.height));

    return stringSize.width;
}



+(NSString *)changeToScientificNotation:(NSString *)text DecimalStyle:(BOOL)isDecimalStyle
{
    NSNumberFormatter *numFormat = [[NSNumberFormatter alloc] init];
    [numFormat setNumberStyle:NSNumberFormatterDecimalStyle];
    
    if (isDecimalStyle) {
        NSNumber *num = [NSNumber numberWithInt:[text intValue]];
        return [numFormat stringFromNumber:num];
    }else
    {
        [numFormat setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber * num = [numFormat numberFromString:text];
        return [NSString stringWithFormat:@"%@",num];
    }
    
}
- (NSDictionary*)queryContentsUsingEncoding:(NSStringEncoding)encoding {
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[NSScanner alloc] initWithString:self];
    while (![scanner isAtEnd]) {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 1 || kvPair.count == 2) {
            NSString* key = [[kvPair objectAtIndex:0]
                             stringByReplacingPercentEscapesUsingEncoding:encoding];
            NSMutableArray* values = [pairs objectForKey:key];
            if (nil == values) {
                values = [NSMutableArray array];
                [pairs setObject:values forKey:key];
            }
            if (kvPair.count == 1) {
                [values addObject:[NSNull null]];
                
            } else if (kvPair.count == 2) {
                NSString* value = [[kvPair objectAtIndex:1]
                                   stringByReplacingPercentEscapesUsingEncoding:encoding];
                [values addObject:value];
            }
        }
    }
    return [NSDictionary dictionaryWithDictionary:pairs];
}



-(NSString *)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet {
    NSRange rangeOfLastWantedCharacter = [self rangeOfCharacterFromSet:[characterSet invertedSet]
                                                               options:NSBackwardsSearch];
    if (rangeOfLastWantedCharacter.location == NSNotFound) {
        return @"";
    }
    return [self substringWithRange:NSMakeRange(0, rangeOfLastWantedCharacter.location+rangeOfLastWantedCharacter.length)];
}

@end

#pragma mark -
@implementation NSString (JSONValue)

- (id)BJJSONValue{

    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error = nil;
    
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    if (error != nil) return nil;
    return result;
}


@end
