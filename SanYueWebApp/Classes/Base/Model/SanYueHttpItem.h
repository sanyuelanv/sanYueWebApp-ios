//
//  SanYueHttpItem.h
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/11.
//

#import <Foundation/Foundation.h>
#import "SanYueBaseObject.h"
NS_ASSUME_NONNULL_BEGIN
@interface SanYueHttpItem : SanYueBaseObject
@property (nonatomic,strong)NSString *url;
@property (nonatomic,strong)NSDictionary *data;
@property (nonatomic,strong)NSDictionary *header;
@property (nonatomic,assign)int timeout;
@property (nonatomic,strong)NSString *method;
-(instancetype)initWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
