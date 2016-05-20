//
//  DQSetViewController.m
//  LoveWords
//
//  Created by youdingquan on 16/4/20.
//  Copyright © 2016年 youdingquan. All rights reserved.
//

#import "DQSetViewController.h"

@interface DQSetViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property(nonatomic,strong)NSArray * listArray;/**<列表数组*/
@property(nonatomic,strong)NSArray * VCNameArray;/**<列表视图数组*/
@end

@implementation DQSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    [self loadData];
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UI
-(void)configUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    //表格视图
    self.table.tableFooterView = [UIView new];
}

#pragma mark -
#pragma mark load data
-(void)loadData{
    self.listArray = @[@[@"蓝牙"]];
    self.VCNameArray = @[@[@"DQCoreBloothViewController"]];
}

#pragma mark -
#pragma mark table delegate & datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identify = @"setcell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.textLabel.text = self.listArray[indexPath.section][indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController * vc = [[NSClassFromString(self.VCNameArray[indexPath.section][indexPath.row]) alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:NO];
    self.hidesBottomBarWhenPushed = NO;
}

@end
