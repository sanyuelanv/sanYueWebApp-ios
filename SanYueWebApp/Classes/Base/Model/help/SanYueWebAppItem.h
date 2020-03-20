//
//  SanYueWebAppItem.h
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SanYueWebAppItem : NSObject
+(void)deletInstance;
+(id)shareInstance;
@property (nonatomic,strong)NSString *date;
@property (nonatomic,strong)NSString *url;
@property (nonatomic,strong)NSString *rootPath;
@property (nonatomic,strong)NSString *size;
@property (nonatomic,assign)int type;
@end

NS_ASSUME_NONNULL_END
