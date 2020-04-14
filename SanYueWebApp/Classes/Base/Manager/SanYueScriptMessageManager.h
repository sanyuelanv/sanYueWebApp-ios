//
//  SanYueScriptMessageManager.h
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/8.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "Reachability.h"
@class SanYueAppConfigItem;
@class SanYueToastItem;
@class SanYueAlertItem;
@class SanYueActionSheetItem;
@class SanYueJavaScripMethod;
@class SanYueRouterItem;

NS_ASSUME_NONNULL_BEGIN
@protocol SanYueScriptMessageDelegate <NSObject>
@required
-(void)javaScriptMessageWithName:(NSString *)name andData:(NSDictionary *)data;
-(void)initView:(SanYueAppConfigItem *)item andID:(NSString *)ID;
-(void)evaluateJavaScript:(NSString *)func;
-(void)showToast:(CGFloat)time withText:(nullable NSString *)text withIcon:(nullable NSString *)icon withIsMask:(BOOL)isMask;
-(void)hideToast;
-(void)changeTopBar:(SanYueAppConfigItem *)item andNeedChangNavbar:(BOOL)need;
-(void)presentAlertViewController:(UIViewController *)vc andCompletion:(void (^ __nullable)(void))completion;
-(void)setViewController:(SanYueRouterItem *)item byType:(int)type;
-(void)popViewController:(nullable NSDictionary *)dict andIsTooRoot:(BOOL)toRoot;
-(void)setPopExtra:(NSDictionary *)data;
-(void)reStartApp:(BOOL)reload;
-(void)aboutList:(SanYueActionSheetItem *)item;
@end

@interface SanYueScriptMessageManager : NSObject<WKScriptMessageHandler>
- (instancetype)initWithDelegate:(id <SanYueScriptMessageDelegate>)scriptDelegate andJavaScripMethod:(SanYueJavaScripMethod *)javaScripMethod;
// 参数
@property (nonatomic,weak) id<SanYueScriptMessageDelegate>scriptDelegate;
@property(nonatomic, strong) SanYueJavaScripMethod *javaScripMethod;
// 数据
@property (nonatomic,assign) int currentNavIndex;
@property (nonatomic,assign) int maxRouter;
@property(nonatomic, assign) NetworkStatus currentNetworkStatus;
// 事件
-(void)appBecomeActive;
-(void)viewActive:(NSDictionary *)dict;
-(void)aboutListSelect:(int)index;
-(void)viewHide;
-(void)sceneModeChange:(UIUserInterfaceStyle)style API_AVAILABLE(ios(13.0));
-(void)appBecomeNotActive;
-(void)appNetWorkChange:(NSNotification *)note;
@end

NS_ASSUME_NONNULL_END
