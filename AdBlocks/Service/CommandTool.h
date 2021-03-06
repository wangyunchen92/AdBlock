//
//  CommandTool.h
//  daikuanchaoshi
//
//  Created by Sj03 on 2018/1/2.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommandTool : NSObject
@property (nonatomic, strong)RACCommand *command_haveNewVersion; // 检查新版本
@property (nonatomic, strong)RACCommand *command_isReview; // 检查新版本
@property (nonatomic, strong)RACCommand *command_getAdInformation;
@property (nonatomic, strong)RACCommand *command_checkAdv; //检查广告


@end
