//
//  NetSpeedView.m
//  AdBlocks
//
//  Created by Sj03 on 2018/10/29.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import "NetSpeedView.h"
// 位置适配
#define ZMScacle (w/([UIScreen mainScreen].bounds.size.width-40))
#define ZM_SPACE(x) ((x) * ZMScacle)


@implementation NetSpeedView

- (id)init {
    self = [super init];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        
    }
    return self;
}
- (void)show {
    UIImageView *imageVC = [[UIImageView alloc] initWithImage:IMAGE_NAME(@"cesuzhi")];
    imageVC.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    [self addSubview:imageVC];
    
    // 指针
    CALayer *needleLayer = [CALayer layer];
    needleLayer.anchorPoint = CGPointMake(0.5, 1.0);
    CGFloat w = CGRectGetWidth(self.frame);
    needleLayer.position = imageVC.center;
    needleLayer.bounds = CGRectMake(0, 0, ZM_SPACE(5), ZM_SPACE(85));
    
    needleLayer.contents = (id)[UIImage imageNamed:@"cwszhizhen"].CGImage;
    [self.layer addSublayer:needleLayer];
    needleLayer.transform = CATransform3DMakeRotation(-0.75*M_PI, 0, 0, 1);
    self.needleLayer = needleLayer;
    
}

@end
