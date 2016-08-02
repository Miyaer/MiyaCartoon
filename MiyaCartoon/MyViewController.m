//
//  MyViewController.m
//  MiyaCartoon
//
//  Created by miya on 16/6/13.
//  Copyright © 2016年 miya. All rights reserved.
//

#import "MyViewController.h"
#import "CollectionViewController.h"
#import "SDImageCache.h"
#import "MyCell.h"
#import "ModeCell.h"
#import "AppDelegate.h"
@interface MyViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray * _imageArr;
    NSArray * _nameArr;
    UIImageView * _myView;
    
}
@property (nonatomic,strong) UITableView * myTable;
@end

@implementation MyViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"touming"] forBarMetrics:UIBarMetricsCompact];
    self.navigationController.navigationBar.layer.masksToBounds = YES;
    _myView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-44)];
    _myView.userInteractionEnabled = YES;
    _myView.image = [UIImage imageNamed:@"day"];
    [self.view addSubview:_myView];
    _nameArr = @[@[@"我的收藏",@"清除缓存"],@[@"设置"]];
    _imageArr = @[@[@"shoucang",@"clear"],@[@"shezhi"]];
 //   [self creatHeader];
    [_myView addSubview:self.myTable];
    self.automaticallyAdjustsScrollViewInsets = NO;
}
//- (void)creatHeader{
//    _myView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 300)];
//    _myView.image = [UIImage imageNamed:@"my_titleBg"];
//    self.myTable.tableHeaderView = _myView;
//    
//    UIImageView  *titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 90, 90)];
//    titleImage.image = [UIImage imageNamed:@"myTitle"];
//    titleImage.center = _myView.center;
//    [_myView addSubview:titleImage];
//    
//    UILabel * nameL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 21)];
//    nameL.text = @"游客";
//    nameL.textColor = [UIColor darkGrayColor];
//    nameL.center = CGPointMake(titleImage.center.x, titleImage.center.y+60);
//    nameL.textAlignment = NSTextAlignmentCenter;
//    nameL.font = [UIFont systemFontOfSize:15];
//    [_myView addSubview:nameL];
//    
//}

#pragma mark - delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1){
        ModeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ModeCell"];
        cell.titleImage.image = [UIImage imageNamed:_imageArr[indexPath.section][indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.vc = self;
        [cell.mySwitch addTarget:self action:@selector(Click:) forControlEvents:UIControlEventValueChanged];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    else{
    MyCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameL.text = _nameArr[indexPath.section][indexPath.row];
    cell.myImage.image = [UIImage imageNamed:_imageArr[indexPath.section][indexPath.row]];
    
    return cell;
    }
    
}
- (void)Click:(UISwitch *)sen{
    UIApplication * application = [UIApplication sharedApplication];
    AppDelegate * delegate = application.delegate;
    
    
    if (sen.isOn) {
        //夜间模式
        delegate.isDay = NO;
        delegate.blackColor =[UIColor colorWithRed:0.02 green:0.13 blue:0.27 alpha:1.00];
        
        _myView.image = [UIImage imageNamed:@"myBg.jpg"];
        [self.view reloadInputViews];
//        self.myTable.backgroundColor = [UIColor colorWithRed:0.02 green:0.13 blue:0.27 alpha:1.00];
    //    [self.myTable reloadData];

    }else{
        //白天模式
        delegate.isDay = YES;
        delegate.blackColor = [UIColor whiteColor];
        _myView.image = [UIImage imageNamed:@"day"];
        [self.view reloadInputViews];
      //  self.myTable.backgroundColor = [UIColor clearColor];
      //  [self.myTable reloadData];
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 10;
    }else
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
    if (indexPath.row==0) {
        CollectionViewController * cvc = [[CollectionViewController alloc]init];
        [self.navigationController pushViewController:cvc animated:YES];
    }else if (indexPath.row==1){
        SDImageCache * cache = [SDImageCache sharedImageCache];
        NSInteger  cacheSize = [cache getSize];
        CGFloat sm = cacheSize * 1.0/1024/1024;
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"清除缓存" message:[NSString stringWithFormat:@"共有缓存%.2fM",sm] preferredStyle:    UIAlertControllerStyleAlert];
        UIAlertAction  * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [cache clearDisk];
        }];
        UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section==0){
    return 2;
    }else{
        return 1;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (UITableView *)myTable{
    if (!_myTable) {
        _myTable = [[UITableView alloc]initWithFrame:CGRectMake(0,150, WIDTH, HEIGHT) style:UITableViewStyleGrouped];
        _myTable.delegate = self;
        _myTable.dataSource = self;
        _myTable.bounces = NO;
 //       _myTable.tableHeaderView.frame = CGRectMake(0, 0, WIDTH, 300);
        _myTable.backgroundColor = [UIColor clearColor];
        [_myTable registerNib:[UINib nibWithNibName:@"MyCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        [_myTable registerNib:[UINib nibWithNibName:@"ModeCell" bundle:nil] forCellReuseIdentifier:@"ModeCell"];
    }
    return _myTable;
}

@end
