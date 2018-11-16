//
//  LocationManage.h
//  daikuanchaoshi
//
//  Created by Sj03 on 2017/11/28.
//  Copyright © 2017年 Sj03. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationManage : NSObject
+ (instancetype)shareLocationManage;
- (void)startLocation:(void(^)(NSString * lon, NSString * lat, NSString *name))successBlock andfailureBlock:(void(^)(void))faildBlock;
@end
