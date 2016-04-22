//
//  DQWordCollectionViewCell.m
//  LoveWords
//
//  Created by youdingquan on 16/4/21.
//  Copyright © 2016年 youdingquan. All rights reserved.
//

#import "DQWordCollectionViewCell.h"
#import "Word.h"

@interface DQWordCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *paraphrase;

@end

@implementation DQWordCollectionViewCell

- (void)awakeFromNib {
    
}

-(void)setModel:(Word *)model{
    _model = model;
    self.name.text = model.name;
    self.paraphrase.text = model.paraphrase;
}

@end
