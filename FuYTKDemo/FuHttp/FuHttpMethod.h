//
//  FuHttpMethod.h
//  FuHttpDemo
//
//  Created by 付海龙 on 2019/3/25.
//  Copyright © 2019 付海龙. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FuHttpType) {
    FU_HTTP_BEGIN = -1,
    
    TEST_POST,      //测试POST请求
    TEST_GET,       //测试GET请求
    
    FU_HTTP_END,
};

@interface FuHttpMethod : NSObject
@property (nonatomic, strong) NSMutableDictionary *infos;

+ (FuHttpMethod *)sharedMethod;

/**
 * 通过宏得到当前方法名
 */
- (NSString *)typeMethod:(NSUInteger)type;
@end

NS_ASSUME_NONNULL_END
