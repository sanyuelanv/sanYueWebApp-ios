//
//  SanYueActionSheetController.m
//  SanYueWebApp
//
//  Created by 宋航 on 2020/3/19.
//

#import "SanYueActionSheetController.h"
#import "SanYueActionSheetItem.h"
#import "UIView+SanYueCategory.h"
#import "UIColor+SanYueExtension.h"
#import "SanYueLabelButton.h"
typedef void(^SelectBlock)(int index);
@interface SanYueActionSheetController ()
@property (nonatomic,strong)SanYueActionSheetItem *item;
@property (nonatomic,strong)UIColor *btnBgColor;

@property (nonatomic,weak)UIView *bgView;
@property (nonatomic,weak)UIView *mainView;

@property (nonatomic,assign)BOOL isShow;
@property (nonatomic,assign)CGFloat y;
@property (nonatomic,copy) SelectBlock selectBlock;
@end

@implementation SanYueActionSheetController
- (UIColor *)btnBgColor{
    if (!_btnBgColor) {
        UIColor *bgColor = UIColor.whiteColor;
        if (@available(iOS 13.0, *)) {
            bgColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
                if (traitCollection.userInterfaceStyle != UIUserInterfaceStyleDark) {
                    return UIColor.whiteColor;
                }
                else{
                    return [UIColor colorWithRed:35/250.0 green:35/250.0 blue:35/250.0 alpha:1.0];
                }
            }];
        }
        _btnBgColor = bgColor;
    }
    return _btnBgColor;
}
- (instancetype)initWithItem:(SanYueActionSheetItem *)item andHandler:(void (^ __nullable)(int index))handler{
    self = [super init];
    if (self) {
        self.item = item;
        self.selectBlock = handler;
        self.senseMode = item.senseMode;
        [self setUpMainView];
    }
    return self;
}
-(void)setUpMainView{
    CGFloat WIDTH = [UIScreen mainScreen].bounds.size.width;
    CGFloat HEIGHT = [UIScreen mainScreen].bounds.size.height;
    CGFloat h = 56;
    UIColor *mainColor = [UIColor colorWithRed:245/250.0 green:245/250.0 blue:245/250.0 alpha:1.0];
    UIColor *titleColor = [UIColor colorWithRed:0/250.0 green:0/250.0 blue:0/250.0 alpha:125/255.0];
    if (@available(iOS 13.0, *)) {
        mainColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle != UIUserInterfaceStyleDark) {
                return [UIColor colorWithRed:245/250.0 green:245/250.0 blue:245/250.0 alpha:1.0];
            }
            else{
                return [UIColor colorWithRed:24/250.0 green:24/250.0 blue:24/250.0 alpha:1.0];
            }
        }];
        titleColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle != UIUserInterfaceStyleDark) {
                return [UIColor colorWithRed:0/250.0 green:0/250.0 blue:0/250.0 alpha:125/255.0];
            }
            else{
                return [UIColor colorWithRed:255/250.0 green:255/250.0 blue:255/250.0 alpha:125/255.0];
            }
        }];
    }
    // bg
    UIButton *bgView = [UIButton buttonWithType:UIButtonTypeCustom];
    bgView.tag = -2;
    bgView.frame = self.view.bounds;
    bgView.backgroundColor = UIColor.clearColor;
    [bgView addTarget:self action:@selector(backEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bgView];
    bgView.userInteractionEnabled = _item.backGroundCancel;
    _bgView = bgView;
    // 主体
    UIView *mainView = [[UIView alloc] init];
    _mainView = mainView;
    mainView.backgroundColor = mainColor;
    mainView.layer.masksToBounds = YES;
    [self.view addSubview:mainView];
    
    // 顶部标题
    CGFloat height = 0;
    if (_item.title != nil && ![_item.title isEqualToString:@""]) {
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, h)];
        titleView.backgroundColor = self.btnBgColor;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 0, WIDTH - 48, h)];
        titleLabel.numberOfLines = 2;
        titleLabel.textColor = titleColor;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
        titleLabel.text = _item.title;
        [titleView addSubview:titleLabel];
        [mainView addSubview:titleView];
        // 创建 line
        height += h;
        [titleView addSubview:[self createLine:CGRectMake(0, h - 1, WIDTH, 1)]];
    }
    // 列表 - 最多六个（已经在数据上进行截取）
    int index = 0;
    for (NSString *text in _item.itemList) {
        SanYueLabelButton *btn = [SanYueLabelButton buttonWithType:UIButtonTypeCustom];
        [btn setUpBtn:text andTextColor:_item.itemColor andTextColorDark:_item.itemColorDark andTag:index andFrame:CGRectMake(0, height, WIDTH, h)];
        btn.backgroundColor = self.btnBgColor;
        btn.normalBgColor = self.btnBgColor;
        [mainView addSubview:btn];
        if (index < _item.itemList.count - 1) {
            [btn addSubview:[self createLine:CGRectMake(0, h - 1, WIDTH, 1)]];
        }
        [btn addTarget:self action:@selector(backEvent:) forControlEvents:UIControlEventTouchUpInside];
        height += h;
        index += 1;
    }
    height = height + 8;
    // 底部取消按钮
    CGFloat lastH = HEIGHT >= 812 ? h + 34 : h;
    SanYueLabelButton *btn = [SanYueLabelButton buttonWithType:UIButtonTypeCustom];
    [btn setUpBtn:_item.cancelText andTextColor:_item.cancelColor andTextColorDark:_item.cancelColorDark andTag:-1 andFrame:CGRectMake(0, height, WIDTH, lastH)];
    btn.backgroundColor = self.btnBgColor;
    btn.normalBgColor = self.btnBgColor;
    [btn addTarget:self action:@selector(backEvent:) forControlEvents:UIControlEventTouchUpInside];
    btn.myTextLabel.frame = CGRectMake(24, 0, WIDTH - 48,h);
    [mainView addSubview:btn];
    height += lastH;
    
    _y = HEIGHT - height;
    mainView.frame = CGRectMake(0, HEIGHT, WIDTH, height);
    [mainView addRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight withRadius:12];
    
}
-(UIView *)createLine:(CGRect)frame{
    UIColor *lineColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0];
    if (@available(iOS 13.0, *)) {
        lineColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle != UIUserInterfaceStyleDark) { return [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0]; }
            else{ return [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:1.0]; }
        }];
    }
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = lineColor;
    return view;
}
# pragma mark - 展示 & 隐藏 事件
- (void)show:(NSTimeInterval)duration andCompletion:(void (^)(BOOL))completion{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        CGRect frame =  weakSelf.mainView.frame;
        frame.origin.y = weakSelf.y;
        weakSelf.mainView.frame = frame;
        weakSelf.bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    } completion:^(BOOL finished) {
        completion(finished);
        weakSelf.isShow = YES;
    }];
}
- (void)dismiss:(NSTimeInterval)duration andCompletion:(void (^)(BOOL))completion{
    __weak typeof(self) weakSelf = self;
    CGFloat HEIGHT = [UIScreen mainScreen].bounds.size.height;
    [UIView animateWithDuration:duration animations:^{
        CGRect frame =  weakSelf.mainView.frame;
        frame.origin.y = HEIGHT;
        weakSelf.mainView.frame = frame;
        weakSelf.bgView.backgroundColor = UIColor.clearColor;
    } completion:^(BOOL finished) {
        completion(finished);
        weakSelf.isShow = YES;
    }];
}
#pragma mark - 事件
- (void)backEvent:(UIView *)view{
    int index = (int)view.tag;
    self.selectBlock(index);
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
