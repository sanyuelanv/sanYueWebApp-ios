//
//  SanYueMyWebView.m
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/7.
//

#import "SanYueMyWebView.h"
#import "SanYueScriptMessageManager.h"
#import "SanYueJavaScripMethod.h"
@interface SanYueMyWebView()
@property (nonatomic,strong)NSArray *jsMethods;
@property (nonatomic,assign)BOOL needDebug;
@end
@implementation SanYueMyWebView
+(instancetype)initWith:(SanYueScriptMessageManager *)jsDelegate andNeedDebug:(BOOL) needDebug{
    SanYueMyWebView *view = [[SanYueMyWebView alloc] initWithFrame:CGRectZero];
    WKWebViewConfiguration *config = view.configuration;
    config.preferences = [[WKPreferences alloc] init];
    config.preferences.minimumFontSize = 1;
    config.preferences.javaScriptEnabled = YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    config.processPool = [[WKProcessPool alloc] init];
    NSArray *jsMethods = [jsDelegate.javaScripMethod getAllMethods];
    for (NSString *methodName in jsMethods) {
        [config.userContentController addScriptMessageHandler:jsDelegate name:methodName];
    }
    if (needDebug) { [view creatDebugScript]; }
    view.jsMethods = jsMethods;
    return view;
}
-(void)creatDebugScript{
    NSBundle *bundle = [NSBundle bundleForClass:self.classForCoder];
    NSURL *bundleURL = [[bundle resourceURL] URLByAppendingPathComponent:@"SanYueWebApp.bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithURL:bundleURL];
    NSString *jsFile = [resourceBundle pathForResource:@"vconsole" ofType:@"js"];
    NSString *js = [NSString stringWithContentsOfFile:jsFile encoding:NSUTF8StringEncoding error:nil];
    WKUserScript *script = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [self.configuration.userContentController addUserScript:script];
}
-(void)dealloc{
    for (NSString *methodName in _jsMethods) {
        [self.configuration.userContentController removeScriptMessageHandlerForName:methodName];
    }
    [self.configuration.userContentController removeAllUserScripts];
}
@end
