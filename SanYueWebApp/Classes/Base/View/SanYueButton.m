//
//  SanYueButton.m
//  SanYueWebApp
//
//  Created by 宋航 on 2020/3/19.
//

#import "SanYueButton.h"
@interface SanYueButton()
@property (nonatomic,strong)UIColor *highLightColor;
@end
@implementation SanYueButton
- (UIColor *)highLightColor{
    if (!_highLightColor) {
        UIColor *btnBg = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:25/255.0];
        if (@available(iOS 13.0, *)) {
            btnBg = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
                if (traitCollection.userInterfaceStyle != UIUserInterfaceStyleDark) { return [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:25/255.0]; }
                else{ return [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:50/255.0]; }
            }];
        }
        _highLightColor = btnBg;
    }
    return _highLightColor;
}
- (void)setHighlighted:(BOOL)highlighted{
    if (highlighted) {
        self.backgroundColor = self.highLightColor;
    }
    else{
        self.backgroundColor = self.normalBgColor ? self.normalBgColor : UIColor.clearColor;
    }
}
@end
