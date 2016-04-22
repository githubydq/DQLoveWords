//
//  DQWordShowLayout.m
//  LoveWords
//
//  Created by youdingquan on 16/4/21.
//  Copyright © 2016年 youdingquan. All rights reserved.
//

#import "DQWordShowLayout.h"
#import "DQWordCollectionViewCell.h"
#import "Word.h"

@interface DQWordShowLayout ()
@property(nonatomic,strong)NSMutableArray * attrsArray;
@property(nonatomic,assign)CGFloat YMax;
@end

static CGFloat space = 10;

@implementation DQWordShowLayout

-(NSMutableArray *)attrsArray{
    if (!_attrsArray) {
        _attrsArray = [[NSMutableArray alloc] init];
    }
    return _attrsArray;
}

-(void)prepareLayout{
    [super prepareLayout];
    self.YMax = space;
    
    [self.attrsArray removeAllObjects];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i< count; i++) {
        UICollectionViewLayoutAttributes * attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [self.attrsArray addObject:attrs];
    }
}

-(CGSize)collectionViewContentSize{
    return CGSizeMake(375, self.YMax+50);
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attrsArray;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes * attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat x = space;
    CGFloat y = self.YMax;
    CGFloat width = 375-space*2;
    
    Word * model = [[Word alloc] init];
    if (self.currentState == WordStateUnfamiliar) {
        model = [Singleton shareInstance].firstArray[indexPath.row];
    }else if (self.currentState == WordStateCommon){
        model = [Singleton shareInstance].secondArray[indexPath.row];
    }else if (self.currentState == WordStateCommon){
        model = [Singleton shareInstance].thirdArray[indexPath.row];
    }
    CGRect rect = [model.paraphrase boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-space*2-8*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor blackColor]} context:nil];
    CGFloat height = 46+rect.size.height+10;
    
    attrs.frame = CGRectMake(x, y, width, height);
    
    
    self.YMax += height+space;
    return attrs;
}

@end
