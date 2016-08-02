//
//  partModel.m
//  MiyaCartoon
//
//  Created by miya on 16/6/14.
//  Copyright © 2016年 miya. All rights reserved.
//

#import "partModel.h"

@implementation partModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"myID"}];
}

@end
