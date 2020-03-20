//
//  SanYuePickerViewController.h
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/14.
//

#import <UIKit/UIKit.h>
#import "SanYueBaseAlertController.h"
@class SanYuePickItem;
NS_ASSUME_NONNULL_BEGIN

@interface SanYuePickerViewController : SanYueBaseAlertController
-(instancetype)initWithItem:(SanYuePickItem *)item andHandler:(void (^ __nullable)(int index,int type))handler;
-(instancetype)initWithItem:(SanYuePickItem *)item andMultiHandler:(void (^ __nullable)(NSArray<NSNumber *> *value,int type))multiHandler;
-(instancetype)initWithItem:(SanYuePickItem *)item andTimeHandler:(void (^ __nullable)(NSString *res,int type))handler;
@end

NS_ASSUME_NONNULL_END
