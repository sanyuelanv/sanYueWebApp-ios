//
//  SanYueAppViewController.h
//  AFNetworking
//
//  Created by 宋航 on 2020/2/4.
//

#import <UIKit/UIKit.h>
@class Reachability;
@class SanYueMainViewController;;
NS_ASSUME_NONNULL_BEGIN

@interface SanYueAppViewController : UINavigationController
-(instancetype)initWithURL:(NSString *)url widthNeedDeBug:(BOOL)needDeBug withNetworkWatching:(nullable NSString *)watchURL;
-(instancetype)initWithViewController:(SanYueMainViewController *)vc widthNeedDeBug:(BOOL)needDeBug withNetworkWatching:(nullable NSString *)watchURL;
-(void)startNetworkWatching:(NSString *)url;
@property(nonatomic,assign) BOOL needDeBug;
@property(nonatomic,assign) CGFloat timeoutInterval;
@property(nonatomic, strong) Reachability *reachability;
+(NSString *)getCacheSize;
+(NSString *)clearCacheSize;
@end

NS_ASSUME_NONNULL_END
