//
//  DQHomeViewController.m
//  LoveWords
//
//  Created by youdingquan on 16/4/20.
//  Copyright © 2016年 youdingquan. All rights reserved.
//

#import "DQHomeViewController.h"
#import "DQMyWordsViewController.h"
#import "DQSetViewController.h"
#import "DQAddWordViewController.h"

@interface DQHomeViewController ()<UITabBarControllerDelegate,DQAddWordDelegate>
@property(nonatomic,strong)NSArray * listArray;
@property(nonatomic,strong)NSArray * VCArray;
@end

@implementation DQHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self configTabbar];
    [self configVCsItem];
    [self configAdd];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark loadData
-(void)loadData{
    self.listArray = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"list" ofType:@"plist"]] objectForKey:@"home"];
}

#pragma mark -
#pragma mark set tabbarItem
-(void)configTabbar{
    self.delegate = self;
    DQMyWordsViewController * myWords = [[DQMyWordsViewController alloc] init];
    DQSetViewController * set = [[DQSetViewController alloc] init];
    self.VCArray = @[myWords,[UIViewController new],set];
    [self setViewControllers:@[[[UINavigationController alloc] initWithRootViewController:self.VCArray[0]],self.VCArray[1],[[UINavigationController alloc] initWithRootViewController:self.VCArray[2]]]];
}

#pragma mark -
#pragma mark add "+" button
-(void)configAdd{
    CGFloat height = self.tabBar.bounds.size.height;
    UIButton * add = [UIButton buttonWithType:UIButtonTypeCustom];
    add.frame = CGRectMake((375-height-10)/2.0, 5, height-10, height-10);
    add.layer.cornerRadius = (height-10)/2.0;
    add.layer.masksToBounds = YES;
    add.contentMode = UIViewContentModeScaleToFill;
    [add setImage:[UIImage imageNamed:@"add40x40"] forState:UIControlStateNormal];
    [self.tabBar addSubview:add];
    [add addTarget:self action:@selector(homeAddButtonClick) forControlEvents:UIControlEventTouchUpInside];
}
-(void)homeAddButtonClick{
    DQAddWordViewController * add = [[DQAddWordViewController alloc] init];
    add.delegate = self;
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:add];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)addWordCompleted{
    DQMyWordsViewController * vc = self.VCArray[0];
    [vc beginRefresh];
    NSLog(@"complete");
}

#pragma mark -
#pragma mark set viewcontrollers item
-(void)configVCsItem{
    NSArray * vcArray = self.viewControllers;
    for (int i = 0 ; i < self.listArray.count; i++) {
        UINavigationController * vc = vcArray[i];
        [vc.tabBarItem setTitle:self.listArray[i]];
        [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
        [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
    }
}

#pragma mark -
#pragma mark delegate
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if (viewController.tabBarItem.title.length <= 0) {
        return NO;
    }
    return YES;
}

@end
