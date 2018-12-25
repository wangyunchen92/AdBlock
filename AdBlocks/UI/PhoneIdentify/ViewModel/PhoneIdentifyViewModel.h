//
//  PhoneIdentifyViewModel.h
//  AdBlocks
//
//  Created by Sj03 on 2018/12/11.
//  Copyright © 2018 Sj03. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhoneTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PhoneIdentifyViewModel : NSObject
@property (nonatomic, strong)RACSubject *subject_getData;
@property (nonatomic, strong)PhoneTypeModel *model;
@property (nonatomic, copy)void (^block_getData)(PhoneTypeModel *model);



@end

NS_ASSUME_NONNULL_END
