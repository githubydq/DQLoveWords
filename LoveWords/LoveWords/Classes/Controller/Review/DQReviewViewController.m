//
//  DQReviewViewController.m
//  LoveWords
//
//  Created by youdingquan on 16/4/24.
//  Copyright © 2016年 youdingquan. All rights reserved.
//

#import "DQReviewViewController.h"
#import "DQReviewItem.h"
#import "Word.h"
#import "WordDao.h"

@interface DQReviewViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property(nonatomic,strong)NSMutableArray * showViewArray;/**<展示视图数组*/
@property(nonatomic,strong)NSMutableArray * wordArray;/**<单词数组*/

@property(nonatomic,assign)NSInteger currentIndex;/**<索引*/
//单词下标索引
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,assign)NSInteger sum;
@end

#define FIRST_RECT CGRectMake(10, 64+10, SCREEN_WIDTH-10*2, SCREEN_HEIGHT-64-30-10*3)

@implementation DQReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self loadWordData];
    [self configUI];
    [self configNav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if ([[UIDevice currentDevice].systemVersion floatValue] > 7.0) {
        for (UIView * v in self.showViewArray) {
            v.frame = FIRST_RECT;
        }
    }
    [self.view layoutSubviews];
}

-(NSInteger)currentIndex{
    if (!_currentIndex) {
        _currentIndex = 0;
    }
    return _currentIndex;
}
-(NSMutableArray *)showViewArray{
    if (!_showViewArray) {
        _showViewArray = [[NSMutableArray alloc] init];
    }
    return _showViewArray;
}

#pragma mark -
#pragma mark initialize UI
-(void)configUI{
    self.view.backgroundColor = BG_COLOR;
    
    self.segment.momentary = YES;
    self.segment.selectedSegmentIndex = -1;
    
    for (NSInteger i = 0 ; i < 2 ; i++) {
        if (self.wordArray.count > i) {
            DQReviewItem * item = [[[NSBundle mainBundle] loadNibNamed:@"DQReviewItem" owner:nil options:nil] lastObject];
            item.frame = CGRectMake(10, 64+10, 355, 543);
            item.backgroundColor = [UIColor whiteColor];
            item.word = self.wordArray[i];
            item.index.text = [NSString stringWithFormat:@"%ld/%ld", i+1, self.sum];
            [self.view addSubview:item];
            [self.showViewArray addObject:item];
            self.index += 1;
        }
    }
    [self.view bringSubviewToFront:self.showViewArray.firstObject];
}

-(void)addItemInsertBack{
    DQReviewItem * item = [[[NSBundle mainBundle] loadNibNamed:@"DQReviewItem" owner:nil options:nil] lastObject];
    item.frame = FIRST_RECT;
    item.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:item belowSubview:self.showViewArray.lastObject];
    item.word = self.wordArray[self.currentIndex+1];
    item.index.text = [NSString stringWithFormat:@"%ld/%ld", self.index, self.sum];
    [self.showViewArray addObject:item];
    self.index += 1;
}

#pragma mark -
#pragma mark load data
-(void)loadWordData{
    self.wordArray = [NSMutableArray new];
    switch (self.state) {
        case WordStateUnfamiliar:
            self.wordArray = [NSMutableArray arrayWithArray:[Singleton shareInstance].firstArray];
            break;
        case WordStateCommon:
            self.wordArray = [NSMutableArray arrayWithArray:[Singleton shareInstance].secondArray];
            break;
        case WordStateProficiency:
            self.wordArray = [NSMutableArray arrayWithArray:[Singleton shareInstance].thirdArray];
            break;
        default:
            break;
    }
    //监测地址拷贝
//    NSLog(@"%p",self.wordArray);
//    NSLog(@"%p",[Singleton shareInstance].secondArray);
    
    self.index = 1;
    self.sum = self.wordArray.count;
}

#pragma mark -
#pragma mark initialize nav
-(void)configNav{
    self.navigationItem.title = @"复习检测";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"down30x30"] style:UIBarButtonItemStylePlain target:self action:@selector(reviewLeftClick)];
    
}

-(void)reviewLeftClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -
#pragma mark segment click
- (IBAction)segmentClick:(UISegmentedControl *)sender {
    [self removeAnimation:self.showViewArray.firstObject State:sender.selectedSegmentIndex];
}



-(void)removeAnimation:(DQReviewItem *)v State:(NSInteger)state{
//    CGPoint center = v.center;
//    center.x -= v.bounds.size.height/2.0/sqrt(2.0);
//    center.y += v.bounds.size.height/2.0*(1-1/sqrt(2.0));
    
    NSLog(@"1%@",self.wordArray);
    //保存单词状态
    Word * word = self.wordArray[self.currentIndex];
    [self moveWord:word State:state];
    NSLog(@"12%@",self.wordArray);
    
    [UIView animateWithDuration:0.4 animations:^{
        //根据熟悉度选择动画
        if (self.state == state) {
            v.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }else if (self.state < state){
            v.transform = CGAffineTransformMakeTranslation(SCREEN_WIDTH, 0);
        }else if (self.state > state){
            v.transform = CGAffineTransformMakeTranslation(-SCREEN_WIDTH, 0);
        }
        v.alpha = 0.0;
    } completion:^(BOOL finished) {
        //将视图移除
        [self.showViewArray removeObjectAtIndex:0];
        [v removeFromSuperview];
        //判断是否有下个
        if (self.currentIndex + 1 >= self.wordArray.count) {
            return ;
        }else{
            //判断状态是否改变
            if (self.state != state) {
                [self.wordArray removeObjectAtIndex:self.currentIndex];
            }else{
                self.currentIndex += 1;
            }
            //判断是否有下下个
            if (self.currentIndex + 1 < self.wordArray.count) {
                [self addItemInsertBack];
            }
        }
        NSLog(@"2:%@",self.wordArray);
    }];
}

#pragma mark -
#pragma mark 移动单词
-(void)moveWord:(Word*)model State:(NSInteger)state{
    if (model.state != state) {
        if (model.state == WordStateUnfamiliar) {
            [[Singleton shareInstance].firstArray removeObjectAtIndex:self.currentIndex];
        }else if (model.state == WordStateCommon){
            [[Singleton shareInstance].secondArray removeObjectAtIndex:self.currentIndex];
        }else if (model.state == WordStateProficiency){
            [[Singleton shareInstance].thirdArray removeObjectAtIndex:self.currentIndex];
        }
        model.state = state;
        [WordDao update:model];
        if (model.state == WordStateUnfamiliar) {
            [[Singleton shareInstance].firstArray insertObject:model atIndex:0];
        }else if (model.state == WordStateCommon){
            [[Singleton shareInstance].secondArray insertObject:model atIndex:0];
        }else if (model.state == WordStateProficiency){
            [[Singleton shareInstance].thirdArray insertObject:model atIndex:0];
        }
    }
}


@end
