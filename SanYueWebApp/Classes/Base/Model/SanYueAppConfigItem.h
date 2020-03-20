//
//  SanYueAppConfigItem.h
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/10.
//

#import <Foundation/Foundation.h>
#import "SanYueBaseObject.h"
NS_ASSUME_NONNULL_BEGIN
@interface SanYueAppConfigItem : SanYueBaseObject
@property (nonatomic,strong)NSString *backgroundColor;
@property (nonatomic,strong)NSString *navBackgroundColor;
@property (nonatomic,strong)NSString *statusStyle;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *titleColor;
@property (nonatomic,assign)BOOL hideNav;
@property (nonatomic,assign)BOOL bounces;
@property (nonatomic,assign)int networkTimeout;
-(instancetype)initWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict andDef:(SanYueAppConfigItem *)item;
@end

NS_ASSUME_NONNULL_END
