//
//  PhoneTypeModel.h
//  AdBlocks
//
//  Created by Sj03 on 2018/12/11.
//  Copyright © 2018 Sj03. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhoneTypeModel : NSObject
@property (nonatomic, copy)NSString *phoneNum;
@property (nonatomic, copy)NSString *area;
@property (nonatomic, copy)NSString *type;
@property (nonatomic, copy)NSString *cmcc;
- (void)getModelForServer:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
