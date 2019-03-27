//
//  FuHttpInfo.m
//  FuHttpDemo
//
//  Created by 付海龙 on 2019/3/25.
//  Copyright © 2019 付海龙. All rights reserved.
//

#import "FuHttpInfo.h"
#import "FuHttpMethod.h"

@implementation FuHttpInfo

- (id)initWithMethod:(NSString *)method type:(NSUInteger)type {
    self = [super init];
    if (self) {
        self.method = method;
        self.type = (type == FU_HTTP_BEGIN)?[NSNumber numberWithInteger:FU_HTTP_BEGIN]:[NSNumber numberWithInteger:type];
    }
    return self;
}

- (NSString *)dictKey {
    return [NSString stringWithFormat:@"fuHttp%@", self.type];
}

@end
