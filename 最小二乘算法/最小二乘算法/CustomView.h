//
//  CustomView.h
//  NSView
//
//  Created by 国帅 on 2019/11/29.
//  Copyright © 2019 asi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomView : NSView

@property (nonatomic ,strong) NSMutableArray *pionts;

@property (nonatomic ,strong) NSMutableArray *linePionts;

@property (nonatomic ,strong) void (^piontsBlock)(void);

@end

NS_ASSUME_NONNULL_END
