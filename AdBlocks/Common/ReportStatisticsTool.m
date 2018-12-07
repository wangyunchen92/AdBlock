//
//  ReportStatisticsTool.m
//  ColorfulFund
//
//  Created by Madis on 16/10/8.
//  Copyright © 2016年 zritc. All rights reserved.
//

#import "ReportStatisticsTool.h"

@implementation ReportStatisticsTool

+ (void)reportStatisticSerialNumber:(NSString *)serialNumber jsonDataString:(NSString *)string {
    // 自定义事件的数据默认是下次启动时发送
    [MobClick event:serialNumber label:string];
}

+ (void)reportStatisticBeginEventID:(NSString *)eventID jsonDataString:(NSString *)string {
    [MobClick beginEvent:eventID];
}

+ (void)reportStatisticEndEventID:(NSString *)eventID jsonDataString:(NSString *)string {
    [MobClick endEvent:eventID];
}

+ (void)reportStatisticBeginLogPageView:(NSString *)pageView {
    [MobClick beginLogPageView:pageView];
}

+ (void)reportStatisticEndLogPageView:(NSString *)pageView {
    [MobClick endLogPageView:pageView];
}


+(NSString *)reportStatisticStringForString:(NSString *)str {
    if ([str isEqualToString:@"CallBlockViewControllerSel"]) {
        return @"电话点击";
    }
    if ([str isEqualToString:@"PictureClearListViewControllerSel"]) {
        return @"相册清理点击";
    }
    if ([str isEqualToString:@"MessageGroupListViewControllerSel"]) {
        return @"短信拦截点击";
    }
    if ([str isEqualToString:@"NetWorkSpeedViewControllerSel"]) {
        return @"检测网速点击";
    }
    if ([str isEqualToString:@"WeiChatControllerSel"]) {
        return @"微信清理点击";
    }
    if ([str isEqualToString:@"BatterViewControllerSel"]) {
        return @"电池管理点击";
    }
    return nil;
}
@end
