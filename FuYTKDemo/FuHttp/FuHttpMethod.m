//
//  FuHttpMethod.m
//  FuHttpDemo
//
//  Created by 付海龙 on 2019/3/25.
//  Copyright © 2019 付海龙. All rights reserved.
//

#import "FuHttpMethod.h"
#import "FuHttpInfo.h"
#import "YYKit.h"

#define fu_http_info(m,t) [[FuHttpInfo alloc] initWithMethod:m type:t]
#define HTTP_INFO(m,t) if(type == t){info = fu_http_info(m,t);}

@implementation FuHttpMethod

+ (FuHttpMethod *)sharedMethod {
    static FuHttpMethod *method = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        method = [[FuHttpMethod alloc] init];
    });
    return method;
}

- (id)init {
    self = [super init];
    if (self) {
        self.infos = [[NSMutableDictionary alloc] init];
        for (FuHttpType type = FU_HTTP_BEGIN + 1; type < FU_HTTP_END; type++) {
            FuHttpInfo *info = nil;
            //-------------------------------------------------
            HTTP_INFO(@"mmztemplate/getStandardUrl", TEST_POST);
            HTTP_INFO(@"mmzindex/activityList", TEST_GET);
            
            //-------------------------------------------------
            
            if (info) {
                NSString *key = [info dictKey];
                NSDictionary *dict = [info modelToJSONObject];
                [self.infos setObject:dict forKey:key];
            }
        }
    }
    return self;
}

- (NSString *)typeMethod:(NSUInteger)type {
    NSString *key = [NSString stringWithFormat:@"fuHttp%ld", (long)type];
    NSDictionary *dict = [self.infos objectForKey:key];
    if (dict) {
        FuHttpInfo *info = [FuHttpInfo modelWithDictionary:dict];
        return info.method;
    }
    
    return nil;
}

@end
