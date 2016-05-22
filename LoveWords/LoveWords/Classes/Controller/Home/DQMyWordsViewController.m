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

#import "DQSearchViewController.h"
#import "DQReviewViewController.h"

@interface DQMyWordsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,DQAddWordDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property(nonatomic,strong)DQWordShowLayout * layout;
@property(nonatomic,assign)WordState currentState;
@property(nonatomic,strong)NSMutableArray * offsetArray;
@end

static NSString * const identify = @"mywordcollecyioncell";

@implementation DQMyWordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BG_COLOR;
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
    [self.myCollectionView reloadData];
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
-(void)setCurrentState:(WordState)currentState{
    _currentState = currentState;
    self.layout.currentState = currentState;
}

#pragma mark -
#pragma mark load data
-(void)loadData{
//    [Singleton shareInstance].firstArray = [WordDao findAtState:WordStateUnfamiliar];
//    [Singleton shareInstance].secondArray = [WordDao findAtState:WordStateCommon];
//    [Singleton shareInstance].thirdArray = [WordDao findAtState:WordStateProficiency];
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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search20x20"] style:UIBarButtonItemStylePlain target:self action:@selector(myWordsNavLeftClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"复习" style:UIBarButtonItemStylePlain target:self action:@selector(myWordsNavRightClick)];
}
-(void)myWordsNavLeftClick{
    DQSearchViewController * search = [[DQSearchViewController alloc] init];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:search];
    self.hidesBottomBarWhenPushed = YES;
    [self presentViewController:nav animated:NO completion:nil];
    self.hidesBottomBarWhenPushed = NO;
}
-(void)myWordsNavRightClick{
    [self choiceNeedReviewWord];
}

#pragma mark -
#pragma mark config collection
-(void)configCollection{
    self.layout = [[DQWordShowLayout alloc] init];
    [self.myCollectionView setCollectionViewLayout:self.layout];
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"DQWordCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:identify];
    self.myCollectionView.showsVerticalScrollIndicator = NO;
    self.myCollectionView.backgroundColor = BG_COLOR;
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
    [self addLongPressAtCell:cell];
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
#pragma mark long press
-(void)addLongPressAtCell:(DQWordCollectionViewCell*)cell{
    UILongPressGestureRecognizer * longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(myWordLongPress:)];
    cell.userInteractionEnabled = YES;
    [cell addGestureRecognizer:longpress];
}
-(void)myWordLongPress:(UILongPressGestureRecognizer*)longpress{
    DQWordCollectionViewCell * cell = (DQWordCollectionViewCell *)longpress.view;
    Word * model = cell.model;
    NSIndexPath * indexpath = [self.myCollectionView indexPathForCell:cell];
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"" message:@"是否删除该单词？" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.currentState == WordStateUnfamiliar) {
            [[Singleton shareInstance].firstArray removeObjectAtIndex:indexpath.row];
        }else if (self.currentState == WordStateCommon) {
            [[Singleton shareInstance].secondArray removeObjectAtIndex:indexpath.row];
        }else if (self.currentState == WordStateProficiency) {
            [[Singleton shareInstance].thirdArray removeObjectAtIndex:indexpath.row];
        }
        [WordDao deleteWith:model];
        [self.myCollectionView deleteItemsAtIndexPaths:@[indexpath]];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -
#pragma mark addWord delegate
-(void)addWordCompleted{
    [self beginRefresh];
}


#pragma mark -
#pragma mark review myWord
-(void)choiceNeedReviewWord{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"请选择要复习的单词类型" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"陌生" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self intoReviewWithState:WordStateUnfamiliar];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"一般" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self intoReviewWithState:WordStateCommon];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"熟悉" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self intoReviewWithState:WordStateProficiency];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)intoReviewWithState:(NSInteger)state{
    DQReviewViewController * review = [[DQReviewViewController alloc] init];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:review];
    review.state = state;
    self.hidesBottomBarWhenPushed = YES;
    [self presentViewController:nav animated:NO completion:nil];
    self.hidesBottomBarWhenPushed = NO;
}

@end
