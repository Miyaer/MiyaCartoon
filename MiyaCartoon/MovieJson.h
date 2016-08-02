//
//  MovieJson.h
//  MiyaCartoon
//
//  Created by miya on 16/6/17.
//  Copyright © 2016年 miya. All rights reserved.
//

#import "JSONModel.h"

@interface MovieJson : JSONModel
@property (nonatomic,copy) NSString<Optional> * imageUrl;
@property (nonatomic,copy) NSString * label;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * myID;

@end
