//
//  CollectionViewController.m
//  MiyaCartoon
//
//  Created by miya on 16/6/13.
//  Copyright © 2016年 miya. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionCell.h"
#import "CartoonJson.h"
#import "CollectionFMDB.h"
#import "DetailViewController.h"
#import "UIImageView+WebCache.h"
#import "CollectionFMDB.h"
@interface CollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UIImageView * _bgImage;
}
@property (nonatomic,strong) UICollectionView * myCollection;
@property (nonatomic,strong) NSMutableArray * dataSorce;
@end

@implementation CollectionViewController
-(void)viewWillAppear:(BOOL)animated{
    [self loadData];
    self.navigationItem.title = @"我的收藏";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _bgImage = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _bgImage.image = [UIImage imageNamed:@"collection_bg.jpg"];
    _bgImage.userInteractionEnabled = YES;
    [self.view addSubview:_bgImage];
    [self loadData];
    [self createNav];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [_bgImage addSubview:self.myCollection];
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

-(void)loadData{
    [self.dataSorce removeAllObjects];
    NSArray * array = [CollectionFMDB selectAll];
    [self.dataSorce addObjectsFromArray:array];
   // NSLog(@"%@",self.dataSorce);
    [self.myCollection reloadData];

}

#pragma mark - Delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.dataSorce count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];

    cell.btnImage.userInteractionEnabled = YES;
    CartoonJson * cjs = self.dataSorce[indexPath.item];
    [cell.btnImage sd_setImageWithURL:[NSURL URLWithString:cjs.images]];
    cell.btnName.text = cjs.name;
    return cell;
    
}
-(void)btnPress:(UIButton *)btn{
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要删除收藏内容吗?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        CartoonJson * cjs = self.dataSorce[btn.tag];
        [CollectionFMDB deleteJsonFromTable:cjs.cartoonId];
        [self loadData];
    }];
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController * dvc = [[DetailViewController alloc]init];
    CartoonJson * cjs = self.dataSorce[indexPath.row];
    dvc.urlId = cjs.cartoonId;
    dvc.imageName = cjs.images;
    dvc.cjs = cjs;
    [self.navigationController pushViewController:dvc animated:YES];

}


#pragma mark - 懒加载
- (UICollectionView *)myCollection{
    if (!_myCollection) {
        UICollectionViewFlowLayout * flayout = [[UICollectionViewFlowLayout alloc]init];
        flayout.minimumInteritemSpacing = 5;
        flayout.minimumLineSpacing = 5;
        flayout.itemSize = CGSizeMake((WIDTH-5*2)/2, 200);

        _myCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-44) collectionViewLayout:flayout];
        _myCollection.showsHorizontalScrollIndicator = NO;
        _myCollection.showsVerticalScrollIndicator = NO;
        _myCollection.bounces = NO;
        _myCollection.backgroundColor = [UIColor clearColor];
        _myCollection.delegate = self;
        _myCollection.dataSource = self;
        [_myCollection registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil] forCellWithReuseIdentifier:@"collectionCell"];
    }
    return _myCollection;
}
-(NSMutableArray *)dataSorce{
    if (!_dataSorce) {
        _dataSorce = [[NSMutableArray alloc]init];
    }
    return _dataSorce;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
