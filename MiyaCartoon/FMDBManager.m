//
//  FMDBManager.m
//  iOS周末作业
//
//  Created by soul on 16/5/26.
//  Copyright © 2016年 miya. All rights reserved.
//

#import "FMDBManager.h"
#import "CartoonJson.h"
@implementation FMDBManager

+ (FMDBManager *)shareManager{
    static FMDBManager * manager = nil;
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
+ (void)createTable{
    
    FMDBManager * manager = [FMDBManager shareManager];
       NSString * sql = @"create table if not exists myJSON(cartoonId text primary key,images text,name text)";
       BOOL result = [manager.dataBase executeUpdate:sql];
       if (result) {
           NSLog(@"建表成功");
           
       }else{
           NSLog(@"建表失败");
       }


}
+(void)insertJsonArr:(NSArray *)modls{
    
    for (CartoonJson *model in modls)
    {
        [self insertJsonFromTable:model];
    }
    
    
}

+ (void)insertJsonFromTable:(CartoonJson *)js{
    FMDBManager * manager = [FMDBManager shareManager];

    NSString *sql = @"insert into myJSON(cartoonId,images,name) values(?,?,?)";
        BOOL result = [manager.dataBase executeUpdate:sql,js.cartoonId,js.images,js.name];
        if (result) {
            NSLog(@"插入数据成功");
        }else{
            NSLog(@"已存在");
        }

    }
+ (void)deleteJsonFromTable:(NSString *)title{
    FMDBManager * manager = [FMDBManager shareManager];

    NSString * sql = @"delete from myJSON where cartoonId = ?";
    //从某张表中删除记录
    BOOL result = [manager.dataBase executeUpdate:sql,title];
    
    if (result) {
        NSLog(@"删除记录成功");
    }
    else{
        NSLog(@"删除记录失败");
    }

}

+ (NSArray *)selectAll{
    FMDBManager * manager = [FMDBManager shareManager];

    NSString * sql = @"select * from myJSON";
    NSMutableArray * array = [[NSMutableArray alloc]init];
    
    //执行查询语句
    FMResultSet * set = [manager.dataBase executeQuery:sql];
    while ([set next]) {
        //一条一条的读取数据
        CartoonJson * js = [[CartoonJson alloc]init];
        //根据键名取值
        js.cartoonId = [set stringForColumn:@"cartoonId"];
        js.name = [set stringForColumn:@"name"];
        js.images = [set stringForColumn:@"images"];
    
        [array addObject:js];
    }
    return array;
}

+ (BOOL)selectMyJSONWithTitle:(NSString *)title{
    FMDBManager * manager = [FMDBManager shareManager];

    NSString * sql = @"select * from myJSON where cartoonId = ?";
    
    //执行语句
    FMResultSet * set = [manager.dataBase executeQuery:sql,title];
    while ([set next]) {
        
        return YES;
    }
    return NO;
    
}
+(NSArray *)selectMyJSONWithPage:(NSInteger)page{
    
    FMDBManager * manager = [FMDBManager shareManager];
    //查找第0-19条 1
    //       20-39 2
    NSString * sql = [NSString stringWithFormat:@"select * from myJSON limit %ld,%ld",(page -1) * 10,page * 10 -1];
    FMResultSet * set = [manager.dataBase executeQuery:sql];
    NSMutableArray * array = [[NSMutableArray alloc]init];
    while ([set next]) {
        CartoonJson * js = [[CartoonJson alloc]init];
        js.cartoonId = [set stringForColumn:@"cartoonId"];
        js.name = [set stringForColumn:@"name"];
        js.images = [set stringForColumn:@"images"];
        [array addObject:js];
        
    }
    return array;
    
}

@end
