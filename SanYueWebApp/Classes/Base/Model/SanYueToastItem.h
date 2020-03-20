//
//  SanYueToastItem.h
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/11.
//

#import <Foundation/Foundation.h>
#import "SanYueBaseObject.h"
NS_ASSUME_NONNULL_BEGIN

@interface SanYueToastItem : SanYueBaseObject
@property (nonatomic,strong)NSString *content;
@property (nonatomic,assign)BOOL mask;
@property (nonatomic,assign)CGFloat time;
-(instancetype)initWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
