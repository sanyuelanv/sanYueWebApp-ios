//
//  SanYueCapsuleBtnView.m
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/22.
//

#import "SanYueCapsuleBtnView.h"
#import "UIImage+SanYueExtension.h"
#import "UIColor+SanYueExtension.h"
@interface SanYueCapsuleBtnView()
@property(nonatomic,weak) UIButton *closeBtn;
@property(nonatomic,weak) UIButton *aboutBtn;
@end
@implementation SanYueCapsuleBtnView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setUpClostBtn];
    }
    return self;
}
-(void)setUpClostBtn{
    //SanYueShareAppInfoItem *appInfo = [SanYueShareAppInfoItem shareInstance];
    NSBundle *bundle = [NSBundle bundleForClass:self.classForCoder];
    NSURL *bundleURL = [[bundle resourceURL] URLByAppendingPathComponent:@"SanYueWebApp.bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithURL:bundleURL];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;;
    CGFloat statusH = [UIScreen mainScreen].bounds.size.height >= 812 ? 44.0 : 20.0;
    self.frame = CGRectMake(width - 65 - 12, 8 + statusH, 64.5, 28);
    
    self.layer.cornerRadius = 15;
    self.layer.masksToBounds = YES;
    UIColor *lineColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:0.6];
    self.layer.borderColor = lineColor.CGColor;
    self.layer.borderWidth = 0.5;
    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5];
    // 关闭 按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _closeBtn = closeBtn;
    closeBtn.frame = CGRectMake(32.5, 0, 32, 28);
    closeBtn.backgroundColor = UIColor.clearColor;
    [closeBtn setImage:[UIImage imageRenderingOrigin:@"circular" andBundle:resourceBundle] forState:UIControlStateNormal];
    [self addSubview:closeBtn];
    // about 按钮
    UIButton *aboutBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    aboutBtn.frame = CGRectMake(0, 0, 32, 28);
    _aboutBtn = aboutBtn;
    aboutBtn.backgroundColor = UIColor.clearColor;
    [aboutBtn setImage:[UIImage imageRenderingOrigin:@"more" andBundle:resourceBundle] forState:UIControlStateNormal];
    [self addSubview:aboutBtn];
    // line
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(32, 6, 0.5, 16)];
    line.backgroundColor = lineColor;
    [self addSubview:line];
}
-(void)addCloseBtnTarget:(nullable id)target action:(SEL)action{
    if(_closeBtn){
        [_closeBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)addAboutBtnTarget:(nullable id)target action:(SEL)action{
    if (_aboutBtn) {
        [_aboutBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
}
@end
