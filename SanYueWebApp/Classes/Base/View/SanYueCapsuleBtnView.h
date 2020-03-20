//
//  SanYueCapsuleBtnView.h
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SanYueCapsuleBtnView : UIView
-(void)addCloseBtnTarget:(nullable id)target action:(SEL)action;
-(void)addAboutBtnTarget:(nullable id)target action:(SEL)action;
@end

NS_ASSUME_NONNULL_END
