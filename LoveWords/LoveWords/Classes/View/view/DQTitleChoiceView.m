//
//  DQTitleChoiceView.m
//  LoveWords
//
//  Created by youdingquan on 16/4/20.
//  Copyright © 2016年 youdingquan. All rights reserved.
//

#import "DQTitleChoiceView.h"

@interface DQTitleChoiceView ()
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineX;

@property (weak, nonatomic) IBOutlet UIButton *first;
@property (weak, nonatomic) IBOutlet UIButton *second;
@property (weak, nonatomic) IBOutlet UIButton *third;
@end

@implementation DQTitleChoiceView

#pragma mark -
#pragma mark button click
- (IBAction)unfamiliar:(id)sender {
    self.block(0);
    [UIView animateWithDuration:0.2 animations:^{
        self.line.transform = CGAffineTransformMakeTranslation(0, 0);
//        self.lineX.constant = self.first.frame.origin.x+5;
    }];
}
- (IBAction)common:(id)sender {
    self.block(1);
    [UIView animateWithDuration:0.2 animations:^{
        self.line.transform = CGAffineTransformMakeTranslation(self.second.frame.origin.x - self.first.frame.origin.x, 0);
//        self.lineX.constant = self.second.frame.origin.x+5;
    }];
}
- (IBAction)proficiency:(id)sender {
    self.block(2);
    [UIView animateWithDuration:0.2 animations:^{
        self.line.transform = CGAffineTransformMakeTranslation(self.third.frame.origin.x - self.first.frame.origin.x, 0);
//        self.lineX.constant = self.third.frame.origin.x+5;
    }];
}


@end
