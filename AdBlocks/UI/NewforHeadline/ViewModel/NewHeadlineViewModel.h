//
//  NewHeadlineViewModel.h
//  Constellation
//
//  Created by Sj03 on 2018/3/23.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewTableViewController.h"

@interface NewHeadlineViewModel : BaseViewModel
@property (nonatomic, strong)NSString *pagString;
@property (nonatomic, strong)NSString *typeString;
@property (nonatomic, assign)BOOL isadd;
@property (nonatomic, strong)NewTableViewController *adVC;

@property (nonatomic, strong) NSArray *expressAdViews;
@property (nonatomic, assign)NSInteger aDnum;
@property (nonatomic, assign)BOOL isAdLoadSuccess;




@end
