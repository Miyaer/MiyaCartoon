//
//  ReadManager.m
//  MiyaCartoon
//
//  Created by miya on 16/6/23.
//  Copyright © 2016年 miya. All rights reserved.
//

#import "ReadManager.h"

@implementation ReadManager
+(ReadManager *)shareReadManager{
    static ReadManager * manager = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        manager = [[[self class]alloc]init];
        NSString * path = [NSString stringWithFormat:@"%@/Library/Caches/tour.db",NSHomeDirectory()];
        manager.dataBase = [FMDatabase databaseWithPath:path];
        NSLog(@"路径:%@",path);
    });
    if (manager.dataBase.open == NO) {
        [manager.dataBase open];
    }
    return manager;
}

+(void)createTable:(NSString *)tableName{
    ReadManager * manager = [ReadManager shareReadManager];
    
    NSString * sql = [NSString stringWithFormat:@"create table if not exists %@(name text primary key)",tableName];
    BOOL result = [manager.dataBase executeUpdate:sql];
    if (result) {
        NSLog(@"建表成功");
        
    }else{
        NSLog(@"建表失败");
    }
    

}

+(void)insertJsonFromTable:(partModel *)js andTableNmae:(NSString *)tableNmae{
    ReadManager * manager = [ReadManager shareReadManager];
    
    NSString *sql = [NSString stringWithFormat:@"insert into %@(name) values(?)",tableNmae];
    BOOL result = [manager.dataBase executeUpdate:sql,js.name];
    if (result) {
        NSLog(@"插入数据成功");
    }else{
        NSLog(@"数据已经存在");
    }
    

}
+(BOOL)selectPartModelWithTitle:(NSString *)title andTableName:(NSString *)tableName{
    ReadManager * manager = [ReadManager shareReadManager];
    
    NSString * sql = [NSString stringWithFormat:@"select * from %@ where name = ?",tableName];
    
    //执行语句
    FMResultSet * set = [manager.dataBase executeQuery:sql,title];
    while ([set next]) {
        
        return YES;
    }
    return NO;
    

}
@end
