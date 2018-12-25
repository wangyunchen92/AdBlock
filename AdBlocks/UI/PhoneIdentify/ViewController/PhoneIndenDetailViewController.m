//
//  PhoneIndenDetailViewController.m
//  AdBlocks
//
//  Created by Sj03 on 2018/12/7.
//  Copyright © 2018 Sj03. All rights reserved.
//

#import "PhoneIndenDetailViewController.h"
#import "NewTableViewController.h"

@interface PhoneIndenDetailViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong)NewTableViewController *NewVC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *cmccLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaDLabel;
@property (weak, nonatomic) IBOutlet UIImageView *promptImage;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;
@property (assign, nonatomic)BOOL canScroll;

@end

@implementation PhoneIndenDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewTopConstraint.constant = iPhoneX ? 88 : 64;
    [self createNavWithTitle:@"查询结果" leftImage:@"Whiteback" rightImage:nil];
    self.theSimpleNavigationBar.backgroundColor = RGB(0, 166, 78);
    [self.theSimpleNavigationBar.titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.theSimpleNavigationBar.bottomLineView.backgroundColor = [UIColor clearColor];
    self.scrollerView.delegate = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)loadUIData {
    self.canScroll = YES;
    NewTableViewController *VC = [[NewTableViewController alloc] initWithType:@"all"];
    [self addChildViewController:VC];
    [self.scrollerView addSubview:VC.view];
    VC.needScrollForScrollerView = NO;
    [VC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(400);
        make.height.equalTo(self.view.mas_height).offset(-self.viewTopConstraint.constant );
        make.bottom.mas_offset(0);
    }];
    self.NewVC = VC;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScrollStatus) name:@"leaveTop" object:nil];
    
//    VC.block_scroller = ^(CGFloat floa) {
//        if (floa > 0 && floa<518) {
//            [UIView animateWithDuration:1 animations:^{
//                self.viewTopConstraint.constant = iPhoneX ? 88 : 64 - floa;
//                [self.NewVC.view mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.top.mas_equalTo(518-floa);
//                }];
//            }];
//        }
//    };
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat newtableViewScroller = 400;
    
    CGFloat offY = scrollView.contentOffset.y;
    if (offY < 0) {
        scrollView.contentOffset = CGPointZero;
    }
    
    if (scrollView.contentOffset.y >= newtableViewScroller) {
        scrollView.contentOffset = CGPointMake(0, newtableViewScroller);
        if (self.canScroll) {
            self.canScroll = NO;
            self.NewVC.canScroll = YES;
        }
    } else {
        if (!self.canScroll) {//子视图没到顶部
            scrollView.contentOffset = CGPointMake(0, newtableViewScroller);
        }
    }
    self.scrollerView.showsVerticalScrollIndicator = _canScroll?YES:NO;
}


- (void)viewWillAppear:(BOOL)animated {
    if (self.model) {
        self.areaLabel.text = self.model.area;
        self.areaDLabel.text = self.model.area;
        self.phoneNumberLabel.text = self.model.phoneNum;
        self.cmccLabel.text = self.model.cmcc;
        self.typeLabel.text = self.model.type;
        if ([self.model.type containsString:@"销售"] || [self.model.type containsString:@"诈骗"]||[self.model.type containsString:@"可疑"]) {
            self.typeLabel.textColor = [UIColor redColor];
            self.promptImage.hidden = NO;
        } else {
            self.typeLabel.textColor = [UIColor blackColor];
            self.promptImage.hidden = YES;
        }
        if ([self.model.type isEqualToString:@""]) {
            self.typeLabel.text = @"正常号码";
        }
    }
}

- (void)changeScrollStatus//改变主视图的状态
{
    self.canScroll = YES;
    self.NewVC.canScroll = NO;
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
