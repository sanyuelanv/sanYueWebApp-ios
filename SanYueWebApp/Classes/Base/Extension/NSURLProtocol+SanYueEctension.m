//
//  NSURLProtocol+SanYueEctension.m
//  SanYueWebApp
//
//  Created by 宋航 on 2020/5/11.
//

#import "NSURLProtocol+SanYueEctension.h"
#import <WebKit/WebKit.h>

@implementation NSURLProtocol (SanYueEctension)
+ (void)WebKitRegisterScheme:(NSString*)scheme{
    Class cls = [[[WKWebView new] valueForKey:@"browsingContextController"] class];
    SEL sel = NSSelectorFromString(@"registerSchemeForCustomProtocol:");
    if ([(id)cls respondsToSelector:sel]) {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [(id)cls performSelector:sel withObject:scheme];
    #pragma clang diagnostic pop
        }
    
}
+ (void)WebKitUnregisterScheme:(NSString*)scheme{
    Class cls = [[[WKWebView new] valueForKey:@"browsingContextController"] class];
    SEL sel = NSSelectorFromString(@"unregisterSchemeForCustomProtocol:");
    if ([(id)cls respondsToSelector:sel]) {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [(id)cls performSelector:sel withObject:scheme];
    #pragma clang diagnostic pop
        }
}
@end
