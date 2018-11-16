//
//  MineViewController.m
//  Weater
//
//  Created by Sj03 on 2018/11/5.
//  Copyright © 2018 Sj03. All rights reserved.
//

#import "MineViewController.h"
#import "AboutUsViewController.h"
#import "YMFeedBackController.h"
#import "PrivacyViewController.h"



@interface MineViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTopConstraint;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewTopConstraint.constant = iPhoneX ? 88 : 64;
    [self createNavWithTitle:@"我的" leftText:nil rightText:nil];
    self.theSimpleNavigationBar.backgroundColor = [UIColor clearColor];
    [self.theSimpleNavigationBar.titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.theSimpleNavigationBar.backgroundColor =  RGB(0, 166, 78);    self.theSimpleNavigationBar.bottomLineView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = RGB(222, 222, 222);
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)tap1:(id)sender {
    AboutUsViewController *abVC = [[AboutUsViewController alloc] init];
    [self.navigationController pushViewController:abVC animated:YES];
}

- (IBAction)tap2:(id)sender {
    YMFeedBackController *VC = [[YMFeedBackController alloc] init];
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)tap3:(id)sender {
    PrivacyViewController *privacyVC = [[PrivacyViewController alloc] init];
    privacyVC.urlString = @"https://luck.youmeng.com/Protocol/ljzs.html";
    [self.navigationController pushViewController:privacyVC animated:YES];
}

- (IBAction)tap4:(id)sender {
//    PrivacyViewController *privacyVC = [[PrivacyViewController alloc] init];
//    privacyVC.urlString = @"https://luck.youmeng.com/Protocol/xy.html";
//    [self.navigationController pushViewController:privacyVC animated:YES];
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
