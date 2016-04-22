//
//  DQMyWordsViewController.m
//  LoveWords
//
//  Created by youdingquan on 16/4/20.
//  Copyright © 2016年 youdingquan. All rights reserved.
//

#import "DQMyWordsViewController.h"
#import "DQTitleChoiceView.h"
#import "DQWordShowLayout.h"
#import "DQWordCollectionViewCell.h"

#import "DQAddWordViewController.h"

#import "Word.h"
#import "WordDao.h"

@interface DQMyWordsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,DQAddWordDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property(nonatomic,assign)WordState currentState;
@property(nonatomic,strong)NSMutableArray * offsetArray;
@end

static NSString * const identify = @"mywordcollecyioncell";

@implementation DQMyWordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self loadData];
    [self configTitleView];
    [self configNavItem];
    [self configCollection];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addKVO];
}
-(void)dealloc{
    [self removeKVO];
}

-(NSMutableArray *)offsetArray{
    if (!_offsetArray) {
        _offsetArray = [NSMutableArray arrayWithArray:@[@0,@0,@0]];
    }
    return _offsetArray;
}

#pragma mark -
#pragma mark load data
-(void)loadData{
    [Singleton shareInstance].firstArray = [WordDao findAtState:WordStateUnfamiliar];
    [Singleton shareInstance].secondArray = [WordDao findAtState:WordStateCommon];
    [Singleton shareInstance].thirdArray = [WordDao findAtState:WordStateProficiency];
}
-(void)beginRefresh{
    [self.myCollectionView reloadData];
}

#pragma mark -
#pragma mark config navigationbar
-(void)configTitleView{
    DQTitleChoiceView * v = [[NSBundle mainBundle] loadNibNamed:@"DQTitleChoiceView" owner:nil options:nil].lastObject;
    v.frame = CGRectMake(0, 0, 375, 44);
    self.currentState = WordStateUnfamiliar;
    __block DQMyWordsViewController * blockSelf = self;
    v.block = ^(WordState state){
        blockSelf.currentState = state;
        [blockSelf beginRefresh];
        blockSelf.myCollectionView.contentOffset = CGPointMake(0, [self.offsetArray[state] floatValue]);
    };
    self.navigationItem.titleView = v;
}

-(void)configNavItem{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search32x32"] style:UIBarButtonItemStylePlain target:self action:@selector(myWordsNavLeftClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"复习" style:UIBarButtonItemStylePlain target:self action:@selector(myWordsNavRightClick)];
}

#pragma mark -
#pragma mark config collection
-(void)configCollection{
    DQWordShowLayout * layout = [[DQWordShowLayout alloc] init];
    [self.myCollectionView setCollectionViewLayout:layout];
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"DQWordCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:identify];
    self.myCollectionView.showsVerticalScrollIndicator = NO;
    self.myCollectionView.backgroundColor = [UIColor grayColor];
}

#pragma mark add collection kvo
-(void)addKVO{
    [self.myCollectionView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}
-(void)removeKVO{
    [self.myCollectionView removeObserver:self forKeyPath:@"contentOffset"];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([object isEqual:self.myCollectionView]) {
        if ([keyPath isEqualToString:@"contentOffset"]) {
            CGPoint point = [change[@"new"] CGPointValue];
            if (self.currentState == WordStateUnfamiliar) {
                self.offsetArray[WordStateUnfamiliar] = @(point.y);
            }else if (self.currentState == WordStateCommon) {
                self.offsetArray[WordStateCommon] = @(point.y);
            }else if (self.currentState == WordStateProficiency) {
                self.offsetArray[WordStateProficiency] = @(point.y);
            }
        }
    }
}


#pragma mark -
#pragma mark collection delegate and datasource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.currentState == WordStateUnfamiliar) {
        return [Singleton shareInstance].firstArray.count;
    }else if (self.currentState == WordStateCommon) {
        return [Singleton shareInstance].secondArray.count;
    }else if (self.currentState == WordStateProficiency) {
        return [Singleton shareInstance].thirdArray.count;
    }
    return 0;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DQWordCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    Word * model = [[Word alloc] init];
    if (self.currentState == WordStateUnfamiliar) {
        model = [Singleton shareInstance].firstArray[indexPath.row];
    }else if (self.currentState == WordStateCommon) {
        model = [Singleton shareInstance].secondArray[indexPath.row];
    }else if (self.currentState == WordStateProficiency) {
        model = [Singleton shareInstance].thirdArray[indexPath.row];
    }
    cell.model = model;
    cell.layer.cornerRadius = 5;
    cell.layer.masksToBounds = YES;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DQWordCollectionViewCell * cell = (DQWordCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    Word * model = cell.model;
    DQAddWordViewController * addWord = [[DQAddWordViewController alloc] init];
    addWord.state = AddWordStateEdit;
    addWord.model = model;
    addWord.modifyIndex = indexPath.row;
    addWord.delegate = self;
    [self presentViewController:[[UINavigationController alloc]initWithRootViewController:addWord] animated:NO completion:nil];
}


#pragma mark -
#pragma mark addWord delegate
-(void)addWordCompleted{
    [self beginRefresh];
}


@end
