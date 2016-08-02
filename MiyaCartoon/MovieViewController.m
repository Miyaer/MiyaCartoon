//
//  MovieViewController.m
//  MiyaCartoon
//
//  Created by miya on 16/6/13.
//  Copyright © 2016年 miya. All rights reserved.
//

#import "MovieViewController.h"
#import "DMDetailViewController.h"
#import "MovieJson.h"
#import "UIImageView+WebCache.h"
#import "HDManager.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "CollectionFMDB.h"
@interface MovieViewController ()
@property (nonatomic,assign)int page;
@property (nonatomic,strong) MBProgressHUD * HDView;
@end

@implementation MovieViewController
-(void)viewWillAppear:(BOOL)animated{
    UIApplication * application = [UIApplication sharedApplication];
    AppDelegate * delegate = application.delegate;
    self.view.backgroundColor = delegate.blackColor;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [CollectionFMDB createMovieTable];
    _page = 1;
    [self seturl];
    [self loadData];
    [self.view addSubview:self.showCollection];
   
     self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
}

- (void)seturl{
    _url = self.url;
}
- (void)loadData{
    [HDManager startLoading];
    
    int page = 1;
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    if ([reach currentReachabilityStatus]== NotReachable) {
        
       NSArray* array = [CollectionFMDB selectMovieWithPage:page];
        [self.dataSorce removeAllObjects];
        JSONModelArray * jsArr = [[JSONModelArray alloc]initWithArray:array modelClass:[MovieJson class]];
        for (MovieJson * js in jsArr) {
            [self.dataSorce addObject:js];
        }
        [self.showCollection reloadData];
        
        [HDManager stopLoading];
        
    }
    else {
    if (_page == 1) {
        [self.dataSorce removeAllObjects];
    }
    NSString * url1 = [NSString stringWithFormat:DM_URL,_page,self.url];
    
    [self.manager GET:url1 parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"%@",dic);
        NSDictionary *dict = dic[@"video_list"];
        NSArray * array = dict[@"videos"];
        JSONModelArray * jsonArr = [[JSONModelArray alloc]initWithArray:array modelClass:[MovieJson class]];
        for (MovieJson * js in jsonArr) {
            [self.dataSorce addObject:js];
        }
        [CollectionFMDB insertMovieArr:(NSArray *)jsonArr];
        
        if (_page==1) {
            [self.showCollection.header endRefreshing];
        }else{
            [self.showCollection.footer endRefreshing];
        }
        _showCollection.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page = 1;
            [self loadData];
            
        }];
        _showCollection.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page++;
            [self loadData];
            
        }];
        
           [HDManager stopLoading];
            [self.showCollection reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求数据失败");
    }];
    
    }
}


#pragma mark - delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
        return [self.dataSorce count];
    

}
-(UICollectionViewCell * )collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
           MovieCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (self.dataSorce.count>0) {
        
        MovieJson * js = self.dataSorce[indexPath.item];
    if (js.imageUrl.length>0) {
                [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:js.imageUrl] placeholderImage:[UIImage imageNamed:@"placePic"]];
    }else{
        cell.titleImage.image = [UIImage imageNamed:@"login_bg.jpg"] ;
    }

        cell.nameL.text = js.title;
            cell.numberL.text = js.label;
    }
        return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DMDetailViewController * nvc = [[DMDetailViewController alloc]init];
    MovieJson * js = self.dataSorce[indexPath.item];
    nvc.urlID = js.myID;
    nvc.title = js.title;
    nvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:nvc animated:YES];
}

#pragma mark - 懒加载
- (UICollectionView *)showCollection{
    if (!_showCollection) {
        UICollectionViewFlowLayout * flayout = [[UICollectionViewFlowLayout alloc]init];
        flayout.minimumInteritemSpacing = 0;
        flayout.minimumLineSpacing = 0;
        flayout.itemSize = CGSizeMake(WIDTH/2, 200);
        _showCollection.bounces = NO;
        _showCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64-44) collectionViewLayout:flayout];
        _showCollection.delegate = self;
        _showCollection.dataSource = self;
        _showCollection.backgroundColor = [UIColor clearColor];
        _showCollection.showsHorizontalScrollIndicator = NO;
        _showCollection.showsVerticalScrollIndicator = NO;

        [_showCollection registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    }
    return _showCollection;
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
