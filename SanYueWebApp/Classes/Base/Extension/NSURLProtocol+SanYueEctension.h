//
//  NSURLProtocol+SanYueEctension.h
//  SanYueWebApp
//
//  Created by 宋航 on 2020/5/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURLProtocol (SanYueEctension)
+ (void)WebKitRegisterScheme:(NSString*)scheme;
+ (void)WebKitUnregisterScheme:(NSString*)scheme;
@end

NS_ASSUME_NONNULL_END
