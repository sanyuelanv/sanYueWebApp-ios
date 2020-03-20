//
//  SanYueMainViewController.h
//  AFNetworking
//
//  Created by 宋航 on 2020/2/4.
//

#import <UIKit/UIKit.h>
@class SanYueWebAppItem;
@class SanYueJavaScripMethod;
NS_ASSUME_NONNULL_BEGIN
typedef enum : NSInteger {
    SanyueLoading = 0,
    SanyueUpZiping,
} SanyueLoadStatus;
@class SanYueWebViewController;

@protocol SanYueWebViewControllerRouterDelegate <NSObject>
@required
- (void)setUpPopDate:(nullable NSDictionary *)dict;
@end

@interface SanYueMainViewController : UIViewController
// 外部初始化
-(instancetype)initWithURL:(NSString *)url andNeedRef:(BOOL)needRef;
// 内部初始化
-(instancetype)initWithName:(NSString *)name andItem:(SanYueWebAppItem *)webItem andExtra:(NSDictionary *)extra andRouterDelegate:(id<SanYueWebViewControllerRouterDelegate>) routerDelegate;
// 自定义 load & error
-(UIView *)creatLoadView;
-(UIView *)creatErrorView:(NSString *)reason;
-(void)loadProgressWithType:(SanyueLoadStatus)type andProgress:(CGFloat)progress;
//设置 web app 的路由数目
-(int)setUpMaxRouterNumber;
//设置 web app 的JavaScripMethod
-(SanYueJavaScripMethod *)setUpJavaScripMethod;

@end

NS_ASSUME_NONNULL_END
