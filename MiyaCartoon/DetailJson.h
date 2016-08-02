//
//  DetailJson.h
//  MiyaCartoon
//
//  Created by miya on 16/6/18.
//  Copyright © 2016年 miya. All rights reserved.
//

#import "JSONModel.h"

@interface DetailJson : JSONModel
@property (nonatomic,copy) NSArray * children;
@property (nonatomic,copy) NSDictionary * firstPlay;
@property (nonatomic,copy) NSString * label;
@property (nonatomic,copy) NSString * intro;
@property (nonatomic,copy) NSArray * area;
@property (nonatomic,copy) NSString * myID;
@property (nonatomic,copy) NSDictionary * lastEpisode;
@property (nonatomic,copy) NSString * imgUrl;
@end
