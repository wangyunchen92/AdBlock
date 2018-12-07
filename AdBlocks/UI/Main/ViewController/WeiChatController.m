//
//  CallBlockViewController.m
//  AdBlocks
//
//  Created by Sj03 on 2018/10/29.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import "WeiChatController.h"
#import "CallManager.h"
#import "NewPagedFlowView.h"
#import "MessageGroupListViewController.h"

@interface WeiChatController ()<NewPagedFlowViewDelegate, NewPagedFlowViewDataSource>
@property (nonatomic, strong) NewPagedFlowView *pageView;
@property (weak, nonatomic) IBOutlet UIView *boardView;
@property (nonatomic,strong)UIPageControl *pageControl;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTopConstraint;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (nonatomic, assign)NSInteger pag;
@property (weak, nonatomic) IBOutlet UILabel *fiestLabel;
@property (weak, nonatomic) IBOutlet UILabel *secendLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourLabel;

@end

@implementation WeiChatController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewTopConstraint.constant = iPhoneX ? 88 : 64;
    [self createNavWithTitle:@"微信清理引导" leftImage:@"Whiteback" rightText:nil];
    self.theSimpleNavigationBar.backgroundColor = RGB(0, 166, 78);
    self.theSimpleNavigationBar.bottomLineView.backgroundColor = [UIColor clearColor];
    [self.theSimpleNavigationBar.titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.theSimpleNavigationBar.titleButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    self.view.backgroundColor =RGB(233, 233, 233);
    self.pag = 0;
}

- (void)loadUIData {
    NewPagedFlowView *pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 50, self.boardView.frame.size.width,self.boardView.frame.size.height-50)];
    
    pageFlowView.backgroundColor = RGB(233, 233, 233);
    pageFlowView.delegate = self;
    pageFlowView.dataSource = self;
    pageFlowView.minimumPageAlpha = 0;
    pageFlowView.isCarousel = NO;
    pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
    pageFlowView.isOpenAutoScroll = NO;
    self.pageView = pageFlowView;
    [self.boardView addSubview:self.pageView];
    
    [pageFlowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(50);
        make.width.equalTo(self.boardView.mas_width).offset(0);
        make.height.equalTo(self.boardView.mas_height).offset(-50);
    }];
    
    self.dataArray = [[NSMutableArray alloc] init];
    [self.dataArray addObject:@"weiChat"];
    [self.dataArray addObject:@"weiChat1"];
    [self.dataArray addObject:@"weiChat2"];
    [self.dataArray addObject:@"weiChat3"];
    
}

- (void)viewDidAppear:(BOOL)animated {
    //初始化pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.pageView.frame.size.height + 70, kScreenWidth, 8)];
    pageControl.currentPageIndicatorTintColor = RGB(0, 166, 78);
    pageControl.pageIndicatorTintColor = UIColorFromRGB(0xababab);
    
    
    self.pageView.pageControl = pageControl;
    
    [self.boardView addSubview:pageControl];
    
    self.pageControl = pageControl;
    
    [self.pageView reloadData];
    [RACObserve(self, pag)subscribeNext:^(id x) {
        if (self.pag < self.dataArray.count - 1) {
            [self.sureButton setTitle:@"下一步" forState:UIControlStateNormal];
        } else {
           [self.sureButton setTitle:@"知道了" forState:UIControlStateNormal];
        }
    }];
}


#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake(self.boardView.size.width , self.boardView.size.height-50);
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    self.pag = pageNumber;
    switch (pageNumber) {
        case 0:
            [self changeSelLabel:self.fiestLabel];
            [self changeLabel:self.secendLabel];
            [self changeLabel:self.threeLabel];
            [self changeLabel:self.fourLabel];
            break;
        case 1:
            [self changeLabel:self.fiestLabel];
            [self changeSelLabel:self.secendLabel];
            [self changeLabel:self.threeLabel];
            [self changeLabel:self.threeLabel];
            break;
        case 2:
            [self changeLabel:self.fiestLabel];
            [self changeLabel:self.secendLabel];
            [self changeSelLabel:self.threeLabel];
            [self changeLabel:self.fourLabel];
            break;
        case 3:
            [self changeLabel:self.fiestLabel];
            [self changeLabel:self.secendLabel];
            [self changeLabel:self.threeLabel];
            [self changeSelLabel:self.fourLabel];
            break;
        default:
            break;
    }
    NSLog(@"%ld",pageNumber);
    
}

- (void)changeSelLabel:(UILabel *)label{
    [label setTextColor:RGB(0, 166, 78)];
    [label setFont:[UIFont systemFontOfSize:19]];
}

- (void)changeLabel:(UILabel *)label{
    [label setTextColor:RGB(135, 135, 135)];
    [label setFont:[UIFont systemFontOfSize:14]];
}


#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    return self.dataArray.count;
}

- (PGIndexBannerSubiew *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    PGIndexBannerSubiew *bannerView = [flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] init];
        bannerView.tag = index;
    }
    bannerView.mainImageView.image = IMAGE_NAME(self.dataArray[index]);
    
    return bannerView;
}

- (IBAction)sureButtonClick:(id)sender {
    if (self.pag < self.dataArray.count - 1) {
        [self.pageView scrollToPage:self.pag+1];
    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
