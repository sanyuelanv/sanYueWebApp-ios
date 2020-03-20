//
//  SanYueAppInfoItem.h
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SanYueAppInfoItem : NSObject
-(NSDictionary *)getAllMsgDictBy:(BOOL)hideNav;
+(id)shareInstance;
+(void)deletInstance;
@end

NS_ASSUME_NONNULL_END
