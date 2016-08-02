//
//  NumberJson.h
//  MiyaCartoon
//
//  Created by miya on 16/6/20.
//  Copyright © 2016年 miya. All rights reserved.
//

#import "JSONModel.h"

@interface NumberJson : JSONModel
@property (nonatomic,copy) NSString * imgUrl;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * desc;
@property (nonatomic,copy) NSString * collectionId;
@property (nonatomic,copy) NSString * eid;
@property (nonatomic,copy) NSString * number;
@end
