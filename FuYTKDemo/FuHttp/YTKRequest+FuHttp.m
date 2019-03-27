//
//  YTKRequest+FuHttp.m
//  FuHttpDemo
//
//  Created by 付海龙 on 2019/3/25.
//  Copyright © 2019 付海龙. All rights reserved.
//

#import "YTKRequest+FuHttp.h"
#import "FuHttpMethod.h"
#import "YYKit.h"

@implementation YTKRequest (FuHttp)

static NSString *fUrlKey            = @"F_URL_KEY";
static NSString *paramKey           = @"PARAM_KEY";
static NSString *resultBlockKey     = @"RESULT_BLOCK_KEY";
static NSString *fuHttpTypeKey      = @"RESULT_BLOCK_KEY";
static NSString *requestTypeKey     = @"REQUEST_TYPE_KEY";

- (void)setFUrl:(NSString *)fUrl {
    objc_setAssociatedObject(self, &fUrlKey, fUrl, OBJC_ASSOCIATION_COPY);
}

- (NSString *)fUrl {
    return objc_getAssociatedObject(self, &fUrlKey);
}

- (void)setParam:(NSDictionary *)param {
    objc_setAssociatedObject(self, &paramKey, param, OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *)param {
    return objc_getAssociatedObject(self, &paramKey);
}

- (void)setFuHttpType:(NSNumber *)FuHttpType {
    objc_setAssociatedObject(self, &fuHttpTypeKey, FuHttpType, OBJC_ASSOCIATION_COPY);
}

- (NSNumber *)FuHttpType {
    return objc_getAssociatedObject(self, &fuHttpTypeKey);
}

- (void)setResultBlock:(void (^)(BOOL, id _Nonnull))block {
    objc_setAssociatedObject(self, &resultBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (RequestResult)resultBlock {
    return objc_getAssociatedObject(self, &resultBlockKey);
}

- (void)setRequestType:(NSNumber *)requestType
{
    objc_setAssociatedObject(self, &requestTypeKey, requestType, OBJC_ASSOCIATION_COPY);
}

- (NSNumber *)requestType
{
    return objc_getAssociatedObject(self, &requestTypeKey);
}

- (void)setRequestType:(NSUInteger)type param:(NSDictionary *)param requestType:(NSInteger)requestType replace:(NSString *)replace {
    NSString *url = [[FuHttpMethod sharedMethod] typeMethod:type];
    if ([url containsString:@"<id>"]) {
        if (replace.isNotBlank) {
            self.fUrl = [url stringByReplacingOccurrencesOfString:@"<id>"
                                                       withString:replace];
        }else {
            self.fUrl = [url stringByReplacingOccurrencesOfString:@"<id>"
                                                       withString:@""];
        }
    }else {
        self.fUrl = url;
    }
    self.param = param;
    self.FuHttpType = [NSNumber numberWithUnsignedInteger:type];
    self.requestType = [NSNumber numberWithInteger:requestType];
}

+ (YTKRequest *)getYTK:(NSUInteger)type param:(NSDictionary *)param requestType:(NSInteger)requestType replace:(NSString *)replace {
    YTKRequest *ytk = [[YTKRequest alloc] init];
    [ytk setRequestType:type
                  param:param
            requestType:requestType
                replace:replace];
    return ytk;
}

- (void)resultBlock:(void (^) (BOOL isSuccess, id object))block {
    self.resultBlock = block;
}

#pragma mark - 重写YTKRequest方法

- (NSString *)requestUrl {
    return self.fUrl;
}

- (nullable id)requestArgument {
    return self.param;
}

- (NSTimeInterval)requestTimeoutInterval {
    return 10;
}

- (YTKRequestMethod)requestMethod {
    return self.requestType.integerValue;
}

- (nullable NSDictionary<NSString *, NSString *> *)requestHeaderFieldValueDictionary {
    return @{};
}

@end
