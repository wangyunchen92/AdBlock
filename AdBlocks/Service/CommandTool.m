//
//  CommandTool.m
//  daikuanchaoshi
//
//  Created by Sj03 on 2018/1/2.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import "CommandTool.h"
#import "YMUpdateView.h"

@interface CommandTool ()


@end

@implementation CommandTool

- (instancetype)init {
    self = [super init];
    if (self) {
      
        [self initCommand];
    }
    return self;
}

- (void)initCommand {

    self.command_haveNewVersion = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            HttpRequestMode *model = [[HttpRequestMode alloc]init];
            model.name= @"获取更新信息";
            model.url = GetApkUpdate;
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params addUnEmptyString:@"default_channel" forKey:@"channel_key"];
            [params addUnEmptyString:@"com.AdBlock.youmeng" forKey:@"package_name"];
            model.parameters = params;
            [[HttpClient sharedInstance]requestApiWithHttpRequestMode:model Success:^(HttpRequest *request, HttpResponse *response) {
                [BasePopoverView hideHUDForWindow:YES];
                YMUpdateView *updateView = [[YMUpdateView alloc] initWithTitle:[NSString stringWithFormat:@"%@", [response.result objectForKey:@"title"]] imgStr:nil message:[NSString stringWithFormat:@"%@", [response.result objectForKey:@"description"]] sureBtn:@"立即更新" cancleBtn:@"取消"];
                updateView.resultIndex = ^(NSInteger index){
                    if (index == 1) {
                        [subscriber sendNext:@YES];
                        [subscriber sendCompleted];
                    } else {
                        dispatch_main_async(^{
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[response.result objectForKey:@"url"]]];
                        });
                    }
                };
                [updateView showXLAlertView];
            } Failure:^(HttpRequest *request, HttpResponse *response) {
                [subscriber sendError:nil];
                
            } RequsetStart:^{
                
            } ResponseEnd:^{
                
            }];
            
            return nil;
        }];
    }];
    
    
    
    self.command_isReview = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            HttpRequestMode *model = [[HttpRequestMode alloc]init];
            model.name= @"app状态";
            model.url = GetStatus;
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params addUnEmptyString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"] forKey:@"package_name"];
            model.parameters = params;
            
            [[HttpClient sharedInstance] requestApiWithHttpRequestMode:model Success:^(HttpRequest *request, HttpResponse *response) {
                [BasePopoverView hideHUDForWindow:YES];
                NSString *isstate = [response.result stringForKey:@"object"];
                if ([isstate isEqualToString:@"off"]) {
                    [subscriber sendNext:@YES];
                    [subscriber sendCompleted];
                } else {
                    [subscriber sendNext:@NO];
                    [subscriber sendCompleted];
                }
            } Failure:^(HttpRequest *request, HttpResponse *response) {
                [subscriber sendError:nil];
                [subscriber sendCompleted];
            } RequsetStart:^{
                
            } ResponseEnd:^{
                
            }];
            
            return nil;
        }];
    }];
    
    
    
    self.command_checkAdv = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        __block NSInteger i = 0;
        
        RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            HttpRequestMode *model = [[HttpRequestMode alloc]init];
            model.name= @"app广告位信息";
            model.url = GetAdPosition;
            [[HttpClient sharedInstance] requestApiWithHttpRequestMode:model Success:^(HttpRequest *request, HttpResponse *response) {
                
                i = i + 1;
                [BasePopoverView hideHUDForWindow:YES];
                [UserDefaultsTool setInt:[[response.result stringForKey:@"object"] intValue] withKey:IntAdPosition];
                if (i > 1) {
                    [subscriber sendNext:@YES];
                    [subscriber sendCompleted];
                }
                
            } Failure:^(HttpRequest *request, HttpResponse *response) {
                [subscriber sendNext:nil];
                
            } RequsetStart:^{
                
            } ResponseEnd:^{
                
            }];
            return  nil;
        }];
        
        RACSignal *signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            HttpRequestMode *model = [[HttpRequestMode alloc]init];
            model.name= @"广告位";
            model.url = GetChannel;
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params addUnEmptyString:@"com.AdBlock.youmeng" forKey:@"channel_key"];
            [params addUnEmptyString:@"com.AdBlock.youmeng" forKey:@"package_name"];
            [params addUnEmptyString:@"lj" forKey:@"show_key"];
            model.parameters = params;
            [[HttpClient sharedInstance]requestApiWithHttpRequestMode:model Success:^(HttpRequest *request, HttpResponse *response) {
                i = i + 1;
                BOOL open = [[response.result stringForKey:@"coopen_ad"] isEqualToString:@"1"] ? YES : NO;
                [UserDefaultsTool setBool:open withKey:@"coopen_ad"];
                
                if (i > 1) {
                    [subscriber sendNext:@YES];
                    [subscriber sendCompleted];
                }
                
            } Failure:^(HttpRequest *request, HttpResponse *response) {
                [subscriber sendNext:@YES];
                [UserDefaultsTool setBool:NO withKey:@"coopen_ad"];
            } RequsetStart:^{
                
            } ResponseEnd:^{
                
            }];
            return  nil;
        }];
        
        
        RACSignal *concatSignal = [RACSignal merge:@[signal1, signal2]];
        
        return concatSignal;

    }];

 
    
}
@end
