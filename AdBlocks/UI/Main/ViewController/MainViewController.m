//
//  MainViewController.m
//  AdBlock
//
//  Created by Sj03 on 2018/10/25.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import "MainViewController.h"
#import "MainCellModel.h"
#import "MainCellView.h"
#import "CallBlockViewController.h"
#import "NetWorkSpeedViewController.h"
#import "MessageGroupListViewController.h"



@interface MainViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutletCollection(MainCellView ) NSArray *cellViewArray;
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavWithTitle:@"拦截助手" leftText:nil rightText:nil];
    self.theSimpleNavigationBar.backgroundColor = RGB(0, 166, 78);
    self.theSimpleNavigationBar.bottomLineView.backgroundColor = [UIColor clearColor];
    [self.theSimpleNavigationBar.titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.theSimpleNavigationBar.titleButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    [array addObject:[self getModel:@"MainPhome" title:@"电话拦截" nextViewController:@"CallBlockViewController"]];
    [array addObject:[self getModel:@"MainBufferSel" title:@"相册清理" nextViewController:@"PictureClearListViewController"]];
    [array addObject:[self getModel:@"MainMessage" title:@"短信拦截" nextViewController:@"MessageGroupListViewController"]];
    [array addObject:[self getModel:@"MainwifiSel" title:@"检测网速" nextViewController:@"NetWorkSpeedViewController"]];
    [array addObject:[self getModel:@"MainweiChatSel" title:@"微信清理" nextViewController:@"WeiChatController"]];
    [array addObject:[self getModel:@"Mainchi" title:@"电池管理" nextViewController:@"BatterViewController"]];
    
    [self.cellViewArray enumerateObjectsUsingBlock:^(MainCellView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj getUIData:[array objectAtIndex:idx]];
        obj.block_viewClick = ^(MainCellModel * _Nonnull model) {
            [self pushToNextView:model];
        };
    }];
    
    NSString *str = [UserDefaultsTool getStringWithKey:@"setAppTime"];
    NSDate *date1 = [NSDate date];
    NSDateFormatter *dateformate = [[NSDateFormatter alloc] init];
    dateformate.dateFormat = @"yyyy-MM-dd";
    NSDate *date2 = [dateformate dateFromString:str];
    
    self.dataLabel.text = [NSString stringWithFormat:@"%ld",([ToolUtil getDaysFromDate:date2 toDate:date1] + 1)];
    
}
- (void)pushToNextView:(MainCellModel *)model {
    Class nextView = NSClassFromString(model.nextViewController);
    BaseViewController *view = [[nextView alloc] init];
    if (view) {
        [self.navigationController pushViewController:view animated:YES];
    }
}

- (MainCellModel *)getModel:(NSString *)image title:(NSString *)title nextViewController:(NSString *)controllerStr{
    MainCellModel *model = [[MainCellModel alloc] init];
    model.image = image;
    model.title = title;
    model.nextViewController = controllerStr;
    return model;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y <= 0) {
        scrollView.contentOffset = CGPointZero;
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
