//
//  AddMessageTableViewCell.h
//  AdBlocks
//
//  Created by Sj03 on 2018/11/8.
//  Copyright © 2018 Sj03. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString *AddMessageCellReuseIdentifier = @"AddMessageCellReuseIdentifier";


@interface AddMessageTableViewCell : UITableViewCell
@property (nonatomic, strong) void(^block_buttonClick)(void);


@end

NS_ASSUME_NONNULL_END
