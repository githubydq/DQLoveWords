//
//  Word.h
//  LoveWords
//
//  Created by youdingquan on 16/4/21.
//  Copyright © 2016年 youdingquan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,WordState) {
    WordStateUnfamiliar = 0,
    WordStateCommon,
    WordStateProficiency
};

@interface Word : NSObject
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * paraphrase;
@property(nonatomic,assign)NSInteger state;
@property(nonatomic,copy)NSString * addDate;
@end
