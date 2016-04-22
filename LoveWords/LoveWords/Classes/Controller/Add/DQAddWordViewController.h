//
//  DQAddWordViewController.h
//  LoveWords
//
//  Created by youdingquan on 16/4/21.
//  Copyright © 2016年 youdingquan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Word;

typedef NS_ENUM(NSInteger,AddWordState) {
    AddWordStateAdd = 0,
    AddWordStateEdit,
    AddWordStateShow
};

@protocol DQAddWordDelegate <NSObject>

@required
-(void)addWordCompleted;

@end


@interface DQAddWordViewController : UIViewController
@property(nonatomic,assign)id <DQAddWordDelegate> delegate;
@property(nonatomic,assign)AddWordState state;
@property(nonatomic,strong)Word * model;/**<not add model*/
@property(nonatomic,assign)NSInteger modifyIndex;
@end
