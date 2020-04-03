//
//  MainViewController.m
//  testWebApp
//
//  Created by 宋航 on 2020/2/3.
//  Copyright © 2020 宋航. All rights reserved.
//

#import "MainViewController.h"
#import <SanYueAppViewController.h>
//#import <SanYueWebViewDelegate.h>
//#import <NSString+SanYueExtension.h>

@interface MainViewController ()
@property (nonatomic,weak)UILabel *label;
@property (nonatomic,assign)BOOL isDebug;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"点击" forState:UIControlStateNormal];
    [btn sizeToFit];
    btn.center = self.view.center;
    [btn addTarget:self action:@selector(btnEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    UILabel *cacheLabel = [[UILabel alloc] init];
    cacheLabel.text = [NSString stringWithFormat:@"缓存：%@",[SanYueAppViewController getCacheSize]];
    [cacheLabel sizeToFit];
    cacheLabel.center = CGPointMake(btn.center.x, 80);
    cacheLabel.textColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
        if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            return UIColor.blackColor;
        }
        else{
            return UIColor.blackColor;
        }
    }];
    _label = cacheLabel;
    [self.view addSubview:cacheLabel];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn1 setTitle:@"刷新" forState:UIControlStateNormal];
    [btn1 sizeToFit];
    btn1.center = CGPointMake(btn.center.x, 150);
    [btn1 addTarget:self action:@selector(reloadEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn2 setTitle:@"清空" forState:UIControlStateNormal];
    [btn2 sizeToFit];
    btn2.center = CGPointMake(btn.center.x, 190);
    [btn2 addTarget:self action:@selector(clearEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeSystem];
    _isDebug = YES;
    [btn3 setTitle:@"关闭 debug" forState:UIControlStateNormal];
    [btn3 sizeToFit];
    btn3.center = CGPointMake(btn.center.x, 230);
    [btn3 addTarget:self action:@selector(debugEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadEvent];
}
- (void)btnEvent{
    SanYueAppViewController *app = [[SanYueAppViewController alloc] initWithURL:@"http://172.16.0.44:3000/app.zip?dfafda" widthNeedDeBug:_isDebug withNetworkWatching:@"www.baidu.com"];
    app.timeoutInterval = 20.0f;
    [self presentViewController:app animated:YES completion:nil];
}
- (void)reloadEvent{
    _label.text = [NSString stringWithFormat:@"缓存：%@",[SanYueAppViewController getCacheSize]];
    [_label sizeToFit];
}
- (void)clearEvent{
    _label.text = [NSString stringWithFormat:@"缓存：%@",[SanYueAppViewController clearCacheSize]];
    [_label sizeToFit];
}
- (void)debugEvent:(UIButton *)btn{
    _isDebug = !_isDebug;
    NSString *title = _isDebug ? @"关闭 debug" : @"开启 debug";
    [btn setTitle:title forState:UIControlStateNormal];
    
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}

@end
