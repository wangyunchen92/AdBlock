//
//  UIViewController+ResportStatistics.m
//  AdBlocks
//
//  Created by Sj03 on 2018/11/22.
//  Copyright © 2018 Sj03. All rights reserved.
//

#import "UIViewController+ResportStatistics.h"
#import <objc/runtime.h>


@implementation UIViewController (ResportStatistics)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 假如要打开controller的统计 ,则把下面这行代码打开
        __gbh_tracer_swizzleMethod([self class], @selector(viewDidAppear:), @selector(__gbh_tracer_viewDidAppear:));
        __gbh_tracer_swizzleMethod([self class], @selector(sendAction:to:forEvent:), @selector(__gbh_tracer_sendAction:to:forEvent:));
    });
}

void __gbh_tracer_swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector){
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)__gbh_tracer_viewDidAppear:(BOOL)animated {
    [self __gbh_tracer_viewDidAppear:animated];  //由于方法已经被交换,这里调用的实际上是viewDidAppear:方法
    // 统计在设置里的VC
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ResportStatistics" ofType:@"plist"];
    NSDictionary *arr = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *resportStatisticsVC = [arr arrayForKey:@"ReportStatisticsVC"];
    if ([resportStatisticsVC containsObject:NSStringFromClass([self class])]) {
        [ReportStatisticsTool reportStatisticSerialNumber:NSStringFromClass([self class]) jsonDataString:@""];
    }
}



@end
