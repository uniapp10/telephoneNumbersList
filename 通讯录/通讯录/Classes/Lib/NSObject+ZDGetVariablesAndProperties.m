//
//  NSObject+ZDGetVariablesAndProperties.m
//  RunTime获取类的变量和属性
//
//  Created by zhudong on 16/9/6.
//  Copyright © 2016年 zhudong. All rights reserved.
//

#import "NSObject+ZDGetVariablesAndProperties.h"
#import <objc/runtime.h>

@implementation NSObject (ZDGetVariablesAndProperties)
+ (NSArray *)getVariables:(id)object{
    unsigned int count;
    Ivar *ivars = class_copyIvarList([object class], &count);
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char *keyChar = ivar_getName(ivar);
        NSString *keyStr = [NSString stringWithCString:keyChar encoding:NSUTF8StringEncoding];
        [arrM addObject:keyStr];
    }
    return [arrM copy];
}
+ (NSArray *)getMethods:(id)object{
    unsigned int outCount;
    Method *methods = class_copyMethodList([object class], &outCount);
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:outCount];
    for (int i = 0; i < outCount; i ++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        Method method = methods[i];
        NSString *returnStr = [NSString stringWithCString:method_copyReturnType(method) encoding:NSUTF8StringEncoding];
        dict[@"returnStr"] = returnStr;
        NSString *methodName = NSStringFromSelector(method_getName(method));
        dict[@"methodName"] = methodName;
        int argumentsCount = method_getNumberOfArguments(method);
        for (int j = 0; j < argumentsCount; j++) {
            NSString *argumentStr = [NSString stringWithCString:method_copyArgumentType(method, j) encoding:NSUTF8StringEncoding];
            dict[[NSString stringWithFormat:@"arg%zd",j]] = argumentStr;
        }
        [arrM addObject:dict];
    }
    return [arrM copy];
}
@end
