//
//  CartoonViewController.m
//  MiyaCartoon
//
//  Created by miya on 16/6/14.
//  Copyright © 2016年 miya. All rights reserved.
//

#import "CartoonViewController.h"
#import "DcarCell.h"
#import "DcartJson.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "LCDownloadManager.h"
#import "HDManager.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "AppDelegate.h"
@interface CartoonViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) MBProgressHUD *HDView;
@property (nonatomic,strong) UITableView * myTable;
@property (nonatomic,strong) NSMutableArray * dataSorce;
@property (nonatomic,strong) AFHTTPSessionManager * manager;
@property (nonatomic,strong) AFHTTPRequestOperation * operation;
@end

@implementation CartoonViewController
-(void)viewWillAppear:(BOOL)animated{
    UIApplication * application = [UIApplication sharedApplication];
    AppDelegate * delegate = application.delegate;
    self.view.backgroundColor = delegate.blackColor;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // _page = 1;
    [self createNav];
    [self loadData];
    [self.view addSubview:self.myTable];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // Do any additional setup after loading the view.
}

- (void)createNav{
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, BTNSIZE, BTNHEIGHT)];
    [btn setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    
    
}
-(void)btnClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)loadData{
    [HDManager startLoading];
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    if ([reach currentReachabilityStatus]== NotReachable){
        [HDManager stopLoading];
    }else{
        [self.manager GET:[NSString stringWithFormat:LOOK_URL,self.cartoonID] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            NSArray * array = dict[@"results"];
            
            JSONModelArray * jsArr = [[JSONModelArray alloc]initWithArray:array modelClass:[DcartJson class]];
            for (DcartJson * dj in jsArr) {
                [self.dataSorce addObject:dj];
            }
            
            
            [HDManager stopLoading];
            [self.myTable reloadData];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求数据失败");
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSorce count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DcarCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    DcartJson * js = self.dataSorce[indexPath.row];
    [cell.myImage sd_setImageWithURL:[NSURL URLWithString:js.images]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DcartJson * js = self.dataSorce[indexPath.row];
    return [js.imgHeight intValue];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"%@ %@",self.cartoonName,self.numberName];
}
#pragma mark - 懒加载
- (UITableView *)myTable{
    if (!_myTable) {
        _myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) style:UITableViewStylePlain];
        _myTable.delegate =self;
        _myTable.dataSource = self;
        _myTable.backgroundColor = [UIColor clearColor];
        //    _myTable.bounces = NO;
        [_myTable registerNib:[UINib nibWithNibName:@"DcarCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        
    }
    return _myTable;
}
- (NSMutableArray *)dataSorce{
    if (!_dataSorce) {
        _dataSorce = [[NSMutableArray alloc]init];
    }
    return _dataSorce;
}
- (AFHTTPSessionManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _manager;
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
