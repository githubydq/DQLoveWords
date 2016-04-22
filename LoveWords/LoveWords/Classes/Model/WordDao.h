//
//  WordDao.h
//  LoveWords
//
//  Created by youdingquan on 16/4/21.
//  Copyright © 2016年 youdingquan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Word;

@interface WordDao : NSObject
+(BOOL)save:(Word*)model;
+(BOOL)update:(Word*)model;
+(NSMutableArray*)findAll;
+(NSMutableArray*)findAtState:(NSInteger)state;
@end
