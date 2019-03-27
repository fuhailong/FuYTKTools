//
//  Def_Item.m
//  FuYTKDemo
//
//  Created by 付海龙 on 2019/3/27.
//  Copyright © 2019 付海龙. All rights reserved.
//

#import "Def_Item.h"

@implementation Def_Array_Item

@end

@implementation Def_Data_Item

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"array":[Def_Array_Item class],
             };
}

@end

@implementation Def_Item

@end

