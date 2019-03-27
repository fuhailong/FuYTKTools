//
//  FuHttpInfo.h
//  FuHttpDemo
//
//  Created by 付海龙 on 2019/3/25.
//  Copyright © 2019 付海龙. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FuHttpInfo : NSObject
@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSNumber *type;

- (id)initWithMethod:(NSString *)method type:(NSUInteger)type;
- (NSString *)dictKey;

@end

NS_ASSUME_NONNULL_END
