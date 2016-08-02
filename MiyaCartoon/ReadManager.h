//
//  ReadManager.h
//  MiyaCartoon
//
//  Created by miya on 16/6/23.
//  Copyright © 2016年 miya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "partModel.h"
@interface ReadManager : NSObject

@property (nonatomic,strong) FMDatabase * dataBase;
+(ReadManager *)shareReadManager;
+(void)createTable:(NSString *)tableName;
+(void)insertJsonFromTable:(partModel *)js andTableNmae:(NSString *)tableNmae;
+(BOOL)selectPartModelWithTitle:(NSString *)title andTableName:(NSString *)tableName;

@end
