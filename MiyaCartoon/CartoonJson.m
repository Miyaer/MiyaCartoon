//
//  CartoonJson.m
//  MiyaCartoon
//
//  Created by miya on 16/6/13.
//  Copyright © 2016年 miya. All rights reserved.
//

#import "CartoonJson.h"

@implementation CartoonJson
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"cartoonId"}];
}

@end
