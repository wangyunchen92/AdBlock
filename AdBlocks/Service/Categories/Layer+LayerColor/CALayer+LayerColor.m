//
//  CALayer+LayerColor.m
//  AdBlocks
//
//  Created by Sj03 on 2018/12/7.
//  Copyright © 2018 Sj03. All rights reserved.
//

#import "CALayer+LayerColor.h"

@implementation CALayer (LayerColor)
- (void)setBorderColorFromUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
}

@end
