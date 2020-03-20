//
//  SanYueJavaScripMethod.h
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SanYueJavaScripMethod : NSObject
-(NSArray *)getAllMethods;
-(NSArray *)getDefaultMethods;
-(NSArray *)getCustomMethods;
-(BOOL)setCustomMethods:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
