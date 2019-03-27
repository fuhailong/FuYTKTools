//
//  FuHttpInterface.m
//  FuHttpDemo
//
//  Created by 付海龙 on 2019/3/25.
//  Copyright © 2019 付海龙. All rights reserved.
//

#import "FuHttpInterface.h"
#import "YYKit.h"

@implementation FuHttpInterface

- (YTKRequest *)http_testPost:(NSString *)str {
    NSDictionary *param = nil;
    if (str.isNotBlank) {
        param = @{@"query":str};
    }
    return [self requestPost:TEST_POST param:param replace:nil];
}

- (YTKRequest *)http_testGet {
    return [self requestGet:TEST_GET param:nil replace:nil];
}

@end
