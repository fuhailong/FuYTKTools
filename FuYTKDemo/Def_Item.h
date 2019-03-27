//
//  Def_Item.h
//  FuYTKDemo
//
//  Created by 付海龙 on 2019/3/27.
//  Copyright © 2019 付海龙. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Def_Array_Item : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSNumber *tel;
@property (nonatomic, strong) NSNumber *is_working;
@end


@interface Def_Data_Item : NSObject
@property (nonatomic, strong) NSArray *array;
@end

@interface Def_Item : NSObject
@property (nonatomic, strong) NSNumber *RC;
@property (nonatomic, strong) Def_Data_Item *data;
@end

NS_ASSUME_NONNULL_END
