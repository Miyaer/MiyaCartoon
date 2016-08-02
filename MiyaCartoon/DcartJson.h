//
//  DcartJson.h
//  MiyaCartoon
//
//  Created by miya on 16/6/14.
//  Copyright © 2016年 miya. All rights reserved.
//

#import "JSONModel.h"

@interface DcartJson : JSONModel
@property (nonatomic,copy) NSString * cartoonName;
@property (nonatomic,copy) NSString * chapterName;
@property (nonatomic,copy) NSString * images;
@property (nonatomic,copy) NSString * modifyTime;
@property (nonatomic,copy) NSString * imgHeight;
@property (nonatomic,copy) NSString * imgWidth;
@end
