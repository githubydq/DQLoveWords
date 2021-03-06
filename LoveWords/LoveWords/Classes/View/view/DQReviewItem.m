//
//  DQReviewItem.m
//  LoveWords
//
//  Created by youdingquan on 16/4/24.
//  Copyright © 2016年 youdingquan. All rights reserved.
//

#import "DQReviewItem.h"
#import "Word.h"

@interface DQReviewItem ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *paraphase;
@property (weak, nonatomic) IBOutlet UIButton *showParaphaseBtn;

@end

@implementation DQReviewItem

-(void)awakeFromNib{
    [self.paraphase setHidden:YES];
    [self.showParaphaseBtn setHidden:NO];
    
    if (self.word) {
        self.name.text = self.word.name;
        self.paraphase.text = self.word.paraphrase;
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.showParaphaseBtn.layer.cornerRadius = self.showParaphaseBtn.frame.size.height/2.0;
    self.showParaphaseBtn.layer.masksToBounds = YES;
    self.showParaphaseBtn.layer.borderWidth = 1;
    self.showParaphaseBtn.layer.borderColor = [[UIColor grayColor] CGColor];
    
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor grayColor] CGColor];
}

-(void)setWord:(Word *)word{
    _word = word;
    self.name.text = word.name;
    self.paraphase.text = word.paraphrase;
}


- (IBAction)showParaphase:(UIButton *)sender {
    [self.paraphase setHidden:NO];
    [self.showParaphaseBtn setHidden:YES];
}

@end
