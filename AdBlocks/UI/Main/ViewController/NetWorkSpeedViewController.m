//
//  NetWorkSpeedViewController.m
//  AdBlocks
//
//  Created by Sj03 on 2018/10/29.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import "NetWorkSpeedViewController.h"
#import "NetSpeedView.h"
#import "MeasurNetTools.h"
#import "QBTools.h"

@interface NetWorkSpeedViewController ()
@property (nonatomic, strong)NetSpeedView *rectView;
@property (strong, nonatomic) UILabel *numberLb;

@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, assign) CGFloat lastTrans;

@end

@implementation NetWorkSpeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createNavWithTitle:@"网速测试" leftImage:@"Whiteback" rightText:nil];
    self.theSimpleNavigationBar.backgroundColor = RGB(0, 166, 78);
    self.theSimpleNavigationBar.bottomLineView.backgroundColor = [UIColor clearColor];
    [self.theSimpleNavigationBar.titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.theSimpleNavigationBar.titleButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    self.view.backgroundColor = RGB(233, 233, 233);
}

-(void)initData {

    __weak typeof(self) weakself = self;
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    __weak typeof(AFNetworkReachabilityManager *) weakreachabilityManager = reachabilityManager;
    [reachabilityManager startMonitoring];
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == AFNetworkReachabilityStatusNotReachable){
            
            //            [MBProgressHUD addTipWith:self.view WithTipContent:@"暂无网络"];
            
        }else if (status == AFNetworkReachabilityStatusReachableViaWWAN){
            
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"当前是移动网络，测速可能会消耗较多流量，是否继续测速" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"继续" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"返回" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
                [weakself.navigationController popViewControllerAnimated:YES];
            }];
            [alertC addAction:alertAction1];
            [alertC addAction:alertAction];
            [self presentViewController:alertC animated:YES completion:nil];
        }
        
        [weakreachabilityManager stopMonitoring];
    }];
    
    
    
    CGFloat width = kScreenWidth-40;
    CGFloat height = kScreenWidth-40;
    CGFloat x = 20;
    CGFloat y = 80;
    _rectView = [[NetSpeedView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [_rectView show];
    [self.view addSubview:_rectView];
    
    self.numberLb = [[UILabel alloc] initWithFrame:CGRectMake(80, CGRectGetMaxY(self.rectView.frame)-90, kScreenWidth-160, 45)];
    self.numberLb.textAlignment = NSTextAlignmentCenter;
    self.numberLb.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
    self.numberLb.backgroundColor = [UIColor clearColor];
    self.numberLb.textColor = [UIColor whiteColor];
    [self.view addSubview:self.numberLb];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(80, CGRectGetMaxY(self.rectView.frame), kScreenWidth - 160, 45);
    [button setBackgroundImage:[UIImage imageNamed:@"cwsanniubg"] forState:UIControlStateNormal];
    [button setTitle:@"测网速" forState:(UIControlStateNormal)];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
    
    UILabel *message = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_numberLb.frame)+10, kScreenWidth, 18)];
    message.textAlignment = NSTextAlignmentCenter;
    message.backgroundColor = [UIColor clearColor];
    message.textColor = [UIColor whiteColor];
    message.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    [self.view addSubview:message];
    self.messageLabel = message;
}

- (void)buttonClick:(UIButton *)button
{
    button.userInteractionEnabled = NO;
    _messageLabel.text = @"正在检测网络,请稍后";
    
    if (_lastTrans != -0.75*M_PI) {
        
        if (_lastTrans > 0) {
            [self setRectViewTrans:0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self setRectViewTrans:-0.75*M_PI];
                [self startNetSpeedWith:button];
            });
        }else{
            [self setRectViewTrans:-0.75*M_PI];
            [self startNetSpeedWith:button];
        }
    }else{
        [self startNetSpeedWith:button];
    }
    
}

- (void)setRectViewTrans:(CGFloat)trans
{
    self.rectView.needleLayer.transform = CATransform3DMakeRotation(trans, 0, 0, 1);
}

- (void)startNetSpeedWith:(UIButton *)button
{
    //    [self setIp];
    MeasurNetTools * meaurNet = [[MeasurNetTools alloc] initWithblock:^(float speed) {
        
        [self setProgressWith:speed andIsLast:NO];
        
    } finishMeasureBlock:^(float speed) {
        
        [self setProgressWith:speed andIsLast:YES];
        self.messageLabel.text = [NSString stringWithFormat:@"当前速度相当于%@带宽",[QBTools formatBandWidth:speed/timeCount]];
        button.userInteractionEnabled = YES;
    } failedBlock:^(NSError *error) {
        button.userInteractionEnabled = YES;
    }];
    [meaurNet startMeasur];
}


- (void)setProgressWith:(CGFloat)speed andIsLast:(BOOL)isLast
{
    speed = speed/timeCount;
    NSString* speedStr = [NSString stringWithFormat:@"%@/S", [QBTools formattedFileSize:speed]];
    _numberLb.text = speedStr;
    
    CGFloat llM = 0;;
    CGFloat llMFloat = speedStr.floatValue;
    if ([speedStr containsString:@"KB"]) {
        llM = llMFloat/1024;
    }else if ([speedStr containsString:@"M"]){
        llM = llMFloat;
    }else if ([speedStr containsString:@"bytes"]){
        llM = llMFloat/1024/1024;
    }else if([speedStr containsString:@"GB"]){
        llM = llMFloat*1024;
    }
    
    CGFloat angle = llM/(float)12 * 1.5*M_PI;
    CGFloat needAngle = angle - 0.75*M_PI;
    
    if (needAngle > 0.75*M_PI) {
        needAngle = 0.75*M_PI;
    }
    
    if (needAngle < -0.75*M_PI) {
        needAngle = -0.75*M_PI;
    }
    
    [self setRectViewTrans:needAngle];
    if (isLast) {
        _lastTrans = needAngle;
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
