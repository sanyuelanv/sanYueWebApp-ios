//
//  SanYueActionSheetController.h
//  SanYueWebApp
//
//  Created by 宋航 on 2020/3/19.
//

#import "SanYueBaseAlertController.h"
@class SanYueActionSheetItem;
NS_ASSUME_NONNULL_BEGIN

@interface SanYueActionSheetController : SanYueBaseAlertController
- (instancetype)initWithItem:(SanYueActionSheetItem *)item andHandler:(void (^ __nullable)(int index))handler;
@end

NS_ASSUME_NONNULL_END
