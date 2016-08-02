//
//  CartoonJson.h
//  MiyaCartoon
//
//  Created by miya on 16/6/13.
//  Copyright © 2016年 miya. All rights reserved.
//

#import "JSONModel.h"

@interface CartoonJson : JSONModel
@property (nonatomic,copy) NSString * author;
@property (nonatomic,copy) NSString * categoryLabel;
@property (nonatomic,copy) NSString * categorys;
@property (nonatomic,copy) NSString * createTime;
@property (nonatomic,copy) NSString * cartoonId;
@property (nonatomic,copy) NSString * images;
@property (nonatomic,copy) NSString * introduction;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * updateInfo;
@end
