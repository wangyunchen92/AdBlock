//
//  MainCellModel.h
//  AdBlocks
//
//  Created by Sj03 on 2018/10/25.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainCellModel : NSObject
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *image;
@property (nonatomic, copy)NSString *nextViewController;

@end

NS_ASSUME_NONNULL_END
