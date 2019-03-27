//
//  FuError.h
//  FuHttpDemo
//
//  Created by 付海龙 on 2019/3/26.
//  Copyright © 2019 付海龙. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FuError(text,code) [[FuError alloc] initWithText:text errCode:code]

NS_ASSUME_NONNULL_BEGIN

@interface FuError : NSObject
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) NSInteger code;
- (id)initWithText:(NSString *)text errCode:(NSInteger)code;
@end

NS_ASSUME_NONNULL_END
