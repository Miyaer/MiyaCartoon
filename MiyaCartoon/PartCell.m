//
//  PartCell.m
//  MiyaCartoon
//
//  Created by miya on 16/6/13.
//  Copyright © 2016年 miya. All rights reserved.
//

#import "PartCell.h"
#import "AFNetworking.h"
#import "CartoonJson.h"
#import "PartCollectionCell.h"
#import "HeaderView.h"
#import "UIImageView+WebCache.h"
#import "OtherViewController.h"
#import "DetailViewController.h"
#import "FMDBManager.h"
#import "Reachability.h"
@implementation PartCell

-(void)loadPartData{
    _urlArr = @[GX_URL,RP_URL,XZ_URL,TJ_URL];
    int index=0;
    for (NSString * url in _urlArr) {
        
        NSMutableArray * array = [[NSMutableArray alloc]init];
        [self.dataSorce addObject:array];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self getData:url andCount:index];

        });
        index++;
    }
    
    
   }

- (void)getData:(NSString *)url andCount:(int)count{
    int page = 1;
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    
    if ([reach currentReachabilityStatus]== NotReachable) {
        NSArray * array = [FMDBManager selectMyJSONWithPage:count+2];
        JSONModelArray * jsonArr = [[JSONModelArray alloc]initWithArray:array modelClass:[CartoonJson class]];
        [self.dataSorce[count] removeAllObjects];
        for (int i=0;i<jsonArr.count;i++) {
            CartoonJson * mod = jsonArr[i];
            if ([self.dataSorce[count] count]<3) {
                [self.dataSorce[count] addObject:mod];
            }
            
        }
    }
    [self.manager GET:[NSString stringWithFormat:url,page]parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray * array = dict[@"results"];
        
        JSONModelArray * jsArr = [[JSONModelArray alloc]initWithArray:array modelClass:[CartoonJson class]];
        
        for (CartoonJson * cjs in jsArr) {
            if ([self.dataSorce[count] count]<6) {
                [self.dataSorce[count] addObject:cjs];

            }
        }
      
        [FMDBManager insertJsonArr:(NSArray *)jsArr];
        [self.myCollection reloadData];
    }
     
        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  NSLog(@"请求数据失败");
              }];

}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _nameArr = @[@"最新",@"热评",@"新作",@"推荐"];
        
        [self loadPartData];
        UICollectionViewFlowLayout * flayout = [[UICollectionViewFlowLayout alloc]init];
        flayout.minimumInteritemSpacing = 3;
        flayout.minimumLineSpacing = 3;
        flayout.itemSize = CGSizeMake((WIDTH-6-6)/3, 160);
        self.myCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(3, 10, WIDTH-6, 1430) collectionViewLayout:flayout];
        self.myCollection.delegate = self;
        self.myCollection.backgroundColor = [UIColor clearColor];
        self.myCollection.dataSource = self;
        
    [self.myCollection registerClass:NSClassFromString(@"HeaderView") forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HView"];
        
        
        [self.myCollection registerNib:[UINib nibWithNibName:@"PartCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        [self addSubview:self.myCollection];
        
        
        //NSLog(@"%@",self.dataSorce);
    }
    return self;
}
#pragma mark - delegate
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    HeaderView * view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HView" forIndexPath:indexPath];
    if (kind == UICollectionElementKindSectionHeader) {
        view.titleName.text = [NSString stringWithFormat:_nameArr[indexPath.section],indexPath.section];
        view.headerBtn.tag = indexPath.section;
        [view.headerBtn addTarget:self action:@selector(btnClcik:) forControlEvents:UIControlEventTouchUpInside];
    }return view;

}
- (void)btnClcik:(UIButton *)btn{
    OtherViewController * ovc = [[OtherViewController alloc]init];
    ovc.url = _urlArr[btn.tag];
    ovc.mytitle = _nameArr[btn.tag];
    [self.fatherC.navigationController pushViewController:ovc animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self.contentView.frame.size.width, 30);
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self.dataSorce[section] count];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [self.dataSorce count];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController * dvc = [[DetailViewController alloc]init];
    CartoonJson * cjs = self.dataSorce[indexPath.section][indexPath.item];
    dvc.urlId = cjs.cartoonId;
    dvc.imageName = cjs.images;
    dvc.cjs = cjs;
    dvc.hidesBottomBarWhenPushed = YES;
    [self.fatherC.navigationController pushViewController:dvc animated:YES];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PartCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    CartoonJson * cjs = self.dataSorce[indexPath.section][indexPath.item];
    [cell.titileImage sd_setImageWithURL:[NSURL URLWithString:cjs.images] placeholderImage:[UIImage imageNamed:@"placePic"]];
     cell.nameL.text = cjs.name;

    return cell;
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
@end
