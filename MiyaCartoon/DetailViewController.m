//
//  DetailViewController.m
//  MiyaCartoon
//
//  Created by miya on 16/6/13.
//  Copyright © 2016年 miya. All rights reserved.
//

#import "DetailViewController.h"
#import "AFNetworking.h"
#import "detailModel.h"
#import "partModel.h"
#import "UIImageView+WebCache.h"
#import "CartoonViewController.h"
#import "CollectionFMDB.h"
#import "HDManager.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "ReadManager.h"
#import "UMSocialSnsData.h"
#import "UMSocialSnsService.h"
#import "UMSocialData.h"
#import "UMSocialSnsPlatformManager.h"
@interface DetailViewController ()<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate,UMSocialDataDelegate>
{
    UILabel * _autorL;
    UILabel * _detailL;
    UIImageView * _imageView;
    UILabel * _dateL;
    UILabel * _typeL;
    NSString * tableName;
    NSString * imageName;
    NSString * detailText;
    NSString * shareUrl;
}
@property (nonatomic,strong) MBProgressHUD * HDView;
@property (nonatomic,strong) CollectionFMDB * fbManager;
@property (nonatomic,strong) UITableView * myTable;
@property (nonatomic,strong) NSMutableArray * dataSorce;
@property (nonatomic,strong) UIView * headerView;
@property (nonatomic,strong) AFHTTPSessionManager * manager;
@end

@implementation DetailViewController
-(void)viewWillAppear:(BOOL)animated{
    UIApplication * application = [UIApplication sharedApplication];
    AppDelegate * delegate = application.delegate;
    self.view.backgroundColor = delegate.blackColor;
    [self.myTable reloadData];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //检测名字是否有特殊符号
    NSArray * array =[self.cjs.name componentsSeparatedByString:@" ,:"];
    tableName = [array firstObject];

    [ReadManager createTable:tableName];
    [self loadData];
    self.navigationItem.title = self.cjs.name;
    [self.view addSubview:self.myTable];
    [self createView];
    [self createCollection];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

- (void)createCollection{
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH/2+80+25, 45, 30, 30)];
    [btn setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"collection_select"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:btn];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2+25, 55, 100, 21)];
    label.font = [UIFont systemFontOfSize:12];
    label.text = @"喜欢就收藏吧:";
    [label sizeToFit];
    label.textColor = [UIColor lightGrayColor];
    [_headerView addSubview:label];
    if ([CollectionFMDB selectMyJSONWithTitle:self.cjs.cartoonId]) {
        btn.selected = YES;
    }else{
        btn.selected = NO;
    }
    [self createleft];
}
- (void)createleft{
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,BTNSIZE,BTNHEIGHT)];
    [btn setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick1:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    UIButton * rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, BTNSIZE, BTNSIZE)];
    [rightBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
}
- (void)rightBtnClick:(UIButton *)btn{
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:imageName];
    [UMSocialData defaultData].extConfig.title = tableName;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareUrl;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = shareUrl;
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"5771dcf167e58ec3f2000edc"
                                      shareText:detailText
                                     shareImage:[UIImage imageNamed:@"icon"]
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]
                                       delegate:self];

}
-(void)btnClick1:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}
//收藏
- (void)btnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        
        
        [CollectionFMDB insertJsonFromTable:self.cjs];
        
    }else{
        [CollectionFMDB deleteJsonFromTable:self.cjs.cartoonId];
        
    }
    
    
}
- (void)createView{
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 330)];
    _headerView.backgroundColor = [UIColor clearColor];
    _autorL = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2+25, 80, 200, 21)];
    _autorL.textColor = [UIColor colorWithRed:1.00 green:0.67 blue:0.57 alpha:1.00];
    _autorL.font = [UIFont systemFontOfSize:13];
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 5, WIDTH/2-10, 180)];
    _detailL = [[UILabel alloc]initWithFrame:CGRectMake(20, 210, WIDTH-40, 80)];
    _detailL.textColor = [UIColor lightGrayColor];
    _detailL.numberOfLines=0;
    _detailL.font = [UIFont systemFontOfSize:14];
    _dateL = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2+25, 110, 100, 21)];
    _dateL.textColor = [UIColor colorWithRed:1.00 green:0.67 blue:0.57 alpha:1.00];
    _dateL.font = [UIFont systemFontOfSize:12];
    _typeL = [[UILabel alloc]initWithFrame:CGRectMake(20, 190, WIDTH-30, 21)];
    _typeL.textAlignment = NSTextAlignmentLeft;
    _typeL.font = [UIFont systemFontOfSize:13];
    _typeL.textColor = COLOR;
    [_headerView addSubview:_typeL];
    [_headerView addSubview:_dateL];
    [_headerView addSubview:_detailL];
    [_headerView addSubview:_imageView];
    [_headerView addSubview:_autorL];
    self.myTable.tableHeaderView = _headerView;
}
- (void)loadData{
    
    [HDManager  startLoading];
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    if ([reach currentReachabilityStatus]== NotReachable){
        [HDManager stopLoading];
    }else{
        [self.manager GET:[NSString stringWithFormat:DETAIL_URL,self.urlId] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary * dic = dict[@"results"];
            shareUrl = dic[@"shareUrl"];
            _autorL.text = [NSString stringWithFormat:@"作者:%@",dic[@"author"]];
            _detailL.text =[NSString stringWithFormat:@"      %@",dic[@"introduction"]];
            detailText = dic[@"introduction"];
            _typeL.text = dic[@"categoryLabel"];
            [_imageView sd_setImageWithURL:[NSURL URLWithString:dic[@"images"]]];
            imageName = dic[@"images"];
            _dateL.text = dic[@"updateValueLabel"];
            
            NSArray * array = dic[@"cartoonChapterList"];
            JSONModelArray * jsArr = [[JSONModelArray alloc]initWithArray:array modelClass:[partModel class]];
            for (partModel * dm in jsArr) {
                [self.dataSorce addObject:dm];
                
            }
            [HDManager stopLoading];
            [self.myTable reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求数据失败");
        }];
    }
}

#pragma mark - delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CartoonViewController * cvc = [[CartoonViewController alloc]init];
    partModel * pm = self.dataSorce[indexPath.row];
    [ReadManager insertJsonFromTable:pm andTableNmae:tableName];
    cvc.cartoonID = pm.myID;
    cvc.numberName = pm.name;
    cvc.cartoonName = pm.cartoonName;
    cvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cvc animated:YES];
    
    
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"目录";
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
    view.backgroundColor = [UIColor lightGrayColor];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(5, 3, 100, 20)];
    label.text = @"目录";
    [label sizeToFit];
    [view addSubview:label];
    return view;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSorce count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * incell = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:incell];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:incell];
    }
    
   // cell.backgroundColor = [UIColor clearColor];
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH-25, 12, 14, 14)];
    imageV.image = [UIImage imageNamed:@"go"];
    [cell.contentView addSubview:imageV];
    partModel * pm = self.dataSorce[indexPath.row];
    cell.textLabel.text = pm.name;
    cell.textLabel.textColor = [UIColor grayColor];
    if ([ReadManager selectPartModelWithTitle:pm.name andTableName:tableName]) {
        cell.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.00];
    }else{
        cell.backgroundColor = [UIColor clearColor];
    }

    
    return cell;
    
}
#pragma mark - 懒加载
-(UITableView *)myTable{
    if (!_myTable) {
        _myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) style:UITableViewStylePlain];
        _myTable.delegate = self;
        _myTable.dataSource =self;
        _myTable.backgroundColor = [UIColor clearColor];
        _myTable.showsHorizontalScrollIndicator = NO;
        _myTable.showsVerticalScrollIndicator = NO;
        _myTable.bounces = NO;
        _myTable.tableHeaderView.frame = CGRectMake(0, 0, WIDTH, 300);
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
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}
@end
