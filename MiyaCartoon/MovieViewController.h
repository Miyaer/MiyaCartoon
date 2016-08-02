//
//  MovieViewController.h
//  MiyaCartoon
//
//  Created by miya on 16/6/13.
//  Copyright © 2016年 miya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieCell.h"
#import "AFNetworking.h"
#import "MJRefresh.h"

@interface MovieViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>


@property (nonatomic,strong)NSMutableArray * dataSorce;
@property (nonatomic,strong)UICollectionView * showCollection;
@property (nonatomic,strong)AFHTTPSessionManager * manager;
@property (nonatomic,strong)NSString * url;

- (void)seturl;
@end
