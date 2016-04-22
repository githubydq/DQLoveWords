//
//  Singleton.m
//  LoveWords
//
//  Created by youdingquan on 16/4/22.
//  Copyright © 2016年 youdingquan. All rights reserved.
//

#import "Singleton.h"

static Singleton * _singleton = nil;

@implementation Singleton

+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleton = [[super allocWithZone:NULL] init];
    });
    return _singleton;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    return [Singleton shareInstance];
}
-(instancetype)copyWithZone:(struct _NSZone *)zone{
    return [Singleton shareInstance];
}

#pragma mark -
#pragma mark 懒加载
-(NSMutableArray *)firstArray{
    if (!_firstArray) {
        _firstArray = [[NSMutableArray alloc] init];
    }
    return _firstArray;
}
-(NSMutableArray *)secondArray{
    if (!_secondArray) {
        _secondArray = [[NSMutableArray alloc] init];
    }
    return _secondArray;
}
-(NSMutableArray *)thirdArray{
    if (!_thirdArray) {
        _thirdArray = [[NSMutableArray alloc] init];
    }
    return _thirdArray;
}

@end
