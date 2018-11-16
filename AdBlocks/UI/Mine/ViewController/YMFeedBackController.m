//
//  YMFeedBackController.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/10.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMFeedBackController.h"
#import "BRPlaceholderTextView.h"



@interface YMFeedBackController ()<UITextViewDelegate>

//问题描述
@property (weak, nonatomic) IBOutlet BRPlaceholderTextView *descTextView;

//滚动视图
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

//记录字数
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTopConstraint;

//确认按钮
@property (strong, nonatomic) IBOutlet UIButton *sureBtn;
@end

@implementation YMFeedBackController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIUtil viewLayerWithView:_sureBtn cornerRadius:22 boredColor:[UIColor clearColor] borderWidth:1];
    
    _descTextView.placeholder = @"请描述您遇到的问题和建议（10-200字）";
    _descTextView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _descTextView.maxTextLength = 200;
    _descTextView.font = [UIFont systemFontOfSize:18];
    _descTextView.alwaysBounceVertical = NO;
    [_descTextView becomeFirstResponder];
    
//    _sureBtn.backgroundColor = DefaultNavBarColor;
    
    //将self转换成弱指针
    @weakify(self);
    [_descTextView.rac_textSignal  subscribeNext:^(NSString* x){
        NSLog(@"%@",x);//这里的X就是文本框的文字
        @strongify(self);//转换成强指针 避免在block中被释放
        self.countLabel.text = [NSString stringWithFormat:@"%lu/200",(unsigned long)x.length];
    }];
    
}

- (void)loadUIData {
    self.viewTopConstraint.constant = iPhoneX ? 88 : 64;
    [self createNavWithTitle:@"意见反馈" leftImage:@"Whiteback" rightImage:nil];
    self.theSimpleNavigationBar.backgroundColor = [UIColor clearColor];
    [self.theSimpleNavigationBar.titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.theSimpleNavigationBar.backgroundColor =  RGB(0, 166, 78);
    self.theSimpleNavigationBar.bottomLineView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = RGB(222, 222, 222);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)sureBtnClick:(id)sender {
    //推出键盘
    [self.view endEditing:YES];
  
    if (_descTextView.text.length == 0) {
        [BasePopoverView showFailHUDToWindow:@"请输入您遇到的问题或者建议！"];
        return;
    }
//    __weak typeof(self) weakSelf = self;
//    YMWeakSelf;
    HttpRequestMode *model = [[HttpRequestMode alloc]init];
    model.name= @"意见反馈";
    model.url = AddFeedBack;
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setObject:_descTextView.text forKey:@"content"];
//    [param setObject:[UserInfo shareInstance].uid forKey:@"uid"];
//    [param setObject:[UserInfo shareInstance].token forKey:@"token"];
    [BasePopoverView showHUDToWindow:YES withMessage:@"意见反馈中"];
    model.parameters = param;
    [[HttpClient sharedInstance]requestApiWithHttpRequestMode:model Success:^(HttpRequest *request, HttpResponse *response) {
         [BasePopoverView hideHUDForWindow:YES];
         [BasePopoverView  showSuccessHUDToWindow:@"感谢您的宝贵意见！"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
        
    } Failure:^(HttpRequest *request, HttpResponse *response) {
        [BasePopoverView hideHUDForWindow:YES];
        [BasePopoverView showFailHUDToWindow:response.errorMsg];
        
    } RequsetStart:^{
        
    } ResponseEnd:^{
        
    }];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //当前输入字数
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}


@end
