//
//  SanYueMultiPickListItem.h
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/19.
//

#import <Foundation/Foundation.h>
#import "SanYueBaseObject.h"
NS_ASSUME_NONNULL_BEGIN

@interface SanYueMultiPickListItem : SanYueBaseObject
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSArray<SanYueMultiPickListItem *> *list;
-(instancetype)initWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
