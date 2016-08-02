//
//  CollectionFMDB.m
//  MiyaCartoon
//
//  Created by miya on 16/6/14.
//  Copyright © 2016年 miya. All rights reserved.
//

#import "CollectionFMDB.h"

@implementation CollectionFMDB
+ (CollectionFMDB *)shareManager{
    static CollectionFMDB * manager = nil;
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
    
    CollectionFMDB * manager = [CollectionFMDB shareManager];
    NSString * sql = @"create table if not exists myTable(cartoonId text primary key,images text,name text)";
    BOOL result = [manager.dataBase executeUpdate:sql];
    if (result) {
        NSLog(@"建表成功");
        
    }else{
        NSLog(@"建表失败");
    }
    
    
}
+(void)createMovieTable{
    /*
     @property (nonatomic,copy) NSString<Optional> * imageUrl;
     @property (nonatomic,copy) NSString * label;
     @property (nonatomic,copy) NSString * title;
     @property (nonatomic,copy) NSString * myID;
     
     */
    CollectionFMDB * manager = [CollectionFMDB shareManager];
    NSString * sql = @"create table if not exists movieTable(myID text primary key,title text,label text,imageUrl text)";
    BOOL result = [manager.dataBase executeUpdate:sql];
    if (result) {
        NSLog(@"Movie建表成功");
    }else{
        NSLog(@"Movie建表失败");
    }
    
}
+(void)insertJsonArr:(NSArray *)modls{
    
    for (CartoonJson *model in modls)
    {
        [self insertJsonFromTable:model];
    }
    
    
}
+(void)insertMovieArr:(NSArray *)models{
    for (MovieJson * model in models) {
        [self insertMovieFromTable:model];
    }
}
+(void)insertMovieFromTable:(MovieJson *)js{
    CollectionFMDB * manager = [CollectionFMDB shareManager];
    NSString * sql = @"insert into movieTable(myID,title,label,imageUrl) values(?,?,?,?)";
    BOOL result = [manager.dataBase executeUpdate:sql,js.myID,js.title,js.label,js.imageUrl];
    if (result) {
        NSLog(@"插入数据成功");
    }else{
        NSLog(@"数据已存在");
    }
    
}
+ (void)insertJsonFromTable:(CartoonJson *)js{
    CollectionFMDB * manager = [CollectionFMDB shareManager];
    NSString *sql = @"insert into myTable(cartoonId,images,name) values(?,?,?)";
    BOOL result = [manager.dataBase executeUpdate:sql,js.cartoonId,js.images,js.name];
    if (result) {
        NSLog(@"插入数据成功");
    }else{
        NSLog(@"插入失败");
    }
    
}
+ (void)deleteJsonFromTable:(NSString *)title{
    CollectionFMDB * manager = [CollectionFMDB shareManager];
    NSString * sql = @"delete from myTable where cartoonId = ?";
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
    CollectionFMDB * manager = [CollectionFMDB shareManager];
    NSString * sql = @"select * from myTable";
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
    CollectionFMDB * manager = [CollectionFMDB shareManager];
    NSString * sql = @"select * from myTable where cartoonId = ?";
    
    //执行语句
    FMResultSet * set = [manager.dataBase executeQuery:sql,title];
    while ([set next]) {
        
        return YES;
    }
    return NO;
    
}
+(NSArray *)selectMyJSONWithPage:(NSInteger)page{
    
    CollectionFMDB * manager = [CollectionFMDB shareManager];
    //查找第0-19条 1
    //       20-39 2
    NSString * sql = [NSString stringWithFormat:@"select * from myTable limit %ld,%ld",(page -1) * 10,page * 10 -1];
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

+(NSArray *)selectMovieWithPage:(NSInteger)page{
    CollectionFMDB * manager = [CollectionFMDB shareManager];
    NSString * sql = [NSString stringWithFormat:@"select * from movieTable limit %ld,%ld",(page-1) *10,page *10-1];
    FMResultSet * set = [manager.dataBase executeQuery:sql];
    NSMutableArray * array = [[NSMutableArray alloc]init];
    while ([set next]) {
        MovieJson * js = [[MovieJson alloc]init];
        js.myID = [set stringForColumn:@"myID"];
        js.title = [set stringForColumn:@"title"];
        js.label = [set stringForColumn:@"label"];
        js.imageUrl = [set stringForColumn:@"imageUrl"];
        [array addObject:js];
    }
    return array;
}
@end
