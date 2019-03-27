//
//  FuHttpInterface.h
//  FuHttpDemo
//
//  Created by 付海龙 on 2019/3/25.
//  Copyright © 2019 付海龙. All rights reserved.
//

#import "FuHttpRequest.h"
#import "YTKRequest+FuHttp.h"

NS_ASSUME_NONNULL_BEGIN

@interface FuHttpInterface : FuHttpRequest

- (YTKRequest *)http_testPost:(NSString *)str;
- (YTKRequest *)http_testGet;

@end

NS_ASSUME_NONNULL_END
