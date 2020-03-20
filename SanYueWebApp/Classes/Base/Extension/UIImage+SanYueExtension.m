//
//  UIImage+SanYueExtension.m
//  AFNetworking
//
//  Created by 宋航 on 2020/2/6.
//

#import "UIImage+SanYueExtension.h"

@implementation UIImage (SanYueExtension)
+(UIImage *)imageRenderingOrigin:(NSString *)imageName andBundle:(NSBundle *)resourceBundle{
    if (@available(iOS 8.0, *)) {
        UIImage *img = [UIImage imageNamed:imageName inBundle:resourceBundle compatibleWithTraitCollection:nil];
        return [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        return nil;
    }
}
@end
