//
//  OtherJson.m
//  MiyaCartoon
//
//  Created by miya on 16/6/20.
//  Copyright © 2016年 miya. All rights reserved.
//

#import "OtherJson.h"

@implementation OtherJson
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"myID"}];
}

@end
