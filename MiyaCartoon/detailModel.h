//
//  detailModel.h
//  MiyaCartoon
//
//  Created by miya on 16/6/14.
//  Copyright © 2016年 miya. All rights reserved.
//

#import "JSONModel.h"

@interface detailModel : JSONModel
@property (nonatomic,copy) NSString * cartoonName;
@property (nonatomic,copy) NSString * myID;
@property (nonatomic,copy) NSString * images;
@property (nonatomic,copy) NSString * introduction;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * star;
@property (nonatomic,copy) NSString * updateInfo;
@property (nonatomic,copy) NSString * updateValueLabel;
@property (nonatomic,copy) NSString * author;
@property (nonatomic,copy) NSArray * cartoonChapterList;
@property (nonatomic,copy) NSArray * children;

@end
