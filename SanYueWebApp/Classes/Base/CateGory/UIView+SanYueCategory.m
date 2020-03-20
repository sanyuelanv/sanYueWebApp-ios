//
//  UIView+SanYue.m
//  SanYueWebApp
//
//  Created by 宋航 on 2020/3/19.
//

#import "UIView+SanYueCategory.h"

#import <UIKit/UIKit.h>

@implementation UIView (SanYueCategory)
- (void)addRoundedCorners:(UIRectCorner)corners withRadius:(CGFloat)radius{
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius,radius)];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    self.layer.mask = shape;
}
@end
