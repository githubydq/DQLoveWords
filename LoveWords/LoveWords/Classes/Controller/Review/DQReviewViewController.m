//
//  DQReviewViewController.m
//  LoveWords
//
//  Created by youdingquan on 16/4/24.
//  Copyright © 2016年 youdingquan. All rights reserved.
//

#import "DQReviewViewController.h"
#import "DQReviewItem.h"

@interface DQReviewViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property(nonatomic,strong)DQReviewItem * firstView;
@property(nonatomic,strong)DQReviewItem * secondView;
@end

@implementation DQReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configUI];
    [self configNav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark initialize UI
-(void)configUI{
    self.view.backgroundColor = [UIColor blueColor];
    
    self.segment.momentary = YES;
    self.segment.selectedSegmentIndex = -1;
    
    
    self.firstView = [[[NSBundle mainBundle] loadNibNamed:@"DQReviewItem" owner:nil options:nil] lastObject];
    self.firstView.frame = CGRectMake(10, 64+10, SCREEN_WIDTH-10*2, SCREEN_HEIGHT-64*2-40-20-10*2);
    self.firstView.backgroundColor = [UIColor whiteColor];
    
    self.secondView = [[[NSBundle mainBundle] loadNibNamed:@"DQReviewItem" owner:nil options:nil] lastObject];
    self.secondView.frame = CGRectMake(10+5, 64+10+5, SCREEN_WIDTH-10*2-5*2, SCREEN_HEIGHT-64*2-40-20-10*2);
    self.secondView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.secondView];
    [self.view addSubview:self.firstView];
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
    NSInteger count = self.view.subviews.count-1;
    DQReviewItem * v = self.view.subviews[count];
    [self removeAnimation:v];
    NSLog(@"end");
}

-(void)removeAnimation:(UIView *)v{
    // 平移动画
    CABasicAnimation *a1 = [CABasicAnimation animation];
    a1.keyPath = @"transform.translation.y";
    a1.toValue = @(v.bounds.size.height/2.0*(1-1/sqrt(2.0)));
    // 缩放动画
    CABasicAnimation *a2 = [CABasicAnimation animation];
    a2.keyPath = @"transform.translation.x";
    a2.toValue = @(-v.bounds.size.height/2.0/sqrt(2.0));
    // 旋转动画
    CABasicAnimation *a3 = [CABasicAnimation animation];
    a3.keyPath = @"transform.rotation";
    a3.toValue = @(-M_PI_4);
    
    // 组动画
    CAAnimationGroup *groupAnima = [CAAnimationGroup animation];
    
    groupAnima.animations = @[a1, a2, a3];
    
    //设置组动画的时间
    groupAnima.duration = 0.4;
    groupAnima.fillMode = kCAFillModeForwards;
    groupAnima.removedOnCompletion = YES;
    
    [v.layer addAnimation:groupAnima forKey:nil];
}


@end
