//
//  DQAddWordViewController.m
//  LoveWords
//
//  Created by youdingquan on 16/4/21.
//  Copyright © 2016年 youdingquan. All rights reserved.
//

#import "DQAddWordViewController.h"
#import "Word.h"
#import "WordDao.h"

@interface DQAddWordViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *name;
@property (weak, nonatomic) IBOutlet UITextView *paraphrase;
@property(nonatomic,strong)UISegmentedControl * segment;
@end

@implementation DQAddWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configUI];
    [self configNavBar];
    [self configNavItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark config UI
-(void)configUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.name.layer.cornerRadius = 5;
    self.name.layer.masksToBounds = YES;
    self.paraphrase.layer.cornerRadius = 5;
    self.paraphrase.layer.masksToBounds = YES;
    
    if (self.state != AddWordStateAdd) {
        self.name.editable = NO;
        self.name.text = self.model.name;
        self.paraphrase.text = self.model.paraphrase;
    }
}

#pragma mark -
#pragma mark set navigationbar
-(void)configNavBar{
    UISegmentedControl * segment = [[UISegmentedControl alloc] initWithItems:@[@"陌生",@"一般",@"熟练"]];
    segment.bounds = CGRectMake(0, 0, 150, 34);
    if (self.state == AddWordStateAdd) {
        segment.selectedSegmentIndex = 0;
    }else{
        segment.selectedSegmentIndex = self.model.state;
    }
    [segment addTarget:self action:@selector(addWordSegmentValueChange:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segment;
    self.segment = segment;
}
-(void)addWordSegmentValueChange:(UISegmentedControl*)segment{
    if (self.state == AddWordStateAdd) {
        
    }else if (self.state == AddWordStateEdit){
//        self.model.state = segment.selectedSegmentIndex;
    }
}

#pragma mark -
#pragma mark set navigationitem
-(void)configNavItem{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(addWordLeftClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(addWordRightClick)];
}
-(void)addWordLeftClick{
    if ([self.name isFirstResponder]) {
        [self.name resignFirstResponder];
    }
    if ([self.paraphrase isFirstResponder]) {
        [self.paraphrase resignFirstResponder];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)addWordRightClick{
    if (self.name.text.length > 0 && self.paraphrase.text.length > 0) {
        Word * word = [[Word alloc] init];
        word.name = self.name.text;
        word.paraphrase = self.paraphrase.text;
        if (self.state == AddWordStateAdd) {
            word.state = self.segment.selectedSegmentIndex;
            word.addDate = [NSDate stringByNowDate];
            [WordDao save:word];
            [self intoArrayByWord:word];
        }else{
            if (!([word.name isEqualToString:self.model.name] && [word.paraphrase isEqualToString:self.model.paraphrase]) || self.model.state != self.segment.selectedSegmentIndex) {
                [self moveArrayWithWord:self.model];
            }
        }
        [self.delegate addWordCompleted];
        [self addWordLeftClick];
    }
}

#pragma mark -
#pragma mark add model into array
-(void)intoArrayByWord:(Word*)model{
    if (self.segment.selectedSegmentIndex == WordStateUnfamiliar) {
        [[Singleton shareInstance].firstArray insertObject:model atIndex:0];
    }else if (self.segment.selectedSegmentIndex == WordStateCommon){
        [[Singleton shareInstance].secondArray insertObject:model atIndex:0];
    }else if (self.segment.selectedSegmentIndex == WordStateProficiency){
        [[Singleton shareInstance].thirdArray insertObject:model atIndex:0];
    }
}
-(void)moveArrayWithWord:(Word*)model{
    if (model.state == WordStateUnfamiliar) {
        [[Singleton shareInstance].firstArray removeObjectAtIndex:self.modifyIndex];
    }else if (model.state == WordStateCommon){
        [[Singleton shareInstance].secondArray removeObjectAtIndex:self.modifyIndex];
    }else if (model.state == WordStateProficiency){
        [[Singleton shareInstance].thirdArray removeObjectAtIndex:self.modifyIndex];
    }
    model.paraphrase = self.paraphrase.text;
    model.addDate = [NSDate stringByNowDate];
    model.state = self.segment.selectedSegmentIndex;
    [WordDao update:model];
    if (model.state == WordStateUnfamiliar) {
        [[Singleton shareInstance].firstArray insertObject:model atIndex:0];
    }else if (model.state == WordStateCommon){
        [[Singleton shareInstance].secondArray insertObject:model atIndex:0];
    }else if (model.state == WordStateProficiency){
        [[Singleton shareInstance].thirdArray insertObject:model atIndex:0];
    }
}

@end
