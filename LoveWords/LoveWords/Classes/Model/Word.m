//
//  Word.m
//  LoveWords
//
//  Created by youdingquan on 16/4/21.
//  Copyright © 2016年 youdingquan. All rights reserved.
//

#import "Word.h"

@implementation Word

-(void)setValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues{
    self.name = [keyedValues objectForKey:@"name"];
    self.paraphrase = [keyedValues objectForKey:@"paraphrase"];
    self.state = [[keyedValues objectForKey:@"state"] integerValue];
    self.addDate = [keyedValues objectForKey:@"addDate"];
}

-(NSString *)description{
    return [NSString stringWithFormat:@"%@,%@,%ld,%@",self.name,self.paraphrase,self.state,self.addDate];
}
@end
