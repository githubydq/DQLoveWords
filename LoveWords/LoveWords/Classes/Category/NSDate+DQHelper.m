//
//  NSDate+DQHelper.m
//  LoveWords
//
//  Created by youdingquan on 16/4/22.
//  Copyright © 2016年 youdingquan. All rights reserved.
//

#import "NSDate+DQHelper.h"

@implementation NSDate (DQHelper)
+(NSString *)stringByNowDate{
    NSDate * now = [self date];
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyyMMddHHmmss";
    return [format stringFromDate:now];
}
@end
