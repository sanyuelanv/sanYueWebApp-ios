//
//  SanYueErrorView.h
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SanYueErrorView : UIView
- (instancetype)initWithFrame:(CGRect)frame andText:(NSString *)reason addTarget:(nullable id)target reloadAction:(SEL)reloadAction closeAction:(SEL)closeAction needReload:(BOOL)needReload;
@end

NS_ASSUME_NONNULL_END
