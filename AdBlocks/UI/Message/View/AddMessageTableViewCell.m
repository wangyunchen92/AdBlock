//
//  AddMessageTableViewCell.m
//  AdBlocks
//
//  Created by Sj03 on 2018/11/8.
//  Copyright © 2018 Sj03. All rights reserved.
//

#import "AddMessageTableViewCell.h"

@implementation AddMessageTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)buttonClick:(id)sender {
    if (self.block_buttonClick) {
        self.block_buttonClick();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
