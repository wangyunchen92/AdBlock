//
//  WKSimilarPhotoCell.m
//  WuKongClearPhotoDemo
//
//  Created by ZhangJingHao2345 on 2018/3/8.
//  Copyright © 2018年 ZhangJingHao2345. All rights reserved.
//

#import "WKSimilarPhotoCell.h"

@interface WKSimilarPhotoCell ()

@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UIButton *selectBtn;
@property (nonatomic, strong) WKPhotoInfoItem *item;

@end

@implementation WKSimilarPhotoCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUIWithFrame:frame];
    }
    return self;
}

- (void)setupUIWithFrame:(CGRect)frame {
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:self.bounds];
    iconView.contentMode = UIViewContentModeScaleAspectFill;
    iconView.clipsToBounds = YES;
    [self addSubview:iconView];
    self.iconView = iconView;
    
    CGFloat selectWH = frame.size.width * 0.3;
    CGFloat selectX = frame.size.width - selectWH;
    UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(selectX, 0, selectWH, selectWH)];
    [self addSubview:selectBtn];
    self.selectBtn = selectBtn;
    [selectBtn setImage:[UIImage imageNamed:@"照片清理_未选中"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"照片清理_选中"] forState:UIControlStateSelected];
    [selectBtn addTarget:self action:@selector(clickSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)bindWithModel:(WKPhotoInfoItem *)model {
    self.item = model;
    // 获取缩率图
    PHImageManager *mgr = [PHImageManager defaultManager];
    PHImageRequestOptions* imageOpt = [[PHImageRequestOptions alloc] init];
    // resizeMode 属性控制图像的剪裁
    imageOpt.resizeMode = PHImageRequestOptionsResizeModeNone;
    // deliveryMode 则用于控制请求的图片质量
    imageOpt.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    [mgr requestImageForAsset:model.asset
                   targetSize:CGSizeMake(125, 125)
                  contentMode:PHImageContentModeDefault
                      options:imageOpt
                resultHandler:^(UIImage *result, NSDictionary *info) {
                        self.iconView.image = result;
                }];

    self.selectBtn.selected = model.isSelected;
}

- (void)clickSelectBtn:(UIButton *)btn {
    btn.selected = !btn.selected;
    self.item.isSelected = btn.selected;
    if (self.block_sele) {
        self.block_sele(self.item.isSelected);
    }
}

@end
