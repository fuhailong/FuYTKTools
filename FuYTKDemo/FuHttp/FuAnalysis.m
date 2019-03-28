//
//  FuAnalysis.m
//  FuHttpDemo
//
//  Created by 付海龙 on 2019/3/27.
//  Copyright © 2019 付海龙. All rights reserved.
//

#import "FuAnalysis.h"
#import "YYKit.h"

@interface FuAnalysis ()
@property (nonatomic, strong) NSMutableArray *hItems;     //.h文件log
@property (nonatomic, strong) NSMutableArray *mItems;     //.m文件log
@end

@implementation FuAnalysis

- (NSMutableArray *)hItems {
    if (_hItems == nil) {
        _hItems = [NSMutableArray array];
    }
    return _hItems;
}

- (NSMutableArray *)mItems {
    if (_mItems == nil) {
        _mItems = [NSMutableArray array];
    }
    return _mItems;
}

- (id)analysisData:(NSString *)method object:(id)responseObject {
    __block NSString *className = @"";
    if ([method containsString:@"/<id>"]) {
        method = [method stringByReplacingOccurrencesOfString:@"/<id>" withString:@""];
    }
    NSArray *arr = [method componentsSeparatedByString:@"/"];
    if (arr && arr.count > 0) {
        NSString *str = arr.lastObject;
        str = [str capitalizedString];
        className = [className stringByAppendingString:str];
    }else {
        className = [method capitalizedString];
    }
    
    Class class = NSClassFromString([className stringByAppendingString:@"_Item"]);
    if (class) {
        return [class modelWithDictionary:responseObject];
    }else {
#ifdef DEBUG
        //打印数据模型内容
//        NSDictionary *dict = (NSDictionary *)responseObject;
//        [self printClassAllProperty:dict key:className];
//        return nil;
#endif
        return responseObject;
    }
}

#pragma mark - .h

- (void)printClassAllProperty:(NSDictionary *)dict key:(NSString *)key {
    //.h
    __block NSString *log = @"\n---\n\n";
    
    log = [log stringByAppendingString:[NSString stringWithFormat:@"ClassName : %@ \n\n", [key stringByAppendingString:@"_Item"]]];
    
    log = [log stringByAppendingString:@".h文件\n\n"];
    
    [self toHFileString:dict key:key className:key];
    [self.hItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        log = [log stringByAppendingString:obj];
    }];
    
    log = [log stringByAppendingString:@"\n---\n\n"];
    
    //.m
    log = [log stringByAppendingString:@".m文件\n\n"];
    
    [self toMFileString:dict key:key className:key];
    [[[self.mItems reverseObjectEnumerator] allObjects] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        log = [log stringByAppendingString:obj];
    }];
    
    log = [log stringByAppendingString:@"\n---\n"];
    
    NSLog(@"%@", log);
}

- (NSString *)getPropertyString:(id)value key:(NSString *)key className:(NSString *)className {
    NSString *propertyString = @"";
    
    if ([value isKindOfClass:[NSString class]]) {
        propertyString = [NSString stringWithFormat:@"@property (nonatomic, strong) NSString *%@;\n", key];
    }else if ([value isKindOfClass:[NSNumber class]]) {
        propertyString = [NSString stringWithFormat:@"@property (nonatomic, strong) NSNumber *%@;\n", key];
    }else if ([value isKindOfClass:[NSArray class]]) {
        propertyString = [NSString stringWithFormat:@"@property (nonatomic, strong) NSArray *%@;\n", key];
    }else if ([value isKindOfClass:[NSDictionary class]]) {
        NSString *name = [NSString stringWithFormat:@"%@_%@_Item", className, [key capitalizedString]];
        propertyString = [NSString stringWithFormat:@"@property (nonatomic, strong) %@ *%@;\n", name, key];
    }
    
    return propertyString;
}

- (void)toHFileString:(NSDictionary *)dict key:(NSString *)key className:(NSString *)className {
    __block NSString *log = @"";
    if (![key isEqualToString:className]) {
        log = [log stringByAppendingString:[NSString stringWithFormat:@"@interface %@_%@_Item : NSObject\n", className, key]];
    }else {
        log = [NSString stringWithFormat:@"@interface %@_Item : NSObject\n", key];
    }
    
    //遍历所有key
    NSArray *keys = dict.allKeys;
    //当前对象中是字典或数组的集合
    __block NSMutableArray *mutArray = [NSMutableArray arrayWithCapacity:keys.count];
    [keys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *oneKey = (NSString *)obj;
        id value = dict[oneKey];
        log = [log stringByAppendingString:[self getPropertyString:value key:oneKey className:className]];
        if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]]) {
            [mutArray addObject:@{oneKey:value}];
        }
    }];
    
    log = [log stringByAppendingString:@"@end\n\n"];
    [self.hItems insertObject:log atIndex:0];
    
    [mutArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *oneDict = (NSDictionary *)obj;
        NSString *oneKey = oneDict.allKeys.firstObject;
        id value = oneDict.allValues.firstObject;
        if ([value isKindOfClass:[NSDictionary class]]) {
            [self toHFileString:value key:[oneKey capitalizedString] className:className];
        }else {
            [self propertyIsArray:value name:[oneKey capitalizedString] className:className];
        }
    }];
}

- (void)propertyIsArray:(NSArray *)array name:(NSString *)name className:(NSString *)className {
    
    __block NSString *log = [NSString stringWithFormat:@"@interface %@_%@_Item : NSObject\n", className, name];
    
    __block NSMutableArray *propertys = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            //array中的某一个对象
            NSDictionary *dict = (NSDictionary *)obj;
            [dict.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj1, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *oneKey = (NSString *)obj1;
                if (![propertys containsObject:oneKey]) {
                    id value = dict[oneKey];
                    log = [log stringByAppendingString:[self getPropertyString:value key:oneKey className:className]];
                    [propertys addObject:oneKey];
                }
            }];
        }
    }];
    
    log = [log stringByAppendingString:@"@end\n"];
    [self.hItems insertObject:log atIndex:0];
}

#pragma mark - .m

- (void)toMFileString:(id)object key:(NSString *)key className:(NSString *)className {
    __block NSString *log = @"";
    if (![key isEqualToString:className]) {
        log = [log stringByAppendingString:[NSString stringWithFormat:@"\n@implementation %@_%@_Item\n\n", className, key]];
    }else {
        log = [NSString stringWithFormat:@"\n@implementation %@_Item\n\n", key];
    }
    
    //当前对象中是字典或数组的集合
    __block NSMutableArray *mutArray = nil;
    
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)object;
        //遍历所有key
        NSArray *keys = dict.allKeys;
        mutArray = [NSMutableArray arrayWithCapacity:keys.count];
        [keys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *oneKey = (NSString *)obj;
            id value = dict[oneKey];
            if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]]) {
                [mutArray addObject:@{oneKey:value}];
            }
        }];
    }
    
    [mutArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *oneDict = (NSDictionary *)obj;
        NSString *oneKey = oneDict.allKeys.firstObject;
        id value = oneDict.allValues.firstObject;
        if ([value isKindOfClass:[NSDictionary class]]) {
            [self toMFileString:value key:[oneKey capitalizedString] className:className];
        }else {
            log = [log stringByAppendingString:@"+ (NSDictionary *)modelContainerPropertyGenericClass {\n"];
            
            log = [log stringByAppendingString:@"   return @{\n"];
            
            log = [log stringByAppendingString:[NSString stringWithFormat:@"            @\"%@\":[%@ class],\n", oneKey, [NSString stringWithFormat:@"%@_%@_Item", className, [oneKey capitalizedString]]]];
            
            log = [log stringByAppendingString:@"           };\n"];
            
            log = [log stringByAppendingString:@"}\n\n"];
            
            [self toMFileString:value key:[oneKey capitalizedString] className:className];
        }
    }];
    
    log = [log stringByAppendingString:@"@end\n"];
    [self.mItems insertObject:log atIndex:0];
}

@end
