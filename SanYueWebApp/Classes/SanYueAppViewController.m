//
//  SanYueAppViewController.m
//  AFNetworking
//
//  Created by 宋航 on 2020/2/4.
//

#import "SanYueAppViewController.h"
#import "SanYueDismissAnimation.h"
#import "SanYuePanInteractiveTransition.h"
#import "SanYueMainViewController.h"
#import "Reachability.h"
#import "NSString+SanYueExtension.h"
#import "SanYueAppInfoItem.h"
#import "SanYueHttpManager.h"
#import "SanYueWebAppItem.h"
#import "NSURLProtocol+SanYueEctension.h"
#import "SanYueWebviewProtocol.h"

@interface SanYueAppViewController ()<UIViewControllerTransitioningDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,strong)SanYuePanInteractiveTransition *panInteractiveTransition;
@property (nonatomic,strong)SanYueDismissAnimation *dismissAnimation;
@end

@implementation SanYueAppViewController
+(NSString *)getCacheSize{
    NSString* NAME = @"sanyueWeb";
    return [NAME getCacheSize:NO];
}
+(NSString *)clearCacheSize{
    NSString* NAME = @"sanyueWeb";
    [NAME delIfExists];
    return [SanYueAppViewController getCacheSize];
}

#pragma mark -- 网络监听
-(void)startNetworkWatching:(NSString *)url{
    self.reachability = [Reachability reachabilityWithHostName:url];
    [self.reachability startNotifier];
}
#pragma mark -- 懒加载
- (SanYuePanInteractiveTransition *)panInteractiveTransition{
    if(!_panInteractiveTransition) _panInteractiveTransition = [[SanYuePanInteractiveTransition alloc] init];
    return _panInteractiveTransition;
}
- (SanYueDismissAnimation *)dismissAnimation{
    if(!_dismissAnimation) _dismissAnimation = [[SanYueDismissAnimation alloc] init];
    return _dismissAnimation;
}
#pragma mark -- 进入退出的过渡动画
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context){
        UIView *view = [context viewForKey:UITransitionContextFromViewKey];
        view.alpha = 0.5;
        view.transform = CGAffineTransformMakeScale(0.95, 0.95);
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {}];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context){
        UIView *view = [context viewForKey:UITransitionContextToViewKey];
        view.alpha = 1;
        view.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {}];
}

-(instancetype)initWithURL:(NSString *)url widthNeedDeBug:(BOOL)needDeBug withNetworkWatching:(nullable NSString *)watchURL{
    SanYueMainViewController *vc = [[SanYueMainViewController alloc] initWithURL:url andNeedRef:needDeBug];
    self = [self initWithViewController:vc widthNeedDeBug:needDeBug withNetworkWatching:watchURL];
    return self;
}
-(instancetype)initWithViewController:(SanYueMainViewController *)vc widthNeedDeBug:(BOOL)needDeBug withNetworkWatching:(nullable NSString *)watchURL{
    self = [super initWithRootViewController:vc];
    // 加入网络拦截
    [NSURLProtocol registerClass:[SanYueWebviewProtocol class]];
    [NSURLProtocol WebKitRegisterScheme:@"webp"];
    [NSURLProtocol WebKitRegisterScheme:@"webps"];
    [NSURLProtocol WebKitRegisterScheme:@"file"];
    if (self) {
        self.needDeBug = needDeBug;
        if (watchURL) { [self startNetworkWatching:watchURL]; }
    }
    
    return self;
}
#pragma mark - UIViewControllerTransitioningDelegate
-(id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.dismissAnimation;
}
-(id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    return self.panInteractiveTransition.isInteractive ? self.panInteractiveTransition : nil;
}
#pragma mark - 多个手势处理
-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer*)otherGestureRecognizer{
   return [gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        return self.childViewControllers.count == 1;
    }
    else{
        return self.childViewControllers.count > 1;
    }
    
}
#pragma mark -- other
- (void)viewDidLoad{
    [super viewDidLoad];
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    self.navigationBar.hidden = YES;
    self.transitioningDelegate = self;
    [self.panInteractiveTransition panToDismiss:self];
    
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wundeclared-selector"
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    #pragma clang diagnostic pop
    
    [self.view addGestureRecognizer:pan];
    pan.delegate = self;
    self.interactivePopGestureRecognizer.enabled = NO;
}
- (void)dealloc{
    _panInteractiveTransition = nil;
    _dismissAnimation = nil;
    if (_reachability) {
        [_reachability stopNotifier];
        _reachability = nil;
    }
    [SanYueAppInfoItem deletInstance];
    [SanYueHttpManager deletInstance];
    [SanYueWebAppItem deletInstance];
    
    [NSURLProtocol WebKitUnregisterScheme:@"webp"];
    [NSURLProtocol WebKitUnregisterScheme:@"webps"];
    [NSURLProtocol unregisterClass:[SanYueWebviewProtocol class]];
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count >= 1) {
        // 隐藏底部 tabBar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}
@end
