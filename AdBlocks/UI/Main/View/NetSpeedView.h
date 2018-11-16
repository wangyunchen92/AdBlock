//
//  NetSpeedView.h
//  AdBlocks
//
//  Created by Sj03 on 2018/10/29.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetSpeedView : UIView
@property (nonatomic, strong)CALayer *needleLayer;

- (void)show;

@end

NS_ASSUME_NONNULL_END
