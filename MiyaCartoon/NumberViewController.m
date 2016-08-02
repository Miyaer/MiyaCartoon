//
//  NumberViewController.m
//  MiyaCartoon
//
//  Created by miya on 16/6/17.
//  Copyright © 2016年 miya. All rights reserved.
//

#import "NumberViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "PlayViewController.h"
#import "NumberJson.h"
#import "NumberCell.h"
#import "HDManager.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "AppDelegate.h"
@interface NumberViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) MBProgressHUD * HDView;
@property (nonatomic,strong) UICollectionView * myCollection;
@property (nonatomic,strong) NSMutableArray * dataSorce;
@property (nonatomic,strong) AFHTTPSessionManager * manager;
@end

@implementation NumberViewController
-(void)viewWillAppear:(BOOL)animated{
    UIApplication * application = [UIApplication sharedApplication];
    AppDelegate * delegate = application.delegate;
    self.view.backgroundColor = delegate.blackColor;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createleft];
    [self loadData];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
}
- (void)createleft{
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,BTNSIZE,BTNHEIGHT)];
    [btn setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick1:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}
-(void)btnClick1:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData{
    NSString * url = [NSString stringWithFormat:XUANJI_URL,self.urlId];
    [HDManager startLoading];
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    if ([reach currentReachabilityStatus]== NotReachable){
        [HDManager stopLoading];
    }else{
    [self.manager GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray * array = dict[@"list"];
        
        JSONModelArray * jsArr = [[JSONModelArray alloc]initWithArray:array modelClass:[NumberJson class]];
        for (NumberJson * js in jsArr) {
            [self.dataSorce addObject:js];
        }
        [HDManager stopLoading];
        [self.myCollection reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求数据失败");
    }];
    }
}
#pragma mark - delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.dataSorce count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NumberCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCell" forIndexPath:indexPath];
    NumberJson * js = self.dataSorce[indexPath.item];
    [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:js.imgUrl]];
    cell.numberL.text = js.title;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PlayViewController * pvc = [[PlayViewController alloc]init];
    NumberJson * js = self.dataSorce[indexPath.item];
    pvc.vid = self.vid;
    pvc.cid = js.collectionId;
    pvc.eid = js.eid;
    pvc.dateID = js.number;
    
    [self.navigationController pushViewController:pvc animated:YES];
}
#pragma mark - 懒加载
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
- (UICollectionView *)myCollection{
    if (!_myCollection) {
        UICollectionViewFlowLayout * flayout = [[UICollectionViewFlowLayout alloc]init];
        flayout.minimumInteritemSpacing = 5;
        flayout.minimumLineSpacing = 5;
        flayout.itemSize = CGSizeMake((WIDTH-10-10)/3, 150);
        _myCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(5, 69, WIDTH-10, HEIGHT-64-5) collectionViewLayout:flayout];
        _myCollection.backgroundColor = [UIColor clearColor];
        _myCollection.delegate = self;
        _myCollection.dataSource = self;
        _myCollection.showsHorizontalScrollIndicator = NO;
        _myCollection.showsVerticalScrollIndicator = NO;
        _myCollection.bounces = NO;
        [_myCollection registerNib:[UINib nibWithNibName:@"NumberCell" bundle:nil] forCellWithReuseIdentifier:@"MovieCell"];
        [self.view addSubview:_myCollection];
        
        
    }
    return _myCollection;
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
