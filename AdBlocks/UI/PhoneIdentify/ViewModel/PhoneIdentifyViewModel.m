//
//  PhoneIdentifyViewModel.m
//  AdBlocks
//
//  Created by Sj03 on 2018/12/11.
//  Copyright © 2018 Sj03. All rights reserved.
//

#import "PhoneIdentifyViewModel.h"

@interface PhoneIdentifyViewModel()


@end

@implementation PhoneIdentifyViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        _subject_getData = [[RACSubject alloc] init];
        _model = [[PhoneTypeModel alloc] init];
    }
    [self initSigin];
    return self;
}

- (void)initSigin {
    
    [self.subject_getData subscribeNext:^(NSString *phone) {
        HttpRequestMode* model = [[HttpRequestMode alloc]init];
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params addUnEmptyString:phone forKey:@"phone"];
        model.parameters = params;
        model.url = GetPhoneInfo;
        model.name = @"电话查询";
        [BasePopoverView showHUDToWindow:YES withMessage:@"查询中"];
        [[HttpClient sharedInstance] requestApiWithHttpRequestMode:model Success:^(HttpRequest *request, HttpResponse *response) {
            [BasePopoverView hideHUDForWindow:YES];
            [self.model getModelForServer:response.result];
            if (self.block_getData) {
                self.block_getData(self.model);
            }
        } Failure:^(HttpRequest *request, HttpResponse *response) {
            [BasePopoverView hideHUDForWindow:YES];
            [BasePopoverView showFailHUDToWindow:response.errorMsg];
        }];
    }];
    
}

@end
