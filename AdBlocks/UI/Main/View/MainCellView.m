//
//  MainCellView.m
//  AdBlocks
//
//  Created by Sj03 on 2018/10/25.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import "MainCellView.h"


@interface MainCellView ()
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong)MainCellModel *model;

@end

@implementation MainCellView

-  (void)awakeFromNib {
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [self addSubview:self.view];
    self.view.frame = self.bounds;
    
}
- (void)getUIData:(MainCellModel *)model {
    self.imageView.image = IMAGE_NAME(model.image);
    self.titleLabel.text = model.title;
    self.model = model;
    
}
- (IBAction)viewClick:(id)sender {
    if (self.block_viewClick) {
        self.block_viewClick(self.model);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
