//
//  Fmdbmode.h
//  FMdbdemo
//
//  Created by 王云晨 on 16/5/24.
//  Copyright © 2016年 王云晨. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Model;
@interface Fmdbmode : NSObject

+ (instancetype)share;

- (NSMutableArray *)executeQuery:(NSString *)sql;

- (void)insterDate:(Model *)model;
@end
