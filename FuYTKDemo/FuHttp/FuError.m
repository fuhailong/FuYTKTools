//
//  FuError.m
//  FuHttpDemo
//
//  Created by 付海龙 on 2019/3/26.
//  Copyright © 2019 付海龙. All rights reserved.
//

#import "FuError.h"

@implementation FuError

- (id)initWithText:(NSString *)text errCode:(NSInteger)code {
    self = [super init];
    if (self) {
        self.text = text;
        self.code = code;
    }
    
    return self;
}

@end
