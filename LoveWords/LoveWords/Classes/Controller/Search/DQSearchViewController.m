//
//  DQSearchViewController.m
//  LoveWords
//
//  Created by youdingquan on 16/4/22.
//  Copyright © 2016年 youdingquan. All rights reserved.
//

#import "DQSearchViewController.h"
#import "Word.h"
#import "WordDao.h"

@interface DQSearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UISearchBar * search;
@property(nonatomic,strong)UIButton * cancel;

@property (weak, nonatomic) IBOutlet UITableView *myTable;
@property(nonatomic,strong)NSMutableArray * modelArray;

@end

@implementation DQSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self configSearch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray *)modelArray{
    if (!_modelArray) {
        _modelArray = [[NSMutableArray alloc] init];
    }
    return _modelArray;
}

#pragma mark -
#pragma mark config searchBar
-(void)configSearch{
    self.cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancel.frame = CGRectMake(SCREEN_WIDTH-44-5, 0, 44, 44);
    [self.cancel setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancel setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.cancel addTarget:self action:@selector(searchCancelClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:self.cancel];
    
    self.search = [[UISearchBar alloc] init];
    self.search.barStyle = UIBarStyleBlackOpaque;
    self.search.placeholder = @"搜索";
    self.search.delegate = self;
    self.search.frame = CGRectMake(5, 0, SCREEN_WIDTH-self.cancel.frame.size.width-5-10, 44);
    [self.navigationController.navigationBar addSubview:self.search];
}

-(void)searchCancelClick:(UIButton*)btn{
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark -
#pragma mark search delegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    self.modelArray = [WordDao findContainString:searchText];
    [self.myTable reloadData];
}

#pragma mark -
#pragma mark table delegate and datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identify = @"searchcell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
    }
    Word * model = self.modelArray[indexPath.row];
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.paraphrase;
    return cell;
}
@end
