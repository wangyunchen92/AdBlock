//
//  PhoneIndenDetailViewController.m
//  AdBlocks
//
//  Created by Sj03 on 2018/12/7.
//  Copyright © 2018 Sj03. All rights reserved.
//

#import "PhoneIndenDetailViewController.h"
#import "NewTableViewController.h"

@interface PhoneIndenDetailViewController ()
@property (nonatomic, strong)NewTableViewController *NewVC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTopConstraint;

@end

@implementation PhoneIndenDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewTopConstraint.constant = iPhoneX ? 88 : 64;
    [self createNavWithTitle:@"查询结果" leftImage:@"Whiteback" rightImage:nil];
    self.theSimpleNavigationBar.backgroundColor = RGB(0, 166, 78);
    [self.theSimpleNavigationBar.titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.theSimpleNavigationBar.bottomLineView.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view from its nib.
}

- (void)loadUIData {
    NewTableViewController *VC = [[NewTableViewController alloc] initWithType:@"all"];
    [self addChildViewController:VC];
    [self.view addSubview:VC.view];
    [VC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(448);
        make.height.equalTo(self.view.mas_height).offset(0);
    }];
    self.NewVC = VC;
    
    VC.block_scroller = ^(CGFloat floa) {
        if (floa > 0 && floa<448) {
            [UIView animateWithDuration:1 animations:^{
                self.viewTopConstraint.constant = iPhoneX ? 88 : 64 - floa;
                [self.NewVC.view mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(448-floa);
                }];
            }];
        }
    };
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
