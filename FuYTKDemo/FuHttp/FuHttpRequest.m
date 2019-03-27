//
//  FuHttpRequest.m
//  FuHttpDemo
//
//  Created by 付海龙 on 2019/3/25.
//  Copyright © 2019 付海龙. All rights reserved.
//

#ifdef DEBUG
#define DLog(format, ...) printf("%s [Line %d] %s \n", __PRETTY_FUNCTION__, __LINE__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String])
#else
#define DLog(format, ...)
#endif

#import "FuHttpRequest.h"
#import "YTKRequest+FuHttp.h"
#import "FuAnalysis.h"
#import "YYKit.h"

@implementation FuHttpRequest

- (void)dealloc {
    self.delegate = nil;
}

+ (id)initWithDelegate:(id<FuHttpRequestDelegate>)delegate {
    return [[[self class] alloc] initWithDelegate:delegate];
}

- (id)initWithDelegate:(id<FuHttpRequestDelegate>)delegate {
    self = [super init];
    if (self) {
        self.requestTag = 0;
        self.delegate = delegate;
    }
    return self;
}

#pragma mark - 请求

- (YTKRequest *)requestGet:(NSUInteger)type param:(nullable id)param replace:(nullable NSString *)replace {
    YTKRequest *ytk = [YTKRequest getYTK:type
                                   param:param
                             requestType:YTKRequestMethodGET
                                 replace:replace];
    return [self request:ytk type:type];
}

- (YTKRequest *)requestPost:(NSUInteger)type param:(nullable id)param replace:(nullable NSString *)replace {
    YTKRequest *ytk = [YTKRequest getYTK:type
                                   param:param
                             requestType:YTKRequestMethodPOST
                                 replace:replace];
    return [self request:ytk type:type];
}

- (YTKRequest *)request:(YTKRequest *)ytk type:(NSUInteger)type {
    //开始发送请求
    if (self.delegate && [self.delegate respondsToSelector:@selector(httpStartRequest:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate httpStartRequest:ytk];
        });
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [ytk startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            //请求成功
            [self requestSuccess:ytk request:request];
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            //请求失败
            FuError *error = FuError(@"请求失败", 9999);
            [self requestFailure:ytk request:request error:error];
        }];
    });
    
    return ytk;
}

#pragma mark - 数据

- (void)requestSuccess:(YTKRequest *)ytk request:(YTKBaseRequest *)request {
    if ([request.responseObject isKindOfClass:[NSData class]]) {
        FuError *error = FuError(@"未知的网络错误", 9999);
        [self requestFailure:ytk request:request error:error];
    }else {
#if DEBUG
        DLog(@"数据信息: [%@]---json=%@\n", request.requestUrl, [request.responseObject jsonStringEncoded]);
#endif
        FuError *error = [self checkResponseData:ytk request:request object:request.responseObject];
        if (error == nil) {
            NSString *method = [[FuHttpMethod sharedMethod] typeMethod:ytk.FuHttpType.unsignedIntegerValue];
            method = [method stringByReplacingOccurrencesOfString:@"/<id>" withString:@""];
            
            //检查有没有对应的Model，如果有则使用YYModel解析，没有则将对应的内容输出，并返回nil
            FuAnalysis *analysis = [[FuAnalysis alloc] init];
            id object = [analysis analysisData:method object:request.responseObject];
            
            if (object != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.delegate && [self.delegate respondsToSelector:@selector(httpFinishRequest:object:)]) {
                        [self.delegate httpFinishRequest:request object:object];
                    }
                    if (ytk.resultBlock) {
                        ytk.resultBlock(YES, object);
                    }
                });
            }else {
                NSAssert(NO, @"缺少Model文件，请查看控制台输出添加对应的Model文件");
            }
        }else {
            [self requestFailure:ytk request:request error:error];
        }
    }
}

- (void)requestFailure:(YTKRequest *)ytk request:(YTKBaseRequest *)request error:(FuError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(httpFailedRequest:error:)]) {
            [self.delegate httpFailedRequest:request error:error];
        }
        if (ytk.resultBlock) {
            ytk.resultBlock(NO, error);
        }
    });
}

#pragma mark - 判断是否出错

- (FuError *)checkResponseData:(YTKRequest *)ytk request:(YTKBaseRequest *)request object:(NSDictionary *)dict {
    if (dict == nil) {
        return FuError(@"未知的网络错误", 9999);
    }else {
        if ([dict.allKeys containsObject:@"RC"]) {
            if ([dict[@"RC"] integerValue] != 1) {
                //错误标识
                if ([dict.allKeys containsObject:@"error"]) {
                    //错误 需要读取plist错误码
                    id obj = dict[@"error"];
                    if (obj && ![obj isKindOfClass:[NSNull class]]) {
                        NSString *errorMessage = @"";
                        if ([dict.allKeys containsObject:@"message"]) {
                            errorMessage = dict[@"message"];
                        }
                        NSNumber *code = (NSNumber *)obj;
                        if (errorMessage.isNotBlank == NO) {
                            /*
                            NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"error" ofType:@"plist"];
                            NSDictionary *errorDict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
                            if ([errorDict.allKeys containsObject:code.description]) {
                                NSString *error = errorDict[code.description];
                                errorMessage = Get_String(error);
                            }
                             */
                            //读取plist获取error信息
                        }
                        return FuError(errorMessage, code.integerValue);
                    }else {
                        return FuError(@"未知的网络错误", 9999);
                    }
                }
            }else {
                //成功标识
                
            }
        }
    }
    
    return nil;
}

@end
