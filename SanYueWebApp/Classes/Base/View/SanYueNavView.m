//
//  SanYueNavView.m
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/6.
//

#import "SanYueNavView.h"
#import "UIImage+SanYueExtension.h"
#import "UIColor+SanYueExtension.h"
@interface SanYueNavView()
@property(nonatomic,weak) UIView *navView;
@property(nonatomic,weak) UILabel *titleLabel;
@property(nonatomic,weak) UIButton *backBtn;
@property(nonatomic,weak) UIButton *closeBtn;
@property(nonatomic,weak) UIButton *aboutBtn;
@property(nonatomic,strong) NSBundle *resourceBundle;
@end
@implementation SanYueNavView

- (NSBundle *)resourceBundle{
    if(!_resourceBundle){
        NSBundle *bundle = [NSBundle bundleForClass:self.classForCoder];
        NSURL *bundleURL = [[bundle resourceURL] URLByAppendingPathComponent:@"SanYueWebApp.bundle"];
        NSBundle *resourceBundle = [NSBundle bundleWithURL:bundleURL];
        _resourceBundle = resourceBundle;
    }
    return _resourceBundle;
}
-(instancetype)init{
    self = [super init];
    if (self) {
        [self setUpNavWithTitle];
    }
    return self;
}
-(void)setUpNavWithTitle{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;;
    CGFloat statusH = [UIScreen mainScreen].bounds.size.height >= 812 ? 44.0 : 20.0;
    self.frame = CGRectMake(0, 0, width, statusH + 44);
    // 顶部 nav
    UIView *navView = [[UIView alloc] initWithFrame:self.bounds];
    _navView = navView;
    navView.layer.masksToBounds = YES;
    [self addSubview:navView];
    // 返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _backBtn = backBtn;
    backBtn.frame = CGRectMake(0, statusH, 44, 44);
    [navView addSubview:backBtn];
    [backBtn setHidden:YES];
    
    // 中间 title
    CGFloat titleLabelX = CGRectGetMaxX(backBtn.frame) + 10;
    CGFloat titleLabelWidth = width - (65+12+10) - titleLabelX;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX, 13 + statusH, titleLabelWidth, 18)];
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel = titleLabel;
    [navView addSubview:titleLabel];
}
-(void)addBackBtnTarget:(nullable id)target action:(SEL)action{
    if (_backBtn) {
        [_backBtn setHidden:NO];
        [_backBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)changeNavByColor:(NSString *)color andTitle:(NSString *)title andTextColor:(NSString *)textColor{
    if (![_backBtn isHidden]) {
        UIImage *image;
        if ([UIColor isColorDeep:color]) {
            image = [UIImage imageRenderingOrigin:@"back_w" andBundle:self.resourceBundle];
        }
        else{
            image = [UIImage imageRenderingOrigin:@"back" andBundle:self.resourceBundle];
        }
        [_backBtn setImage:image forState:UIControlStateNormal];
    }
    _navView.backgroundColor = [UIColor colorWithHexString:color];
    _titleLabel.text = title;
    _titleLabel.textColor = [UIColor colorWithHexString:textColor];
}
@end
