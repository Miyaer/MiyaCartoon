//
//  DetailJson.m
//  MiyaCartoon
//
//  Created by miya on 16/6/18.
//  Copyright © 2016年 miya. All rights reserved.
//

#import "DetailJson.h"

@implementation DetailJson
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"myID"}];
}

@end
