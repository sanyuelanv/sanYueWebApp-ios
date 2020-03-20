//
//  SanYuePickItem.h
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/14.
//

#import <Foundation/Foundation.h>
#import "SanYueBaseObject.h"
@class SanYueMultiPickListItem;
NS_ASSUME_NONNULL_BEGIN

@interface SanYuePickItem : SanYueBaseObject
@property (nonatomic,assign)int mode;
@property (nonatomic,assign)BOOL listenChange;
@property (nonatomic,assign)int senseMode;

@property (nonatomic,strong)NSArray *list;
@property (nonatomic,assign)int normalValue;
@property (nonatomic,strong)NSArray<SanYueMultiPickListItem *> *multiList;
@property (nonatomic,strong)NSArray<NSNumber *> *multiValue;

@property (nonatomic,strong)NSDate *timeStart;
@property (nonatomic,strong)NSDate *timeEnd;
@property (nonatomic,strong)NSDate *timeValue;
@property (nonatomic,strong)NSString *originTimeValue;

-(instancetype)initWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
