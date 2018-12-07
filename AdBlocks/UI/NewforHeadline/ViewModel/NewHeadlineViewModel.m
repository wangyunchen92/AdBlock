//
//  NewHeadlineViewModel.m
//  Constellation
//
//  Created by Sj03 on 2018/3/23.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import "NewHeadlineViewModel.h"
#import "NewsModel.h"
#import "GDTNativeExpressAd.h"
#import "GDTNativeExpressAdView.h"


@interface NewHeadlineViewModel()<GDTNativeExpressAdDelegete>
@property (nonatomic, strong) NSMutableArray *midoArray;
@property (nonatomic, strong) GDTNativeExpressAd *nativeExpressAd;
@property (nonatomic, assign) NSInteger adPosition;
@property (nonatomic, assign) BOOL isFirstGetData;
@end
@implementation NewHeadlineViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.isadd = YES;
        self.isFirstGetData = YES;
        _midoArray = [[NSMutableArray alloc] init];
        self.pagString = @"1";
        _adPosition = [UserDefaultsTool getIntWithKey:IntAdPosition withDefault:3];
    }
    return self;
}

- (void)initSigin {
    [self.subject_getDate subscribeNext:^(id x) {
        HttpRequestMode* model = [[HttpRequestMode alloc]init];
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params addUnEmptyString:self.typeString forKey:@"type"];
        [params addUnEmptyString:self.pagString forKey:@"p"];
        model.parameters = params;
        model.url = GetNews;
        model.name = @"新闻列表";
        [[HttpClient sharedInstance]requestApiWithHttpRequestMode:model Success:^(HttpRequest *request, HttpResponse *response) {
            NSArray *arr = [response.result arrayForKey:@"object"];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                // type other 为广告
                if ([obj[@"type"] isEqualToString:@"other"]) {
                    return;
                }
                NewsModel *model = [[NewsModel alloc] init];
                [model getDateForServer:obj];
                if (self.isadd) {
                    [self.midoArray addObject:model];
                } else {
                    [self.dataArray insertObject:model atIndex:0];
                }
            }];
            self.nativeExpressAd = [[GDTNativeExpressAd alloc] initWithAppId:KQQAdvID placementId:kQQAdvYSKey adSize:CGSizeMake(0, 0)];
            self.nativeExpressAd.delegate = self;
            [self.nativeExpressAd loadAd:(10 / self.adPosition)]; //这里以一次拉取一条原生广告为例
        } Failure:^(HttpRequest *request, HttpResponse *response) {
            [BasePopoverView showFailHUDToWindow:response.errorMsg];
        } RequsetStart:^{
            
        } ResponseEnd:^{
        }];
    }];
}

- (void)nativeExpressAdSuccessToLoad:(GDTNativeExpressAd *)nativeExpressAd views:(NSArray<__kindof GDTNativeExpressAdView *> *)views
{
    self.expressAdViews = [NSMutableArray arrayWithArray:views];
    if (self.expressAdViews.count) {
        __block NSInteger i = 0;
        if (self.isadd) {
            if (self.isFirstGetData) {
                [self.expressAdViews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    GDTNativeExpressAdView *expressView = (GDTNativeExpressAdView *)obj;
                    expressView.controller = self.adVC;
                    [expressView render];
                    if (idx == 0) {
                        [self.midoArray insertObject:expressView atIndex:3];
                    } else if (idx == 1){
                        [self.midoArray insertObject:expressView atIndex:self.adPosition+4];
                    }
                }];
                [self.midoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [self.dataArray addObject:obj];
                }];
                [self.midoArray removeAllObjects];
            } else {
                NSInteger inde = self.midoArray.count / self.adPosition + 1;
                [self.expressAdViews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    GDTNativeExpressAdView *expressView = (GDTNativeExpressAdView *)obj;
                    expressView.controller = self.adVC;
                    if (idx < inde) {
                        [expressView render];
                        [self.midoArray insertObject:expressView atIndex:i+3];
                        i = i + self.adPosition + 1;
                    }
                }];
                [self.midoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [self.dataArray addObject:obj];
                }];
                [self.midoArray removeAllObjects];
            }
        } else {
            [self.expressAdViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                GDTNativeExpressAdView *expressView = (GDTNativeExpressAdView *)obj;
                expressView.controller = self.adVC;
                [expressView render];
                [self.dataArray insertObject:expressView atIndex:i+3];
                i = i + self.adPosition + 1+1;
            }];
        }
        _isAdLoadSuccess = YES;
        _isFirstGetData = NO;
        _aDnum = 0;
        if (self.block_reloadDate) {
            self.block_reloadDate();
        }
    }
}

/**
 * 拉取广告失败的回调
 */
- (void)nativeExpressAdRenderFail:(GDTNativeExpressAdView *)nativeExpressAdView
{
    _aDnum = 0;
    
    if (self.block_reloadDate) {
        self.block_reloadDate();
    }
}

- (void)nativeExpressAdViewClicked:(GDTNativeExpressAdView *)nativeExpressAdView {
    
}

- (void)nativeExpressAdViewClosed:(GDTNativeExpressAdView *)nativeExpressAdView {
    [self.dataArray removeObject:nativeExpressAdView];
    if (self.block_reloadDate) {
        self.block_reloadDate();
    }
}

@end
