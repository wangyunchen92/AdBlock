//
//  BaseScroller.m
//  Constellation
//
//  Created by Sj03 on 2018/3/30.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import "BaseScroller.h"

@implementation BaseScroller

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
@end
