//
//  SanYueMainViewController.m
//  AFNetworking
//
//  Created by 宋航 on 2020/2/4.
//

#import "SanYueMainViewController.h"
#import "SanYueLoadView.h"
#import "SanYueErrorView.h"
#import "SanYueNavView.h"
#import "NSString+SanYueExtension.h"
#import "SanYueManager.h"
#import "SanYueAppInfoItem.h"
#import "SanYueWebAppItem.h"
#import "SanYueCapsuleBtnView.h"
#import "SanYueWebAppItem.h"
#import "SanYueAppViewController.h"
#import "SanYueScriptMessageManager.h"
#import "SanYueMyWebView.h"
#import "SanYueJavaScripMethod.h"
#import "SanYueAppConfigItem.h"
#import "UIColor+SanYueExtension.h"
#import "Reachability.h"
#import "SanYueRouterItem.h"
#import "SanYueToast.h"
#import "SanYueActionSheetItem.h"
#import "SanYueActionSheetController.h"
@interface SanYueMainViewController ()<SanYueScriptMessageDelegate,WKNavigationDelegate,SanYueWebViewControllerRouterDelegate>
@property (nonatomic,weak)UIView *loadAppView;
@property (nonatomic,weak)UIView *errorView;
@property(nonatomic, weak)UIView *appView;
@property(nonatomic, weak)SanYueMyWebView *webView;
@property (nonatomic,weak)SanYueToast *toastView;
@property(nonatomic, weak)SanYueNavView *navView;


@property (nonatomic,strong)SanYueActionSheetItem *aboutMsg;
@property (nonatomic, strong) NSURL *htmlURL;
@property(nonatomic, weak)SanYueWebAppItem *webAppItem;
@property(nonatomic, strong)NSString *pathName;
@property (nonatomic, strong) NSDictionary *extraMsg;
@property(nonatomic, assign)UIStatusBarStyle statusBarStyle;
@property(nonatomic, assign)BOOL mustLoad;

@property (nonatomic,weak)id<SanYueWebViewControllerRouterDelegate> routerDelegate;
@property (nonatomic,weak)SanYueScriptMessageManager *jsManager;
@property (nonatomic,strong)SanYueManager *manager;

@end
@implementation SanYueMainViewController
#pragma mark -- 懒加载
-(SanYueManager *)manager{
    if(!_manager){
        _manager = [[SanYueManager alloc] initWith:_webAppItem.url];
        SanYueAppViewController *vc = (SanYueAppViewController *)self.navigationController;
        _manager.timeoutInterval = vc.timeoutInterval;
        _manager.mustLoad = _mustLoad;
    }
    return _manager;
}
-(SanYueWebAppItem *)webAppItem{
    if (!_webAppItem) {
        _webAppItem = [SanYueWebAppItem shareInstance];
    }
    return _webAppItem;
}
-(SanYueToast *)toastView{
    if(!_toastView){
        SanYueToast *toastView = [[SanYueToast alloc] initWithSuperViewFrame:_appView.bounds];
        _toastView = toastView;
        [_appView addSubview:toastView];
    }
    return _toastView;
}
#pragma mark -- 外部初始化
-(instancetype)initWithURL:(NSString *)url andNeedRef:(BOOL)needRef{
    self = [super init];
    self.webAppItem.url = url;
    self.webAppItem.type = 0;
    _pathName = @"index";
    _mustLoad = needRef;
    return self;
}
#pragma mark -- 内部初始化
-(instancetype)initWithName:(NSString *)name andItem:(SanYueWebAppItem *)webItem andExtra:(NSDictionary *)extra andRouterDelegate:(id<SanYueWebViewControllerRouterDelegate>) routerDelegate{
    self = [super init];
    if (self) {
        _pathName = name;
        webItem.type = 1;
        _webAppItem = webItem;
        _extraMsg = extra;
        _routerDelegate = routerDelegate;
    }
    return self;
}
#pragma mark -- 系统
-(void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    // 创建 APP view
    UIView *appView = [[UIView alloc] initWithFrame:self.view.bounds];
    _appView = appView;
    [self.view addSubview:appView];
    // 创建 capsuleBtn
    SanYueCapsuleBtnView *capsuleBtnView = [[SanYueCapsuleBtnView alloc] init];
    [capsuleBtnView addCloseBtnTarget:self action:@selector(closeEvent)];
    [capsuleBtnView addAboutBtnTarget:self action:@selector(aboutEvent)];
    [self.view addSubview:capsuleBtnView];
    if (_webAppItem.type == 0) {
        if([_webAppItem.url isValidUrl]){
            [self setUpLoadView];
            [self loadEvent];
        }
        else{ [self setUpErrorView:@"非法 URL ，无法加载。"]; }
    }
    else{
        //NSLog(@"开始加载");
        [self setUpLoadView];
        [self setUpAppView];
    }
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_jsManager) {
        [_jsManager viewActive:_extraMsg];
        _extraMsg = nil;
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (_jsManager) { [_jsManager viewHide]; }
}
-(void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [super traitCollectionDidChange:previousTraitCollection];
    if (@available(iOS 13.0, *)) {
        if (_jsManager) {
            if ([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {
                [_jsManager sceneModeChange:self.traitCollection.userInterfaceStyle];
            }
        }
    } else {
    }
}
-(void)dealloc{
    if(!_loadAppView){
        [_loadAppView removeFromSuperview];
        _loadAppView = nil;
    }
    if (!_manager) {
        [_manager cancelTask];
        _manager = nil;
    }
    if(_webView){
        [_webView removeFromSuperview];
        _webView = nil;
    }
    if (_toastView) {
        [_toastView closeToast];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    if (!_statusBarStyle) {
        if (@available(iOS 13.0, *)) {
            return UIStatusBarStyleDarkContent;
        } else {
            return UIStatusBarStyleDefault;
        }
    }
    else{
        return _statusBarStyle;
    }
}
#pragma mark --下载界面
-(void)setUpLoadView{
    // 创建 APP load view
    UIView *loadAppView = [self creatLoadView];
    _loadAppView = loadAppView;
    [_appView addSubview:loadAppView];
}
-(void)removeLoadView{
    if(_loadAppView){
        [_loadAppView removeFromSuperview];
        _loadAppView = nil;
    }
}
#pragma mark -- 错误界面
-(void)setUpErrorView:(NSString *)reason{
    [self removeLoadView];
    UIView *errorView = [self creatErrorView:reason];
    _errorView = errorView;
    [_appView addSubview:errorView];
}
#pragma mark --APP界面
-(void)setUpAppView{
    _manager = nil;
    SanYueAppViewController *vc = (SanYueAppViewController *)self.navigationController;
    // 创建 SanYueScriptMessageManager
    SanYueScriptMessageManager *jsDelegate = [[SanYueScriptMessageManager alloc] initWithDelegate:self andJavaScripMethod:[self setUpJavaScripMethod]];
    jsDelegate.currentNavIndex = (int)(self.navigationController.childViewControllers.count - 1);
    jsDelegate.maxRouter = [self setUpMaxRouterNumber];
    _jsManager = jsDelegate;
    // webview
    SanYueMyWebView *webView = [SanYueMyWebView initWith:jsDelegate andNeedDebug:vc.needDeBug];
    _webView = webView;
    webView.customUserAgent = @"webApp/ios/0.1";
    webView.navigationDelegate = self;
    if (@available(iOS 11.0, *)) { webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever; }
    else { self.automaticallyAdjustsScrollViewInsets = NO; }
    NSURL *baseUrl = [NSURL fileURLWithPath: _webAppItem.rootPath isDirectory: YES];
    NSURL *htmlURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@.html",_webAppItem.rootPath,_pathName] isDirectory:NO];
    [webView loadFileURL:htmlURL allowingReadAccessToURL:baseUrl];
    _htmlURL = htmlURL;
    [webView setAlpha:0];
    [_appView addSubview:webView];
}
#pragma mark -- 公开的方法:loading界面展示
-(UIView *)creatLoadView{
    SanYueLoadView *loadAppView = [[SanYueLoadView alloc] initWithFrame:self.view.bounds];
    return loadAppView;
}
-(void)loadProgressWithType:(SanyueLoadStatus)type andProgress:(CGFloat)progress{}
#pragma mark -- 公开的方法:错误界面展示，
-(UIView *)creatErrorView:(NSString *)reason{
    SanYueErrorView *errorView = [[SanYueErrorView alloc] initWithFrame:self.view.bounds andText:reason addTarget:self reloadAction:@selector(reloadEvent) closeAction:@selector(backEvent) needReload:[_webAppItem.url isValidUrl]];
    return errorView;
}
#pragma mark -- 公开的方法
-(SanYueJavaScripMethod *)setUpJavaScripMethod{
    SanYueJavaScripMethod *jsM = [[SanYueJavaScripMethod alloc] init];
    return jsM;
}
-(int)setUpMaxRouterNumber{
    return 3;
}
#pragma mark -- 事件
-(void)loadEvent{
    __weak typeof(self) weakSelf = self;
    [self.manager start:^(SanyueLoadStatus type, CGFloat progress) {
        [weakSelf loadProgressWithType:type andProgress:progress];
    } successHandler:^(NSString * _Nullable path,NSString *date) {
        weakSelf.webAppItem.rootPath = path;
        weakSelf.webAppItem.date = date;
        [weakSelf setUpAppView];
    } errorHandler:^(NSError * _Nullable error) {
        [weakSelf setUpErrorView:[error localizedDescription]];
    }];
}
-(void)closeEvent{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)backEvent{
    if(self.navigationController.childViewControllers.count > 1){
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)reloadEvent{
    [_errorView removeFromSuperview];
    _errorView = nil;
    [self setUpLoadView];
    // 开始下载
    [self loadEvent];
}
-(void)aboutEvent{
    __weak typeof(self) weakSelf = self;
    SanYueActionSheetController *vc = [[SanYueActionSheetController alloc] initWithItem:_aboutMsg andHandler:^(int index) {
        [weakSelf.jsManager aboutListSelect:index];
    }];
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma mark -- js 代理事件
-(void)javaScriptMessageWithName:(NSString *)name andData:(NSDictionary *)data{}
-(void)evaluateJavaScript:(NSString *)func{
    [_webView evaluateJavaScript:func completionHandler:nil];
}
-(void)initView:(SanYueAppConfigItem *)item andID:(NSString *)ID{
    BOOL isPush = self.navigationController.childViewControllers.count > 1;
    // 判断是否需要 navBar
    if (item.hideNav) { _webView.frame = self.view.bounds; }
    else{
        SanYueNavView *navView = [[SanYueNavView alloc] init];
        if (isPush) { [navView addBackBtnTarget:self action:@selector(backEvent)]; }
        [navView changeNavByColor:item.navBackgroundColor andTitle:item.title andTextColor:item.titleColor];
        CGFloat y = CGRectGetMaxY(navView.frame);
        _navView = navView;
        [_appView addSubview:navView];
        _webView.frame = CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height - y);
    }
    // 更新 statusStyle
    if ([item.statusStyle isEqualToString:@"dark"]) {
        if (@available(iOS 13.0, *)) { _statusBarStyle = UIStatusBarStyleDarkContent; }
        else { _statusBarStyle =  UIStatusBarStyleDefault; }
    }
    else{ _statusBarStyle = UIStatusBarStyleLightContent; }
    [self setNeedsStatusBarAppearanceUpdate];
    // 设置 _webView 是否回弹 & 背景颜色
    _webView.scrollView.bounces = item.bounces;
    // 设置 滚动响应优先
    NSArray *gestureArray = self.navigationController.view.gestureRecognizers;
    for (UIGestureRecognizer *gestureRecognizer in gestureArray) {
        if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
            [_webView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:gestureRecognizer];
        }
    }
    
    _webView.scrollView.backgroundColor = [UIColor colorWithHexString:item.backgroundColor];
    __weak typeof(self) weakSelf = self;
    [self removeLoadView];
    [UIView animateWithDuration:0.25f animations:^{
        [weakSelf.webView setAlpha:1.0f];
    }];
    // 设置监听事件
    SanYueAppViewController *vc = (SanYueAppViewController *)self.navigationController;
    if (vc.reachability) {
        _jsManager.currentNetworkStatus = (int)[vc.reachability currentReachabilityStatus];
        [[NSNotificationCenter defaultCenter] addObserver:_jsManager selector:@selector(appNetWorkChange:) name:SanYueReachabilityChangedNotification object:nil];
    }
    [[NSNotificationCenter defaultCenter] addObserver:_jsManager selector:@selector(appBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:_jsManager selector:@selector(appBecomeNotActive) name:UIApplicationDidEnterBackgroundNotification object:nil];
    // 返回前端
    int index = (int)(self.navigationController.childViewControllers.count - 1);
    if (@available(iOS 13.0, *)) {
        NSString *style = self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ? @"dark" : @"light";
        NSDictionary *res = @{
            @"navIndex":[[NSNumber alloc] initWithInteger:index],
            @"style":style,
            @"extra":_extraMsg ? _extraMsg : @""
        };
        [self evaluateJavaScript:[NSString callBack:ID widthParame:res andError:nil andType:0]];
    }
    else{
        NSDictionary *res = @{
            @"navIndex":[[NSNumber alloc] initWithInteger:index],
            @"style":@"light",
            @"extra":_extraMsg ? _extraMsg : @""
        };
        [self evaluateJavaScript:[NSString callBack:ID widthParame:res andError:nil andType:0]];
    }
    _extraMsg = nil;
}
-(void)showToast:(CGFloat)time withText:(NSString *)text withIcon:(NSString *)icon withIsMask:(BOOL)isMask{
    if (time > 0) {
        [self.toastView showToast:time withText:text withIcon:nil withIsMask:isMask];
    }
    else{
        [self.toastView showToast:time withText:text withIcon:@"loading" withIsMask:isMask];
    }
}
-(void)hideToast{
    [self.toastView closeToast];
}
-(void)changeTopBar:(SanYueAppConfigItem *)item andNeedChangNavbar:(BOOL)need{
    if ([item.statusStyle isEqualToString:@"dark"]) {
        if (@available(iOS 13.0, *)) { _statusBarStyle = UIStatusBarStyleDarkContent; }
        else { _statusBarStyle =  UIStatusBarStyleDefault; }
    }
    else{
        _statusBarStyle = UIStatusBarStyleLightContent;
    }
    [self setNeedsStatusBarAppearanceUpdate];
    if (need && !item.hideNav && _navView) {
        [_navView changeNavByColor:item.navBackgroundColor andTitle:item.title andTextColor:item.titleColor];
    }
}
-(void)presentAlertViewController:(UIViewController *)vc andCompletion:(void (^ _Nullable)(void))completion{
    [self presentViewController:vc animated:YES completion:completion];
}
-(void)setViewController:(SanYueRouterItem *)item byType:(int)type{
    SanYueMainViewController *vc = [[SanYueMainViewController alloc] initWithName:item.name andItem:_webAppItem andExtra:item.extra andRouterDelegate:self];
    if (type == 0) {
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        if ([self.routerDelegate respondsToSelector:@selector(setUpPopDate:)]) {
            [self.routerDelegate setUpPopDate:nil];
        }
        NSInteger index = [self.navigationController.childViewControllers indexOfObject:self];
        NSMutableArray *vcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        vcs[index] = vc;
        [self.navigationController setViewControllers:vcs animated:NO];
    }
    
}
-(void)popViewController:(nullable NSDictionary *)dict andIsTooRoot:(BOOL)toRoot{
    if (toRoot) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else{
        if (self.routerDelegate && dict) {
            if ([self.routerDelegate respondsToSelector:@selector(setUpPopDate:)]) {
                [self.routerDelegate setUpPopDate:dict];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
-(void)setPopExtra:(NSDictionary *)data{
    if ([self.routerDelegate respondsToSelector:@selector(setUpPopDate:)]) {
        [self.routerDelegate setUpPopDate:data];
    }
}
-(void)reStartApp:(BOOL)reload{
    SanYueMainViewController *vc = [[SanYueMainViewController alloc] initWithURL:_webAppItem.url andNeedRef:reload];
    NSArray *vcs = @[vc];
    [self.navigationController setViewControllers:vcs animated:NO];
}
-(void)aboutList:(SanYueActionSheetItem *)item{
    _aboutMsg = item;
}
#pragma mark -- SanYueWebViewControllerRouterDelegate 代理
-(void)setUpPopDate:(NSDictionary *)dict{
    _extraMsg = dict;
}
#pragma mark -- WKNavigationDelegate 代理事件
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler{
    // 禁止外部网址，但是 承认 url 后的参数 ？ #。方便前端 hash 路由开发
    if ([navigationAction.request.URL.path isEqualToString:_htmlURL.path]) {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    else{
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}
@end
