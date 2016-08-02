//
//  SerchViewController.m
//  MiyaCartoon
//
//  Created by miya on 16/6/14.
//  Copyright © 2016年 miya. All rights reserved.
//

#import "SerchViewController.h"
#import "AFNetworking.h"
#import "CartoonCell.h"
#import "CartoonJson.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "DetailViewController.h"
@interface SerchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating>
{
    UISearchController * searchCtr;
}
@property (nonatomic,strong) UITableView * myTable;
@property (nonatomic,strong) NSMutableArray * dataSorce;
@property (nonatomic,strong) AFHTTPSessionManager * manager;
@end

@implementation SerchViewController
-(void)viewWillAppear:(BOOL)animated{
    UIApplication * application = [UIApplication sharedApplication];
    AppDelegate * delegate = application.delegate;
    self.view.backgroundColor = delegate.blackColor;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:1.00 green:0.67 blue:0.57 alpha:1.00];
    [self.view addSubview:self.myTable];
    [self createNav];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

- (void)createNav{
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, BTNSIZE, BTNHEIGHT)];
    [btn setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}
-(void)btnClick:(UIButton *)btn{
    [searchCtr resignFirstResponder];
    searchCtr.active = NO;
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 加载数据
-(NSString *)unicodeWithString:(NSString *)string
{
    //对URL中的请求参数进行编码
    NSString *unicodeStr =[string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return unicodeStr;
    
}

#pragma mark - 搜索代理
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    //<1>获取搜索框中输入的内容
    NSString * content = searchCtr.searchBar.text;
    [self.dataSorce removeAllObjects];
    NSString * url = [NSString stringWithFormat:SS_URL,[self unicodeWithString:content]];
    [self loadData:url];
    [self.myTable reloadData];
}
//- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
//{
//    [searchCtr resignFirstResponder];
//}
#pragma mark - 加载数据
- (void)loadData:(NSString *)url{
    //http://api.playsm.com/index.php?size=9&r=cartoonSet/list&page=1&searchName=%@&
    
    [self.manager GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray * array = dict[@"results"];
        JSONModelArray * jsArr = [[JSONModelArray alloc]initWithArray:array modelClass:[CartoonJson class]];
        for (CartoonJson * cjs in jsArr) {
            [self.dataSorce addObject:cjs];
        }
        
        [self.myTable reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求数据失败");
    }];
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
    CartoonJson * cjs = self.dataSorce[indexPath.row];
    [cell showInfoModel:cjs];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController * dvc = [[DetailViewController alloc]init];
    CartoonJson * cjs = self.dataSorce[indexPath.row];
    dvc.urlId = cjs.cartoonId;
    dvc.imageName = cjs.images;
    dvc.cjs = cjs;
    dvc.hidesBottomBarWhenPushed = YES;
    searchCtr.active = NO;
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
        _myTable.backgroundColor = [UIColor clearColor];
        // _myTable.bounces = NO;
        _myTable.tableHeaderView.frame = CGRectMake(0, 0, WIDTH, 40);
        [_myTable registerNib:[UINib nibWithNibName:@"CartoonCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        //<3>添加搜索框
        searchCtr = [[UISearchController alloc]initWithSearchResultsController:nil];
        
        //取消搜索视图上的黑色背景
        searchCtr.dimsBackgroundDuringPresentation = NO;
        //设置搜索框中字母的大小写
        searchCtr.searchBar.autocapitalizationType = UITextAutocapitalizationTypeWords;
        searchCtr.hidesNavigationBarDuringPresentation = NO;
        
        searchCtr.searchResultsUpdater = self;
        //添加到表格的头视图上
        _myTable.tableHeaderView = searchCtr.searchBar;
        
        
        
        
    }
    return _myTable;
}
- (NSMutableArray *)dataSorce{
    if (!_dataSorce) {
        _dataSorce = [[NSMutableArray alloc]init];
        
    }
    return _dataSorce;
}

@end
