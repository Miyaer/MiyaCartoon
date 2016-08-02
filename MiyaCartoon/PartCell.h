//
//  PartCell.h
//  MiyaCartoon
//
//  Created by miya on 16/6/13.
//  Copyright © 2016年 miya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@interface PartCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSArray * _nameArr;
    NSArray * _imageArr;
    NSArray * _urlArr;
}
@property (nonatomic,strong) UICollectionView * myCollection;
@property (nonatomic,strong) NSMutableArray * dataSorce;
@property (nonatomic,strong) AFHTTPSessionManager * manager;
@property (nonatomic,strong) UIViewController * fatherC;
@end
