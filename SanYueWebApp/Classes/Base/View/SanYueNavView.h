//
//  SanYueNavView.h
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SanYueNavView : UIView
-(void)addBackBtnTarget:(nullable id)target action:(SEL)action;
-(void)changeNavByColor:(NSString *)color andTitle:(NSString *)title andTextColor:(NSString *)textColor;
@end

NS_ASSUME_NONNULL_END
