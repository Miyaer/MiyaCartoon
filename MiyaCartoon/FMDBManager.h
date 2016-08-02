//
//  FMDBManager.h
//  iOS周末作业
//
//  Created by soul on 16/5/26.
//  Copyright © 2016年 miya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "CartoonJson.h"
@interface FMDBManager : NSObject
@property (nonatomic,strong) FMDatabase * dataBase;
+ (FMDBManager *)shareManager;
+ (void)createTable;
+ (void)insertJsonFromTable:(CartoonJson *)js;
+ (void)deleteJsonFromTable:(NSString *)index;
+ (NSArray *)selectAll;
+(void)insertJsonArr:(NSArray *)modls;
+ (BOOL)selectMyJSONWithTitle:(NSString * )title;
+(NSArray *)selectMyJSONWithPage:(NSInteger)page;
@end
