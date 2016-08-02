//
//  MainViewController.m
//  MiyaCartoon
//
//  Created by miya on 16/6/13.
//  Copyright © 2016年 miya. All rights reserved.
//

#import "MainViewController.h"
#import "AFNetworking.h"
#import "XTADScrollView.h"
#import "CartoonJson.h"
#import "TypeCell.h"
#import "OtherViewController.h"
#import "DetailViewController.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "PartCell.h"
#import "SerchViewController.h"
#import "FMDBManager.h"
#import "Reachability.h"
#import "CollectionFMDB.h"
#import "MBProgressHUD.h"
#import "HDManager.h"
#import "AppDelegate.h"
@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UIView * view;
}
@property (nonatomic,strong) MBProgressHUD * HDView;
@property (nonatomic,strong) UITableView * myTable;
@property (nonatomic,strong) NSMutableArray * dataSorce;
@property (nonatomic,strong) UICollectionView * collectionView;
@property (nonatomic,strong) XTADScrollView * scrollView;
@property (nonatomic,strong) AFHTTPSessionManager * manager;
@property (nonatomic,assign) int page;
@property (nonatomic,strong) NSMutableArray * imageArr;
@end

@implementation MainViewController
-(void)viewWillAppear:(BOOL)animated{
    UIApplication * application = [UIApplication sharedApplication];
    AppDelegate * delegate = application.delegate;
    self.view.backgroundColor = delegate.blackColor;
    view.backgroundColor = delegate.blackColor;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [FMDBManager createTable];
    [CollectionFMDB createTable];
    [self createNav];
    _page = 1;
    [self loadData];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self headerView];
    [self.view addSubview:self.myTable];
    // Do any additional setup after loading the view.
}
- (void)createNav{
    
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}
- (void)itemClick:(UIButton *)btn{
    SerchViewController * svc = [[SerchViewController alloc]init];
    [self.navigationController pushViewController:svc animated:YES];
}
- (void)headerView{
    view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 341)];
    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor clearColor];
    [view addSubview:self.collectionView];
    [view addSubview:self.scrollView];
   // UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(9, 200, 100, 21)];
   // label.text = @"分类";
   // [label sizeToFit];
   // label.textColor = [UIColor lightGrayColor];
    //label.backgroundColor = [UIColor redColor];
   // [view addSubview:label];
    // [self.view addSubview:self.myTable];
    self.myTable.tableHeaderView = view;
    
}

#pragma mark - 加载数据
- (void)loadData{
    
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    if ([reach currentReachabilityStatus]== NotReachable) {
        NSArray * array = [FMDBManager selectMyJSONWithPage:_page];
        JSONModelArray * jsonArr = [[JSONModelArray alloc]initWithArray:array modelClass:[CartoonJson class]];
        [self.dataSorce removeAllObjects];
        for (CartoonJson * mod in jsonArr) {
            [self.dataSorce addObject:mod];
        }
        
    }
    
    else{
        
        [HDManager startLoading];
        
        [self.manager GET:CATEGORY_URL parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSArray * array = dict[@"results"];
            
            JSONModelArray * jsArr = [[JSONModelArray alloc]initWithArray:array modelClass:[CartoonJson class]];
            for (CartoonJson * cjs in jsArr) {
                [self.dataSorce addObject:cjs];
            }
            [FMDBManager insertJsonArr:(NSArray *)jsArr];
            [self.collectionView reloadData];
            [HDManager stopLoading];
            
        }
                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      NSLog(@"请求数据失败");
                  }];
    }
    
    [self.manager GET:TOP_URL parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray * array = dic[@"results"];
        for (NSDictionary * dic in array) {
            if (self.imageArr.count<=5) {
                
                [self.imageArr addObject:dic[@"images"]];
            }
        }
        self.scrollView.imageURLArray = self.imageArr;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求数据失败");
    }];
}
#pragma mark - collectionDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.dataSorce count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TypeCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    
    CartoonJson * cjs = self.dataSorce[indexPath.item];
    [cell.typeImage sd_setImageWithURL:[NSURL URLWithString:cjs.images]];
    
    cell.titleL.text = cjs.name;
    
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    OtherViewController * ovc = [[OtherViewController alloc]init];
    CartoonJson * cjs = self.dataSorce[indexPath.item];
    NSString *url = [NSString stringWithFormat:CATEGORY_CLICK_URL,@"%d",cjs.cartoonId];
    ovc.url = url;
    ovc.mytitle = cjs.name;
    [self.navigationController pushViewController:ovc animated:YES];
}
#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 1430;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * string = @"patrcell";
    PartCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (!cell) {
        cell = [[PartCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.fatherC = self;
    return cell;
}
#pragma mark - 懒加载
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout * flayout = [[UICollectionViewFlowLayout alloc]init];
        flayout.minimumInteritemSpacing = 10;
        flayout.minimumLineSpacing = 10;
        flayout.itemSize = CGSizeMake(100, 121);
        flayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(5, 200, WIDTH-10, 160) collectionViewLayout:flayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"TypeCell" bundle:nil] forCellWithReuseIdentifier:@"collectionCell"];
        
    }
    return _collectionView;
}
- (UITableView *)myTable{
    if (!_myTable) {
        _myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-44) style:UITableViewStylePlain];
        _myTable.delegate = self;
        _myTable.dataSource = self;
        _myTable.showsHorizontalScrollIndicator = NO;
        _myTable.showsVerticalScrollIndicator = NO;
        _myTable.bounces = NO;
        _myTable.tableHeaderView.frame = CGRectMake(0, 0, WIDTH, 300);
        _myTable.backgroundColor = [UIColor clearColor];
    }
    return _myTable;
}
- (NSMutableArray *)dataSorce{
    if (!_dataSorce) {
        _dataSorce = [[NSMutableArray alloc]init];
        
    }
    return _dataSorce;
}
- (XTADScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[XTADScrollView alloc]initWithFrame:CGRectMake(0, 0,WIDTH, 200)];
        _scrollView.needPageControl = YES;
        _scrollView.infiniteLoop = YES;
        _scrollView.placeHolderImageName = @"place.jpg";
        //_scrollView.imageArray = @[@"1.jpg",@"2.jpg"];
    }
    return _scrollView;
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
- (NSMutableArray *)imageArr{
    if (!_imageArr) {
        _imageArr = [[NSMutableArray alloc]init];
    }
    return _imageArr;
}
@end
