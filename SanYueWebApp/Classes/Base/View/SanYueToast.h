//
//  XiaoZhuanLanToast.h
//  XiaoZhuanLan
//
//  Created by 宋航 on 2019/2/13.
//  Copyright © 2019 宋航. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SanYueToast : UIView
@property (nonatomic, assign) CGRect superViewFrame;
-(void)showToast:(CGFloat)time withText:(nullable NSString *)text withIcon:(nullable NSString *)icon withIsMask:(BOOL)isMask;
-(void)closeToast;
-(instancetype)initWithSuperViewFrame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
