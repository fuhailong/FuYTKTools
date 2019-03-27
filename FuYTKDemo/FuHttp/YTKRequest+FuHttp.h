//
//  YTKRequest+FuHttp.h
//  FuHttpDemo
//
//  Created by 付海龙 on 2019/3/25.
//  Copyright © 2019 付海龙. All rights reserved.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^RequestResult)(BOOL isSuccess, id object);

@interface YTKRequest (FuHttp)
@property (nonatomic, copy) NSString *fUrl;             //requestUrl
@property (nonatomic, copy) NSDictionary *param;        //requestArgument
@property (nonatomic, copy) NSNumber *FuHttpType;
@property (nonatomic, copy) RequestResult resultBlock;  //数据传递
@property (nonatomic, copy) NSNumber *requestType;      //请求类型 Get or Post

+ (YTKRequest *)getYTK:(NSUInteger)type
                 param:(NSDictionary *)param
           requestType:(NSInteger)requestType
               replace:(NSString *)replace;

- (void)setResultBlock:(void (^) (BOOL isSuccess, id object))block;
@end

NS_ASSUME_NONNULL_END
