//
//  CALayer+LayerColor.h
//  AdBlocks
//
//  Created by Sj03 on 2018/12/7.
//  Copyright © 2018 Sj03. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (LayerColor)

- (void)setBorderColorFromUIColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
