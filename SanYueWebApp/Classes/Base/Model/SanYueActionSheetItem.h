//
//  SanYueActionSheetItem.h
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/11.
//

#import "SanYueBaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SanYueActionSheetItem : SanYueBaseObject
@property(nonatomic,strong) NSString *itemColor;
@property(nonatomic,strong) NSString *cancelText;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *cancelColor;
@property(nonatomic,strong) NSArray<NSString *> *itemList;
-(instancetype)initWithDict:(NSDictionary *)dict;
@property(nonatomic,assign) int senseMode;
@property(nonatomic,strong) NSString *cancelColorDark;
@property(nonatomic,strong) NSString *itemColorDark;
@property(nonatomic,assign) BOOL backGroundCancel;
@end

NS_ASSUME_NONNULL_END
