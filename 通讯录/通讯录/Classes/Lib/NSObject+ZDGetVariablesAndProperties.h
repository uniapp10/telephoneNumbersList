//
//  NSObject+ZDGetVariablesAndProperties.h
//  RunTime获取类的变量和属性
//
//  Created by zhudong on 16/9/6.
//  Copyright © 2016年 zhudong. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (ZDGetVariablesAndProperties)
+ (NSArray *)getVariables:(id)object;
+ (NSArray *)getMethods:(id)object;
@end
