//
//  DQReviewItem.h
//  LoveWords
//
//  Created by youdingquan on 16/4/24.
//  Copyright © 2016年 youdingquan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Word;
@interface DQReviewItem : UIView
@property(nonatomic,strong)Word * word;
@property (weak, nonatomic) IBOutlet UILabel *index;
@end
