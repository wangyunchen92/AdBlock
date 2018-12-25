//
//  PhoneIdentifyViewController.m
//  AdBlocks
//
//  Created by Sj03 on 2018/12/7.
//  Copyright © 2018 Sj03. All rights reserved.
//

#import "PhoneIdentifyViewController.h"
#import "PhoneIndenDetailViewController.h"
#import "PhoneIdentifyViewModel.h"
//#import "IzdSdk/IzdRec.h"

@interface PhoneIdentifyViewController ()
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTopConstraint;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (nonatomic, strong)PhoneIdentifyViewModel *viewModel;

@end

@implementation PhoneIdentifyViewController
- (void)loadUIData {
    [self createNavWithTitle:@"电话查询" leftImage:nil rightImage:nil];
    self.theSimpleNavigationBar.backgroundColor = RGB(0, 166, 78);
    [self.theSimpleNavigationBar.titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.theSimpleNavigationBar.bottomLineView.backgroundColor = [UIColor clearColor];
    
    self.searchView.layer.borderWidth = 1;
    self.searchView.layer.borderColor = RGB(212, 212, 212).CGColor;
    self.searchView.layer.cornerRadius = 7;
    self.searchView.layer.masksToBounds = YES;
    self.viewTopConstraint.constant = iPhoneX ? 88 : 64;
    self.viewModel = [[PhoneIdentifyViewModel alloc] init];

    self.viewModel.block_getData = ^(PhoneTypeModel * model){
        PhoneIndenDetailViewController *pDetailVC = [[PhoneIndenDetailViewController alloc] init];
        pDetailVC.model = model;
        [self.navigationController pushViewController:pDetailVC animated:YES];
    };
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.inputTextField.rac_textSignal subscribeNext:^(NSString * x) {

        if (x.length == 0) {
//            [self.sureButton setBackgroundColor:[UIColor grayColor]];
            [self.sureButton setEnabled:NO];
        } else {
            [self.sureButton setBackgroundColor:RGB(75, 165, 85)];
            [self.sureButton setEnabled:YES];
        }
    }];
    
    
}
- (IBAction)searchButtonClick:(id)sender {
    
//    IzdRec *izdRec = [IzdRec shareInstance];
//    [izdRec DiscernTels:self.inputTextField.text success:^(id  _Nonnull json) {
//        NSMutableArray *result = (NSMutableArray *)json;
//        NSLog(@"%ld", [result count]);
//    }];
    
    [self.viewModel.subject_getData sendNext:self.inputTextField.text];
//    [self.navigationController pushViewController:[[PhoneIndenDetailViewController alloc] init] animated:YES];
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
