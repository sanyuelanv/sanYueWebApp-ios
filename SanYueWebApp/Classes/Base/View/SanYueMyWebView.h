//
//  SanYueMyWebView.h
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/7.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@class SanYueScriptMessageManager;
NS_ASSUME_NONNULL_BEGIN

@interface SanYueMyWebView : WKWebView
+(instancetype)initWith:(SanYueScriptMessageManager *)jsDelegate andNeedDebug:(BOOL) needDebug;
-(void)creatDebugScript;
@end

NS_ASSUME_NONNULL_END
