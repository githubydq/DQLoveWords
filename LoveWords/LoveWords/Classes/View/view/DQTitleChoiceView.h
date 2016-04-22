//
//  DQTitleChoiceView.h
//  LoveWords
//
//  Created by youdingquan on 16/4/20.
//  Copyright © 2016年 youdingquan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^TitleChoiceBlock)(NSInteger state);
@interface DQTitleChoiceView : UIView
@property(nonatomic,copy)TitleChoiceBlock block;
@end
