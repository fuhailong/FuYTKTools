//
//  FuHttpRequest.h
//  FuHttpDemo
//
//  Created by 付海龙 on 2019/3/25.
//  Copyright © 2019 付海龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTKNetwork.h"
#import "FuHttpMethod.h"
#import "FuError.h"

NS_ASSUME_NONNULL_BEGIN

@class FuHttpRequest;
@protocol FuHttpRequestDelegate <NSObject>
@optional
- (void)httpStartRequest:(YTKBaseRequest *)requestObject;
- (void)httpFinishRequest:(YTKBaseRequest *)requestObject object:(id)object;
- (void)httpFailedRequest:(YTKBaseRequest *)requestObject error:(FuError *)error;
@end

@interface FuHttpRequest : NSObject
@property (nonatomic, weak) id<FuHttpRequestDelegate> delegate;
@property (nonatomic, assign) NSInteger requestTag;
+ (id)initWithDelegate:(id<FuHttpRequestDelegate>)delegate;
- (YTKRequest *)requestGet:(NSUInteger)type param:(nullable id)param replace:(nullable NSString *)replace;
- (YTKRequest *)requestPost:(NSUInteger)type param:(nullable id)param replace:(nullable NSString *)replace;;
@end

NS_ASSUME_NONNULL_END
