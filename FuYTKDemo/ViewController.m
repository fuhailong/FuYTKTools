//
//  ViewController.m
//  FuYTKDemo
//
//  Created by 付海龙 on 2019/3/27.
//  Copyright © 2019 付海龙. All rights reserved.
//

#import "ViewController.h"
#import "FuHttpInterface.h"
#import "FuAnalysis.h"
#import "YYKit.h"
#import "Def_Item.h"

@interface ViewController ()
@property (nonatomic, strong) FuHttpInterface *http;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.http = [[FuHttpInterface alloc] init];
    
//    [self postTest];
//    [self getTest];
    
    [self testAnalysis];
}

- (void)testAnalysis
{
    NSString *jsonStr = @"{\"RC\":1,\"data\":{\"array\":[{\"name\":\"fu\",\"address\":\"北京\"},{\"name\":\"hai\",\"tel\":8888},{\"name\":\"long\",\"is_working\":true}]}}";
    
    FuAnalysis *analysis = [[FuAnalysis alloc] init];
    id object = [analysis analysisData:@"abc/def" object:[jsonStr jsonValueDecoded]];
    if ([object isKindOfClass:[Def_Item class]]) {
        Def_Item *item = (Def_Item *)object;
        [item.data.array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Def_Array_Item *item = (Def_Array_Item *)obj;
            NSLog(@"%@", item.name);
        }];
    }
}

- (void)postTest {
    [[self.http http_testPost:@"abc"] setResultBlock:^(BOOL isSuccess, id  _Nonnull object) {
        if (isSuccess) {
            NSLog(@"请求成功");
        }else {
            NSLog(@"请求失败");
        }
    }];
}

- (void)getTest {
    [[self.http http_testGet] setResultBlock:^(BOOL isSuccess, id  _Nonnull object) {
        if (isSuccess) {
            NSLog(@"请求成功");
        }else {
            NSLog(@"请求失败");
        }
    }];
}

@end
