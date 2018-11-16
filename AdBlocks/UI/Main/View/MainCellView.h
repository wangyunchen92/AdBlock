//
//  MainCellView.h
//  AdBlocks
//
//  Created by Sj03 on 2018/10/25.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainCellView : UIView
- (void)getUIData:(MainCellModel *)model;
@property (nonatomic, copy)void (^block_viewClick)(MainCellModel *model);

@end

NS_ASSUME_NONNULL_END
