//
//  PhoneTypeModel.m
//  AdBlocks
//
//  Created by Sj03 on 2018/12/11.
//  Copyright © 2018 Sj03. All rights reserved.
//

#import "PhoneTypeModel.h"

@implementation PhoneTypeModel
- (instancetype)init {
    self = [super init];
    if (self) {
        _phoneNum = @"";
        _area = @"";
        _cmcc = @"";
        _type = @"";
    }
    return self;
}

- (void)getModelForServer:(NSDictionary *)dic {
    self.phoneNum = [dic stringForKey:@"phone"];
    self.area = [dic stringForKey:@"area"];
    self.cmcc = [dic stringForKey:@"cmcc"];
    self.type = [dic stringForKey:@"type"];
}
@end
