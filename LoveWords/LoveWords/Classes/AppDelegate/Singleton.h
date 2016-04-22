//
//  Singleton.h
//  LoveWords
//
//  Created by youdingquan on 16/4/22.
//  Copyright © 2016年 youdingquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Singleton : NSObject
+(instancetype)shareInstance;

@property(nonatomic,strong)NSMutableArray * firstArray;
@property(nonatomic,strong)NSMutableArray * secondArray;
@property(nonatomic,strong)NSMutableArray * thirdArray;
@end
