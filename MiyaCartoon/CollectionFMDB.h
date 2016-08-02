//
//  CollectionFMDB.h
//  MiyaCartoon
//
//  Created by miya on 16/6/14.
//  Copyright © 2016年 miya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CartoonJson.h"
#import "FMDB.h"
#import "MovieJson.h"
@interface CollectionFMDB : NSObject
@property (nonatomic,strong) FMDatabase * dataBase;
//首页
+ (CollectionFMDB *)shareManager;
+ (void)createTable;
+ (void)insertJsonFromTable:(CartoonJson *)js;
+ (void)deleteJsonFromTable:(NSString *)index;
+ (NSArray *)selectAll;
+(void)insertJsonArr:(NSArray *)modls;
+ (BOOL)selectMyJSONWithTitle:(NSString * )title;
+(NSArray *)selectMyJSONWithPage:(NSInteger)page;
//动漫页面
+(void)createMovieTable;
+(void)insertMovieArr:(NSArray *)models;
+(NSArray *)selectMovieWithPage:(NSInteger)page;
+(void)insertMovieFromTable:(MovieJson *)js;
//动漫number页面

@end
