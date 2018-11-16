//
//  PrivacyViewController.m
//  PhotoClear
//
//  Created by Sj03 on 2018/9/28.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import "PrivacyViewController.h"

@interface PrivacyViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTopConstraint;

@end

@implementation PrivacyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.viewTopConstraint.constant = iPhoneX ? 88: 64;
    [self createNavWithTitle:@"隐私政策" leftImage:@"Whiteback"  rightText:nil];
    
    self.theSimpleNavigationBar.backgroundColor =  RGB(0, 166, 78);
    [self.theSimpleNavigationBar.titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.theSimpleNavigationBar.bottomLineView.backgroundColor = [UIColor clearColor];
    self.webView.backgroundColor = [UIColor clearColor];
    
    self.webView.delegate = self;
    self.webView.userInteractionEnabled = YES;
    self.webView.scalesPageToFit = YES;
    //请求ulr
    [RACObserve(self, urlString) subscribeNext:^(id x) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: [NSURL URLWithString:self.urlString]];
        request.timeoutInterval = 10;
        dispatch_main_async(^(){
            [self.webView loadRequest:request];
        })
    }];
}

// navBar 回调
- (void)navBarButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
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
