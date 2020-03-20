//
//  SanYueManager.h
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/5.
//

#import <Foundation/Foundation.h>
#import "SanYueMainViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface SanYueManager : NSObject
@property (nonatomic,assign)NSTimeInterval timeoutInterval;
@property(nonatomic,assign)BOOL mustLoad;
-(instancetype)initWith:(NSString *)url;
-(void)start:(nullable void (^)(SanyueLoadStatus type,CGFloat progress))ProgressBlock successHandler:(nullable void (^)(NSString * _Nullable url,NSString *date))successHandler errorHandler:(nullable void (^)(NSError * _Nullable error))errorHandler;
-(void)cancelTask;
@end

NS_ASSUME_NONNULL_END
