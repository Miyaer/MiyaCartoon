//
//  DMDetailViewController.m
//  MiyaCartoon
//
//  Created by miya on 16/6/18.
//  Copyright © 2016年 miya. All rights reserved.
//

#import "DMDetailViewController.h"
#import "NumberViewController.h"
#import "AFNetworking.h"
#import "DetailJson.h"
#import "lastEpisode.h"
#import "UIImageView+WebCache.h"
#import "PlayViewController.h"
#import "CollectionCell.h"
#import "OtherJson.h"
#import "HDManager.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "AppDelegate.h"
@interface DMDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) MBProgressHUD * HDView;
@property (nonatomic,strong) AFHTTPSessionManager * manager;
@property (nonatomic,strong) NSMutableArray * dataSorce;
@property (nonatomic,strong) NSString * cid;
@property (nonatomic,strong) NSString * eid;
@property (nonatomic,strong) NSString * dateID;
@property (nonatomic,strong) NSString * number;
@property (nonatomic,strong) UICollectionView * myCollection;
@end

@implementation DMDetailViewController
-(void)viewWillAppear:(BOOL)animated{
    UIApplication * application = [UIApplication sharedApplication];
    AppDelegate * delegate = application.delegate;
    self.view.backgroundColor = delegate.blackColor;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createleft];
    [self.palyB setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [self loadData];
    [self createUI];
    self.view.backgroundColor = [UIColor whiteColor];
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
    NSString * url = [NSString stringWithFormat:DMDTAILE_URL,self.urlID];
    [HDManager startLoading];
    
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    if ([reach currentReachabilityStatus]== NotReachable){
        
        [HDManager stopLoading];
    }else{
    [self.manager GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DetailJson * jsm = [[DetailJson alloc]initWithDictionary:dict error:nil];
        lastEpisode  *ls = [[lastEpisode alloc]initWithDictionary:jsm.lastEpisode error:nil];
        
        [self.titleImage sd_setImageWithURL:[NSURL URLWithString:jsm.imgUrl]];
        self.localL.text = [NSString stringWithFormat:@"地区:%@",[jsm.area firstObject]];
        self.typeL.text = [NSString stringWithFormat:@"%@",jsm.label];
        self.detailL.text = [NSString stringWithFormat:@"详情:%@",jsm.intro ];
        self.dateL.text = [NSString stringWithFormat:@"更新至:%@",ls.title];
        self.dateID = ls.number;
        self.eid = ls.eid;
        _cid = [jsm.children firstObject][@"collectionId"];
    
        [HDManager stopLoading];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求数据失败");
    }];
    
    [self.manager GET:[NSString stringWithFormat:HAIKAN_URL,self.urlID] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSArray * array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        JSONModelArray * jsarr = [[JSONModelArray alloc]initWithArray:array modelClass:[OtherJson class]];
        for (OtherJson * js in jsarr) {
            [self.dataSorce addObject:js];
        }
        
        [self.myCollection reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求数据失败");
    }];
    
    }
    
}
-(void)createUI{
    self.selectBtn.layer.masksToBounds = YES;
    self.selectBtn.layer.cornerRadius = 5;
    
}
- (IBAction)selectPress:(UIButton *)sender {
    NumberViewController * nvc = [[NumberViewController alloc]init];
    
    nvc.urlId = _cid;
    nvc.vid = self.urlID;
    [self.navigationController pushViewController:nvc animated:YES];
    
}

- (IBAction)playBtnPress:(UIButton *)sender {
    PlayViewController * nvc = [[PlayViewController alloc]init];
    nvc.cid = _cid;
    nvc.vid = self.urlID;
    nvc.eid = self.eid;
    nvc.dateID = self.dateID;
   // nvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:nvc animated:YES];
    //[self presentViewController:nvc animated:YES completion:nil];
}
#pragma mark - delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.dataSorce count];
    
}
- (UICollectionViewCell * )collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    OtherJson * js = self.dataSorce[indexPath.item];
    [cell.btnImage sd_setImageWithURL:[NSURL URLWithString:js.imageUrl]];
    cell.btnName.text = js.title;
    
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DMDetailViewController * dvc = [[DMDetailViewController alloc]init];
    OtherJson * js = self.dataSorce[indexPath.item];
    dvc.urlID = js.myID;
    
    [self.navigationController pushViewController:dvc animated:YES];
}
#pragma mark - 懒加载
- (UICollectionView *)myCollection{
    if (!_myCollection) {
        UICollectionViewFlowLayout * flayout = [[UICollectionViewFlowLayout alloc]init];
        flayout.minimumInteritemSpacing = 5;
        flayout.minimumLineSpacing = 5;
        flayout.itemSize = CGSizeMake(WIDTH/3, 200);
        flayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _myCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, HEIGHT-230, WIDTH, 200) collectionViewLayout:flayout];
        _myCollection.backgroundColor = [UIColor clearColor];
        _myCollection.delegate = self;
        _myCollection.dataSource = self;
        _myCollection.showsHorizontalScrollIndicator = NO;
        [_myCollection registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionCell"];
        [self.view addSubview:_myCollection];
        
    }
    return _myCollection;
}
- (AFHTTPSessionManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _manager;
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
