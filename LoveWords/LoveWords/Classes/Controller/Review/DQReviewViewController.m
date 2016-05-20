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

@interface DQReviewViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property(nonatomic,strong)NSMutableArray * showViewArray;
@property(nonatomic,strong)DQReviewItem * firstView;
@property(nonatomic,strong)DQReviewItem * secondView;

@property(nonatomic,assign)NSInteger currentIndex;
@end

#define FIRST_RECT CGRectMake(10, 64+10, SCREEN_WIDTH-10*2, SCREEN_HEIGHT-64*2-40-20-10*2)
#define SECOND_RECT CGRectMake(10+5, 64+10+5, SCREEN_WIDTH-10*2-5*2, SCREEN_HEIGHT-64*2-40-20-10*2)

@implementation DQReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self configUI];
    [self configNav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)currentIndex{
    if (!_currentIndex) {
        _currentIndex = 0;
    }
    return _currentIndex;
}

#pragma mark -
#pragma mark initialize UI
-(void)configUI{
    self.view.backgroundColor = [UIColor blueColor];
    
    self.segment.momentary = YES;
    self.segment.selectedSegmentIndex = -1;
    
    DQReviewItem * item1 = [[[NSBundle mainBundle] loadNibNamed:@"DQReviewItem" owner:nil options:nil] lastObject];
    item1.frame = FIRST_RECT;
    item1.backgroundColor = [UIColor whiteColor];
    
    DQReviewItem * item2 = [[[NSBundle mainBundle] loadNibNamed:@"DQReviewItem" owner:nil options:nil] lastObject];
    item2.frame = FIRST_RECT;
    item2.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:item2];
    [self.view addSubview:item1];
    
    item1.index.text = @"2/6";
    item2.index.text = @"3/6";
    
    self.showViewArray = [NSMutableArray arrayWithArray:@[item1,item2]];
    
    [self loadWordData];
}

-(void)addItemInsertBack{
    DQReviewItem * item2 = [[[NSBundle mainBundle] loadNibNamed:@"DQReviewItem" owner:nil options:nil] lastObject];
    item2.frame = FIRST_RECT;
    item2.backgroundColor = [UIColor whiteColor];
    
    [self.view insertSubview:item2 belowSubview:self.showViewArray.lastObject];
    
    item2.index.text = @"3/6";
    
    [self.showViewArray addObject:item2];
}

#pragma mark -
#pragma mark load data
-(void)loadWordData{
    Word * firstWord = [[Word alloc] init];
    Word * secondWord = [[Word alloc] init];
    switch (self.state) {
        case WordStateUnfamiliar:
            firstWord = [Singleton shareInstance].firstArray[self.currentIndex];
            secondWord = [Singleton shareInstance].firstArray[self.currentIndex+1];
            break;
        case WordStateCommon:
            firstWord = [Singleton shareInstance].secondArray[self.currentIndex];
            secondWord = [Singleton shareInstance].secondArray[self.currentIndex+1];
            break;
        case WordStateProficiency:
            firstWord = [Singleton shareInstance].thirdArray[self.currentIndex];
            secondWord = [Singleton shareInstance].thirdArray[self.currentIndex+1];
            break;
        default:
            break;
    }
    for (int i = 0 ; i < 2; i++) {
        DQReviewItem * item = self.showViewArray[i];
        item.word = i==0 ? firstWord:secondWord;
    }
}

#pragma mark -
#pragma mark initialize nav
-(void)configNav{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"复习检测";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"down30x30"] style:UIBarButtonItemStylePlain target:self action:@selector(reviewLeftClick)];
    
}

-(void)reviewLeftClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -
#pragma mark segment click
- (IBAction)segmentClick:(UISegmentedControl *)sender {
//    NSInteger count = self.view.subviews.count-1;
//    DQReviewItem * v = self.view.subviews[count];
    [self removeAnimation:self.showViewArray.firstObject];
//    NSLog(@"end");
}



-(void)removeAnimation:(DQReviewItem *)v{
    [self addItemInsertBack];
    
    CGPoint center = v.center;
    center.x -= v.bounds.size.height/2.0/sqrt(2.0);
    center.y += v.bounds.size.height/2.0*(1-1/sqrt(2.0));
    [UIView animateWithDuration:0.4 animations:^{
        v.center = center;
        v.transform = CGAffineTransformMakeRotation(-M_PI_4);
        v.alpha = 0;
    } completion:^(BOOL finished) {
        [v removeFromSuperview];
        [self.showViewArray removeObjectAtIndex:0];
    }];
    
//    [UIView animateKeyframesWithDuration:1.7 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
//        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.3 animations:^{
//            v.center = center;
//            v.transform = CGAffineTransformMakeRotation(-M_PI_4);
//            v.alpha = 0;
//        }];
//        [UIView addKeyframeWithRelativeStartTime:0.3 relativeDuration:0.0 animations:^{
//            v.center = self.secondView.center;
//            v.bounds = self.secondView.bounds;
//            v.transform = CGAffineTransformMakeRotation(0);
//            v.word = self.secondView.word;
//            v.index.text = self.secondView.index.text;
//            v.alpha = 1;
//        }];
//        [UIView addKeyframeWithRelativeStartTime:0.3 relativeDuration:0.6 animations:^{
//        }];
//        [UIView addKeyframeWithRelativeStartTime:0.9 relativeDuration:0.1 animations:^{
//            v.bounds = CGRectMake(0, 0, v.bounds.size.width+2*5, v.bounds.size.height);
//            v.center = CGPointMake(v.center.x, v.center.y-5);
//            
//        }];
//    } completion:^(BOOL finished) {
//        
//    }];
    
//    // 平移动画
//    CABasicAnimation *a1 = [CABasicAnimation animation];
//    a1.keyPath = @"transform.translation.y";
//    a1.toValue = @(v.bounds.size.height/2.0*(1-1/sqrt(2.0)));
//    // 缩放动画
//    CABasicAnimation *a2 = [CABasicAnimation animation];
//    a2.keyPath = @"transform.translation.x";
//    a2.toValue = @(-v.bounds.size.height/2.0/sqrt(2.0));
//    // 旋转动画
//    CABasicAnimation *a3 = [CABasicAnimation animation];
//    a3.keyPath = @"transform.rotation";
//    a3.toValue = @(-M_PI_4);
//    // 渐变动画
//    CABasicAnimation *a4 = [CABasicAnimation animation];
//    a4.keyPath = @"transform.alpha";
//    a4.toValue = @(0);
//    
//    // 组动画
//    CAAnimationGroup *groupAnima = [CAAnimationGroup animation];
//    
//    groupAnima.animations = @[a1, a2, a3, a4];
//    
//    //设置组动画的时间
//    groupAnima.duration = 0.4;
//    groupAnima.fillMode = kCAFillModeForwards;
//    groupAnima.removedOnCompletion = NO;
//    groupAnima.delegate = self;
//    
//    [v.layer addAnimation:groupAnima forKey:nil];
}



@end
