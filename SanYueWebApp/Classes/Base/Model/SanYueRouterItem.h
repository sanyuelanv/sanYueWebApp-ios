//
//  SanYueRouterItem.h
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/20.
//

#import <Foundation/Foundation.h>
#import "SanYueBaseObject.h"
NS_ASSUME_NONNULL_BEGIN

@interface SanYueRouterItem : SanYueBaseObject
@property (nonatomic,strong)NSString *name;
@property (nonatomic,assign)BOOL isToRoot;
@property (nonatomic,strong)NSDictionary *extra;
-(instancetype)initWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
