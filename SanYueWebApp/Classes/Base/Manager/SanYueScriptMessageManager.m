//
//  SanYueScriptMessageManager.m
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/8.
//

#import <WebKit/WebKit.h>
#import<AudioToolbox/AudioToolbox.h>
#import "SanYueScriptMessageManager.h"
#import "SanYueJavaScripMethod.h"
#import "NSString+SanYueExtension.h"
#import "SanYueAppInfoItem.h"
#import "SanYueAppConfigItem.h"
#import "SanYueHttpManager.h"
#import "SanYueToastItem.h"
#import "SanYueAlertItem.h"
#import "SanYueActionSheetItem.h"
#import "SanYuePickItem.h"
#import "SanYuePickerViewController.h"
#import "SanYueHttpItem.h"
#import "SanYueRouterItem.h"
#import "SanYueMainViewController.h"
#import "SanYueWebAppItem.h"
#import "Reachability.h"
#import "SanYueModalController.h"
#import "SanYueActionSheetController.h"

API_AVAILABLE(ios(10.0))
@interface SanYueScriptMessageManager()
@property(nonatomic, strong)SanYueAppConfigItem *appConfigItem;
@property (nonatomic,strong)SanYueHttpManager *httpManager;
@property(nonatomic, strong) UIPasteboard *pasteboard;
@property (nonatomic, strong) UIImpactFeedbackGenerator *impactLight;
@property (nonatomic,strong)NSDictionary<NSString *,NSURLSessionDataTask *> *fetchTaskDict;
@property (nonatomic,assign)BOOL isInit;
@property (nonatomic,assign)BOOL isAppActive;
@end

@implementation SanYueScriptMessageManager
-(instancetype)initWithDelegate:(id <SanYueScriptMessageDelegate>)scriptDelegate andJavaScripMethod:(SanYueJavaScripMethod *)javaScripMethod{
    self = [super init];
    if (self) {
        self.scriptDelegate = scriptDelegate;
        self.javaScripMethod = javaScripMethod;
    }
    return self;
}
-(void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    // 判断 回调ID & 参数 key 是否存在
    if (![[message.body allKeys] containsObject:@"id"] || ![[message.body allKeys] containsObject:@"data"]) { return; }
    NSArray *jsMethods = [_javaScripMethod getDefaultMethods];
    if([jsMethods containsObject:message.name]){
        // 默认的方法
        SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@:",message.name]);
        @try { [self performSelector:selector withObject:message.body];}
        @catch (NSException *exception) {
            //NSLog(@"--- %@",exception.reason);
        }
        @finally {}
    }
    else{
        if (self.scriptDelegate) {
            if ([_scriptDelegate respondsToSelector:@selector(javaScriptMessageWithName:andData:)]) {
                [_scriptDelegate javaScriptMessageWithName:message.name andData:message.body];
            }
        }
    }
}
-(void)dealloc{
    if (!_httpManager) {
        [_httpManager.tasks makeObjectsPerformSelector:@selector(cancel)];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark 懒加载
-(UIImpactFeedbackGenerator *)impactLight API_AVAILABLE(ios(10.0)){
    if (!_impactLight) {
        UIImpactFeedbackGenerator *impactLight = [[UIImpactFeedbackGenerator alloc]initWithStyle:UIImpactFeedbackStyleMedium];
        _impactLight = impactLight;
        [_impactLight prepare];
    }
    return _impactLight;
}
-(UIPasteboard *)pasteboard{
    if (!_pasteboard) { _pasteboard = [UIPasteboard generalPasteboard]; }
    return  _pasteboard;
}
-(SanYueHttpManager *)httpManager{
    if (!_httpManager) {
        _httpManager = [SanYueHttpManager shareInstance];
    }
    return _httpManager;
}
#pragma mark js 方法
// 初始化
-(void)SanYue_init:(NSDictionary *)data{
    if(_isInit) return;
    SanYueAppConfigItem *item = [[SanYueAppConfigItem alloc] initWithDict:data[@"data"]];
    _appConfigItem = item;
    [self.httpManager setTimeout:_appConfigItem.networkTimeout];
    NSString *ID = data[@"id"];
    _isInit = YES;
    _isAppActive = YES;
    if (self.scriptDelegate) {
        if ([_scriptDelegate respondsToSelector:@selector(initView:andID:)]) {
            [_scriptDelegate initView:item andID:ID];
        }
    }
}
// 数据 相关
-(void)SanYue_getSystemInfo:(NSDictionary *)data{
    SanYueAppInfoItem *item = [SanYueAppInfoItem shareInstance];
    NSString *ID = data[@"id"];
    NSDictionary *res = [item getAllMsgDictBy:_appConfigItem.hideNav];
    [self evaluateJavaScript:[NSString callBack:ID widthParame:res andError:nil andType:0]];
}
// UI 相关
-(void)SanYue_showToast:(NSDictionary *)data{
    SanYueToastItem *item = [[SanYueToastItem alloc] initWithDict:data[@"data"]];
    if (self.scriptDelegate) {
        if ([self.scriptDelegate respondsToSelector:@selector(showToast:withText:withIcon:withIsMask:)]) {
            [self.scriptDelegate showToast:item.time withText:item.content withIcon:nil withIsMask:item.mask];
        }
    }
}
-(void)SanYue_hiddenLoad:(NSDictionary *)data{
    if (self.scriptDelegate) {
        if ([self.scriptDelegate respondsToSelector:@selector(hideToast)]) {
            [self.scriptDelegate hideToast];
        }
    }
}
-(void)SanYue_setStatusStyle:(NSDictionary *)data{
    NSString *style = data[@"data"][@"style"];
    _appConfigItem.statusStyle = style;
    if (self.scriptDelegate) {
        if ([self.scriptDelegate respondsToSelector:@selector(changeTopBar:andNeedChangNavbar:)]) {
            [self.scriptDelegate changeTopBar:_appConfigItem andNeedChangNavbar:NO];
        }
    }
}
-(void)SanYue_setNavBar:(NSDictionary *)data{
    SanYueAppConfigItem *item = [[SanYueAppConfigItem alloc] initWithDict:data[@"data"] andDef:_appConfigItem];
    _appConfigItem = item;
    if (self.scriptDelegate) {
        if ([self.scriptDelegate respondsToSelector:@selector(changeTopBar:andNeedChangNavbar:)]) {
            [self.scriptDelegate changeTopBar:_appConfigItem andNeedChangNavbar:YES];
        }
    }
}
-(void)SanYue_showModal:(NSDictionary *)data{
    SanYueAlertItem *item = [[SanYueAlertItem alloc] initWithDict:data[@"data"]];
    NSString *ID = data[@"id"];
    __weak typeof(self) weakSelf = self;
    SanYueModalController *vc = [[SanYueModalController alloc] initWithItem:item andHandler:^(int index) {
        NSDictionary *res = @{ @"result":[NSNumber numberWithInt:index] };
        [weakSelf evaluateJavaScript:[NSString callBack:ID widthParame:res andError:nil andType:0]];
    }];
    if (self.scriptDelegate) {
        if ([self.scriptDelegate respondsToSelector:@selector(presentViewController:animated:completion:)]) {
            [self.scriptDelegate presentAlertViewController:vc andCompletion:nil];
        }
    }
}
-(void)SanYue_showActionSheet:(NSDictionary *)data{
    SanYueActionSheetItem *item = [[SanYueActionSheetItem alloc] initWithDict:data[@"data"]];
    NSString *ID = data[@"id"];
    __weak typeof(self) weakSelf = self;
    SanYueActionSheetController *vc = [[SanYueActionSheetController alloc] initWithItem:item andHandler:^(int index) {
        NSDictionary *res = @{ @"result":[NSNumber numberWithInt:index] };
        [weakSelf evaluateJavaScript:[NSString callBack:ID widthParame:res andError:nil andType:0]];
    }];
//    SanYueAppAlertController *vc = [SanYueAppAlertController initActionSheet:item handler:^(int index) {
//        NSDictionary *res = @{ @"result":[NSNumber numberWithInt:index] };
//        [weakSelf evaluateJavaScript:[NSString callBack:ID widthParame:res andError:nil andType:0]];
//    }];
    if (self.scriptDelegate) {
        if ([self.scriptDelegate respondsToSelector:@selector(presentViewController:animated:completion:)]) {
            [self.scriptDelegate presentAlertViewController:vc andCompletion:nil];
        }
    }
}
-(void)SanYue_showPick:(NSDictionary *)data{
    SanYuePickItem *item = [[SanYuePickItem alloc] initWithDict:data[@"data"]];
    NSString *ID = data[@"id"];
    __weak typeof(self) weakSelf = self;
    SanYuePickerViewController *vc;
    switch (item.mode) {
        case 0:{
            vc = [[SanYuePickerViewController alloc] initWithItem:item andHandler:^(int index,int type) {
                if(type < 0){
                    NSDictionary *res = @{ @"result":[[NSNumber alloc] initWithInt:type] };
                    [weakSelf evaluateJavaScript:[NSString callBack:ID widthParame:res andError:nil andType:0]];
                }
                else{
                    NSDictionary *res = @{ @"result":[NSNumber numberWithInt:index] };
                    if (type == 0) { [weakSelf evaluateJavaScript:[NSString callBack:ID widthParame:res andError:nil andType:0]]; }
                    else{ [weakSelf evaluateJavaScript:[NSString callBack:ID widthParame:res andError:nil andType:1]]; }
                }
            }];
            break;
        }
        case 1:{
            vc = [[SanYuePickerViewController alloc] initWithItem:item andMultiHandler:^(NSArray<NSNumber *> * _Nonnull value, int type) {
               if(type < 0){
                    NSDictionary *res = @{ @"result":[[NSNumber alloc] initWithInt:type] };
                    [weakSelf evaluateJavaScript:[NSString callBack:ID widthParame:res andError:nil andType:0]];
                }
                else{
                    NSDictionary *res = @{ @"result":value };
                    if (type == 0) { [weakSelf evaluateJavaScript:[NSString callBack:ID widthParame:res andError:nil andType:0]]; }
                    else{ [weakSelf evaluateJavaScript:[NSString callBack:ID widthParame:res andError:nil andType:1]]; }
                }
            }];
            break;
        }
        case 2:
        case 3:{
            vc = [[SanYuePickerViewController alloc] initWithItem:item andTimeHandler:^(NSString *value,int type) {
                if(type < 0){
                    NSDictionary *res = @{ @"result":[[NSNumber alloc] initWithInt:type] };
                    [weakSelf evaluateJavaScript:[NSString callBack:ID widthParame:res andError:nil andType:0]];
                }
                else{
                    NSDictionary *res = @{ @"result":value };
                    if (type == 0) { [weakSelf evaluateJavaScript:[NSString callBack:ID widthParame:res andError:nil andType:0]]; }
                    else{ [weakSelf evaluateJavaScript:[NSString callBack:ID widthParame:res andError:nil andType:1]]; }
                }
            }];
            break;
        }
        default:{
            break;
        }
    }
    if (vc && self.scriptDelegate) {
        if ([self.scriptDelegate respondsToSelector:@selector(presentViewController:animated:completion:)]) {
            [self.scriptDelegate presentAlertViewController:vc andCompletion:nil];
        }
    }
}
// 网络 相关
-(void)SanYue_fetch:(NSDictionary *)data{
    SanYueHttpItem *item = [[SanYueHttpItem alloc] initWithDict:data[@"data"]];
    NSString *ID = data[@"id"];
    if (item == nil) {
        NSDictionary *res = @{ @"err":@"非法参数" };
        [self evaluateJavaScript:[NSString callBack:ID widthParame:res andError:nil andType:0]];
        return;
    }
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [self.httpManager fetch:item.method url:item.url parameters:item.data header:item.header progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = @{
            @"data":responseObject
        };
        [weakSelf removeFetchTaskByID:ID byNeedCall:NO];
        [self evaluateJavaScript:[NSString callBack:ID widthParame:res andError:nil andType:0]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSDictionary *res = @{
            @"err":[error localizedDescription]
        };
        [weakSelf removeFetchTaskByID:ID byNeedCall:NO];
        [self evaluateJavaScript:[NSString callBack:ID widthParame:nil andError:res andType:0]];
    }];
    [self addFetchTaskByID:ID andTask:task];
}
-(void)SanYue_fetch_stop:(NSDictionary *)data{
    NSString *ID = data[@"data"][@"id"];
    [self removeFetchTaskByID:ID byNeedCall:YES];
}
-(void)SanYue_getNetworkType:(NSDictionary *)data{
    NSString *ID = data[@"id"];
    NSDictionary *res = @{
        @"result":[NSNumber numberWithInteger:_currentNetworkStatus]
    };
    [self evaluateJavaScript:[NSString callBack:ID widthParame:res andError:nil andType:0]];
}
// 剪切板
-(void)SanYue_getClipboardData:(NSDictionary *)data{
    NSString *ID = data[@"id"];
    if (self.pasteboard.string != nil) {
        NSDictionary *res = @{ @"result":self.pasteboard.string };
        [self evaluateJavaScript:[NSString callBack:ID widthParame:res andError:nil andType:0]];
    }
    else {
        NSDictionary *err = @{ @"err":@"" };
        [self evaluateJavaScript:[NSString callBack:ID widthParame:nil andError:err andType:0]];
    }

}
-(void)SanYue_setClipboardData:(NSDictionary *)data{
    NSString *ID = data[@"id"];
    NSString *text = data[@"data"][@"text"];
    self.pasteboard.string = text;
    if ([self.pasteboard.string isEqualToString:text]) {
        NSDictionary *res = @{ @"result":@1 };
        [self evaluateJavaScript:[NSString callBack:ID widthParame:res andError:nil andType:0]];
    }
    else {
        NSDictionary *err = @{ @"err":@"" };
        [self evaluateJavaScript:[NSString callBack:ID widthParame:nil andError:err andType:0]];
    }

}
// 马达
-(void)SanYue_vibrateLong:(NSDictionary *)data{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}
-(void)SanYue_vibrateShort:(NSDictionary *)data{
    if (@available(iOS 10.0, *)) {
        [self.impactLight impactOccurred];
    }
}
// 路由相关
-(void)SanYue_navPush:(NSDictionary *)data{
    NSString *ID = data[@"id"];
    SanYueRouterItem *item = [[SanYueRouterItem alloc] initWithDict:data[@"data"]];
    if (_currentNavIndex >= (_maxRouter - 1)) {
        NSDictionary *err = @{ @"err":@"max router" };
        [self evaluateJavaScript:[NSString callBack:ID widthParame:nil andError:err andType:0]];
    }
    else{
        // 判断文件是否存在
        SanYueWebAppItem *webAppItem = [SanYueWebAppItem shareInstance];
        NSString *pathName = [NSString stringWithFormat:@"%@/%@.html",webAppItem.rootPath,item.name];
        if ([pathName FileIsExists:NO]) {
            NSDictionary *res = @{ @"res":@1 };
            if (self.scriptDelegate) {
                if ([self.scriptDelegate respondsToSelector:@selector(setViewController:byType:)]) {
                    [self.scriptDelegate setViewController:item byType:0];
                }
            }
            [self evaluateJavaScript:[NSString callBack:ID widthParame:res andError:nil andType:0]];
        }
        else{
            NSDictionary *err = @{ @"err":@"路径文件不存在" };
            [self evaluateJavaScript:[NSString callBack:ID widthParame:nil andError:err andType:0]];
        }
        
    }
}
-(void)SanYue_navReplace:(NSDictionary *)data{
    NSString *ID = data[@"id"];
    SanYueRouterItem *item = [[SanYueRouterItem alloc] initWithDict:data[@"data"]];
    SanYueWebAppItem *webAppItem = [SanYueWebAppItem shareInstance];
    NSString *pathName = [NSString stringWithFormat:@"%@/%@.html",webAppItem.rootPath,item.name];
    if ([pathName FileIsExists:NO]) {
        if (self.scriptDelegate) {
            if ([self.scriptDelegate respondsToSelector:@selector(setViewController:byType:)]) {
                [self.scriptDelegate setViewController:item byType:1];
            }
        }
    }
    else{
        NSDictionary *err = @{ @"err":@"路径文件不存在" };
        [self evaluateJavaScript:[NSString callBack:ID widthParame:nil andError:err andType:0]];
    }
}
-(void)SanYue_navPop:(NSDictionary *)data{
    SanYueRouterItem *item = [[SanYueRouterItem alloc] initWithDict:data[@"data"]];
    if (self.scriptDelegate) {
        if ([self.scriptDelegate respondsToSelector:@selector(popViewController:andIsTooRoot:)]) {
            [self.scriptDelegate popViewController:item.extra andIsTooRoot:item.isToRoot];
        }
    }

}
-(void)SanYue_setPopExtra:(NSDictionary *)data{
    SanYueRouterItem *item = [[SanYueRouterItem alloc] initWithDict:data[@"data"]];
    NSString *ID = data[@"id"];
    NSDictionary *res = @{ @"res":@1 };
    if (self.scriptDelegate) {
        if ([self.scriptDelegate respondsToSelector:@selector(setPopExtra:)]) {
            [self.scriptDelegate setPopExtra:item.extra];
        }
    }
    // 调用 vc 去执行
    [self evaluateJavaScript:[NSString callBack:ID widthParame:res andError:nil andType:0]];
}
-(void)SanYue_restart:(NSDictionary *)data{
    if (self.scriptDelegate) {
        if ([self.scriptDelegate respondsToSelector:@selector(reStartApp:)]) {
            [self.scriptDelegate reStartApp:YES];
        }
    }
}
#pragma mark -- 监听事件
-(void)appBecomeActive{
    if (_isInit && !_isAppActive) {
        [self evaluateJavaScript:[NSString callBack:@"AppToActive" widthParame:nil andError:nil andType:2]];
        _isAppActive = YES;
    }
}
-(void)appBecomeNotActive{
    if (_isInit && _isAppActive) {
        [self evaluateJavaScript:[NSString callBack:@"AppToBackGround" widthParame:nil andError:nil andType:2]];
        _isAppActive = NO;
    }
}
-(void)appNetWorkChange:(NSNotification *)note{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (_currentNetworkStatus != netStatus) {
        _currentNetworkStatus = netStatus;
        NSDictionary *res = @{
            @"result":[[NSNumber alloc] initWithInteger:_currentNetworkStatus]
        };
        [self evaluateJavaScript:[NSString callBack:@"NetworkType" widthParame:res andError:nil andType:2]];
    }
}
-(void)viewActive:(NSDictionary *)dict{
    if (dict) {
        NSDictionary *res = @{ @"extra":dict };
        [self evaluateJavaScript:[NSString callBack:@"ViewShow" widthParame:res andError:nil andType:2]];
    }
    else{
        [self evaluateJavaScript:[NSString callBack:@"ViewShow" widthParame:nil andError:nil andType:2]];
    }
}
-(void)viewHide{
    [self evaluateJavaScript:[NSString callBack:@"ViewHide" widthParame:nil andError:nil andType:2]];
}
-(void)sceneModeChange:(UIUserInterfaceStyle)style API_AVAILABLE(ios(13.0)){
    if (_isInit && _isAppActive) {
        NSDictionary *res = style == UIUserInterfaceStyleDark ? @{ @"mode" : @"dark" } : @{ @"mode" : @"light" };
        [self evaluateJavaScript:[NSString callBack:@"SceneMode" widthParame:res andError:nil andType:2]];
    }
}
#pragma mark -- helper 事件
-(void)evaluateJavaScript:(NSString *)func{
    NSString *newFunc = [NSString stringWithFormat:@"try { %@ } catch (error) {  }",func];
    if (self.scriptDelegate) {
        if ([_scriptDelegate respondsToSelector:@selector(evaluateJavaScript:)]) {
            [_scriptDelegate evaluateJavaScript:newFunc];
        }
    }
}
-(void)addFetchTaskByID:(NSString *)ID andTask:(NSURLSessionDataTask *)task{
    NSMutableDictionary *fetchTaskDict = [[NSMutableDictionary alloc] initWithDictionary:_fetchTaskDict];
    [fetchTaskDict setValue:task forKey:ID];
    _fetchTaskDict = fetchTaskDict;
}
-(void)removeFetchTaskByID:(NSString *)ID byNeedCall:(BOOL)needCall{
    NSURLSessionDataTask *task = [_fetchTaskDict objectForKey:ID];
    if (task) {
        if (needCall) { [task cancel]; }
        NSMutableDictionary *fetchTaskDict = [[NSMutableDictionary alloc] initWithDictionary:_fetchTaskDict];
        [fetchTaskDict removeObjectForKey:ID];
        _fetchTaskDict = fetchTaskDict;
    }
}
@end
