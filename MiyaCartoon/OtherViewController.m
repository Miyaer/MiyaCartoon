//
//  OtherViewController.m
//  MiyaCartoon
//
//  Created by miya on 16/6/13.
//  Copyright © 2016年 miya. All rights reserved.
//

#import "OtherViewController.h"
#import "AFNetworking.h"
#import "CartoonCell.h"
#import "CartoonJson.h"
#import "MJRefresh.h"
#import "DetailViewController.h"
#import "HDManager.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "AppDelegate.h"
@interface OtherViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) MBProgressHUD *HDView;
@property (nonatomic,strong) UITableView * myTable;
@property (nonatomic,strong) NSMutableArray * dataSorce;
@property (nonatomic,strong) AFHTTPSessionManager * manager;
@property (nonatomic,assign) int page;
@end

@implementation OtherViewController
- (void)viewWillAppear:(BOOL)animated{
    UIApplication * application = [UIApplication sharedApplication];
    AppDelegate * delegate = application.delegate;
    self.view.backgroundColor = delegate.blackColor;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _page=1;
    [self loadData];
    [self createNav];
    self.navigationItem.title = self.mytitle;
    [self.view addSubview:self.myTable];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
}

- (void)createNav{
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,BTNSIZE,BTNHEIGHT)];
    [btn setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}
-(void)btnClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 加载数据
- (void)loadData{
    if (_page == 1) {
        [self.dataSorce removeAllObjects];
        
    }
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    if ([reach currentReachabilityStatus]== NotReachable){
        [HDManager stopLoading];
    }else{
        [HDManager startLoading];
        [self.manager GET:[NSString stringWithFormat:self.url,_page] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSArray * array = dict[@"results"];
            JSONModelArray * jsArr = [[JSONModelArray alloc]initWithArray:array modelClass:[CartoonJson class]];
            for (CartoonJson * cjs in jsArr) {
                [self.dataSorce addObject:cjs];
            }
            
            if (_page==1) {
                [self.myTable.header endRefreshing];
            }else{
                [self.myTable.footer endRefreshing];
            }
            
            [HDManager stopLoading];
            [self.myTable reloadData];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求数据失败");
        }];
    }
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSorce count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CartoonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CartoonJson * cjs = self.dataSorce[indexPath.row];
    [cell showInfoModel:cjs];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController * dvc = [[DetailViewController alloc]init];
    CartoonJson * cjs = self.dataSorce[indexPath.row];
    dvc.urlId = cjs.cartoonId;
    dvc.imageName = cjs.images;
    dvc.cjs = cjs;
    dvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dvc animated:YES];
}

#pragma mark - 懒加载
- (AFHTTPSessionManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _manager;
}
- (UITableView *)myTable{
    if (!_myTable) {
        _myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-44) style:UITableViewStylePlain];
        _myTable.delegate = self;
        _myTable.dataSource = self;
        _myTable.showsHorizontalScrollIndicator = NO;
        _myTable.showsVerticalScrollIndicator = NO;
        // _myTable.bounces = NO;
        _myTable.backgroundColor = [UIColor clearColor];
        [_myTable registerNib:[UINib nibWithNibName:@"CartoonCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        
        _myTable.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page = 1;
            [self loadData];
            
        }];
        _myTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page++;
            [self loadData];
            
        }];
        
        
        
    }
    return _myTable;
}
- (NSMutableArray *)dataSorce{
    if (!_dataSorce) {
        _dataSorce = [[NSMutableArray alloc]init];
        
    }
    return _dataSorce;
}
-(MBProgressHUD *)HDView
{
    if (!_HDView) {
        _HDView = [[MBProgressHUD alloc]initWithView:self.view];
        _HDView.labelText = @"正在加载...";
    }
    return _HDView;
}

@end
