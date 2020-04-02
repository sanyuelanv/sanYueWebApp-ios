//
//  SanYuePickerViewController.m
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/14.
//

#import "SanYuePickerViewController.h"
#import "SanYueAlertAnimation.h"
#import "SanYuePickItem.h"
#import "SanYueMultiPickListItem.h"
#import "UIView+SanYueCategory.h"
typedef void(^SelectBlock)(int index,int type);
typedef void(^SelectMultiBlock)(NSArray<NSNumber *> *value,int type);
typedef void(^SelectTimeBlock)(NSString *res,int type);
@interface SanYuePickerViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,copy) SelectBlock selectBlock;
@property (nonatomic,copy) SelectMultiBlock selectMultiBlock;
@property (nonatomic,copy) SelectTimeBlock selectTimeBlock;

@property (nonatomic,strong) SanYuePickItem *item;
@property (nonatomic,assign) int selectIndex;
@property (nonatomic,strong) NSString *selectTime;
@property (nonatomic,strong) NSArray<NSNumber *> *selecIndexList;
@property (nonatomic,assign) int height;
@property (nonatomic,assign)BOOL isShow;

@property (nonatomic,weak) UIView *mainView;
@property (nonatomic,weak) UIView *bgView;
@property (nonatomic,weak) UIPickerView *pickerView;
@end
@implementation SanYuePickerViewController
-(instancetype)initWithItem:(SanYuePickItem *)item andHandler:(void (^ __nullable)(int index,int type))handler{
    self = [super init];
    if (self) {
        _item = item;
        _selectBlock = handler;
        _selectIndex = _item.normalValue;
        self.senseMode = item.senseMode;
        [self setUpNormalView];
    }
    return self;
}
-(instancetype)initWithItem:(SanYuePickItem *)item andMultiHandler:(void (^ __nullable)(NSArray<NSNumber *> *value,int type))multiHandler{
    self = [super init];
    if (self) {
        _item = item;
        _selectMultiBlock = multiHandler;
        self.senseMode = item.senseMode;
        [self setUpNormalView];
    }
    return self;
}
-(instancetype)initWithItem:(SanYuePickItem *)item andTimeHandler:(void (^ __nullable)(NSString *res,int type))handler{
    self = [super init];
    if (self) {
        _item = item;
        _selectTimeBlock = handler;
        self.senseMode = item.senseMode;
        [self setUpTimeView];
    }
    return self;
}
# pragma mark - 懒加载属性
- (int)height{
    if (!_height) {
        _height = [UIScreen mainScreen].bounds.size.height * 0.4;
    }
    return _height;
}
# pragma mark - UI
-(void)setUpMainView{
    CGFloat WIDTH = [UIScreen mainScreen].bounds.size.width;
    CGFloat HEIGHT = [UIScreen mainScreen].bounds.size.height;
    UIColor *mainViewBgColor = UIColor.whiteColor;
    UIColor *lineColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0];
    UIColor *cancelColor = [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0];
    UIColor *okColor = [UIColor colorWithRed:31/255.0 green:162/255.0 blue:20/255.0 alpha:1.0];
    if (@available(iOS 13.0, *)) {
        mainViewBgColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle != UIUserInterfaceStyleDark) { return UIColor.whiteColor; }
            else{ return [UIColor colorWithRed:22/255.0 green:22/255.0 blue:22/255.0 alpha:1.0]; }
        }];
        lineColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle != UIUserInterfaceStyleDark) { return [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0]; }
            else{ return [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0]; }
        }];
        okColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) { return [UIColor colorWithRed:27/255.0 green:142/255.0 blue:19/255.0 alpha:1.0]; }
            else{ return [UIColor colorWithRed:31/255.0 green:162/255.0 blue:20/255.0 alpha:1.0]; }
        }];
    }
    CGFloat bgHeight = HEIGHT - self.height;
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT,WIDTH, self.height)];
    mainView.backgroundColor = mainViewBgColor;
    [self.view addSubview:mainView];
    _mainView = mainView;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, bgHeight)];
    bgView.userInteractionEnabled = YES;
    if (_item.backGroundCancel) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backEvent:)];
        [bgView addGestureRecognizer:tap];
    }
    bgView.backgroundColor = UIColor.clearColor;
    [self.view addSubview:bgView];
    _bgView = bgView;
    // topView 50pt
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, WIDTH, 0.5)];
    lineView.backgroundColor = lineColor;
    [mainView addSubview:lineView];
    // cancelBtn
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelBtn.frame = CGRectMake(0, 0, 70, 50);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:cancelColor forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
    [cancelBtn addTarget:self action:@selector(backEvent:) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:cancelBtn];
    // OkBtn
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    okBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 70, 0, 70, 50);
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn setTitleColor:okColor forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(okBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    okBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
    [mainView addSubview:okBtn];
    [mainView addRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight withRadius:12];
}
-(void)setUpNormalView{
    self.view.backgroundColor = UIColor.clearColor;
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self setUpMainView];
    // picked
    UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 50, _mainView.bounds.size.width, _mainView.bounds.size.height)];
    _pickerView = pickerView;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [_mainView addSubview:pickerView];
    switch (_item.mode) {
        case 0:{
            if (_item.normalValue > 1) { [pickerView selectRow:_item.normalValue inComponent:0 animated:NO]; }
            break;
        }
        case 1:{
            _selecIndexList = _item.multiValue;
            for (int i = 0; i < _selecIndexList.count; i++) {
                int index = [_selecIndexList[i] intValue];
                [pickerView selectRow:index inComponent:i animated:NO];
            }
            break;
        }
    }
    
}
-(void)setUpTimeView{
    self.view.backgroundColor = UIColor.clearColor;
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self setUpMainView];
    // picked
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 50, _mainView.bounds.size.width, _mainView.bounds.size.height)];
    if (_item.mode == 2) {
        datePicker.datePickerMode = UIDatePickerModeTime;
        // 设置显示最大时间（此处为当前时间）
        [datePicker setMaximumDate:_item.timeEnd];
        [datePicker setMinimumDate:_item.timeStart];
        datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"en_GB"];
    }
    else if (_item.mode == 3) {
        datePicker.datePickerMode = UIDatePickerModeDate;
        if(_item.timeEnd){ [datePicker setMaximumDate:_item.timeEnd]; }
        if(_item.timeStart){ [datePicker setMinimumDate:_item.timeStart]; }
        datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];;
        
    }
    [datePicker setDate:_item.timeValue animated:NO];
    _selectTime = _item.originTimeValue;
    [_mainView addSubview:datePicker];;
    [datePicker addTarget:self action:@selector(datePIckerChange:) forControlEvents:UIControlEventValueChanged];
}
# pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
}
# pragma mark - 取消 & 确认 事件
- (void)backEvent:(UIView *)view{
    int type = -1;
    if ([view isKindOfClass:[UIButton class]]) { type = -1; }
    else{ type = -2; }
    switch (_item.mode) {
        case 0:{
            _selectBlock(0,type);
            break;
        }
        case 1:{
            _selectMultiBlock(nil,type);
            break;
        }
        case 2:
        case 3:{
            _selectTimeBlock(nil,type);
            break;
        }
        default:{
            
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)okBtnEvent{
    switch (_item.mode) {
        case 0:{
            _selectBlock(_selectIndex,0);
            break;
        }
        case 1:{
            _selectMultiBlock(_selecIndexList,0);
            break;
        }
        case 2:
        case 3:{
            _selectTimeBlock(_selectTime,0);
            break;
        }
        default:{
            
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
# pragma mark - datePicker change event
-(void)datePIckerChange:(UIDatePicker *)datePicker{
    NSDate *date = datePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (_item.mode == 2) {
        [formatter setDateFormat:@"HH:mm"];
        NSString *str = [formatter stringFromDate:date];
        _selectTime = str;
    }
    else{
        if (_item.timeStart && ([date earlierDate:_item.timeStart] == date)) {
            return;
        }
        if (_item.timeEnd && ([date laterDate:_item.timeEnd] == date)) {
            return;
        }
        [formatter setDateFormat:@"YYYY-MM-dd"];
        NSString *str = [formatter stringFromDate:date];
        _selectTime = str;
    }
    
    if (_item.listenChange) { _selectTimeBlock(_selectTime,1); }
}
# pragma mark - 展示 & 隐藏 事件
-(void)show:(NSTimeInterval)duration andCompletion:(void (^ __nullable)(BOOL finished))completion{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        CGFloat WIDTH = [UIScreen mainScreen].bounds.size.width;
        CGFloat HEIGHT = [UIScreen mainScreen].bounds.size.height;
        weakSelf.mainView.frame = CGRectMake(0, HEIGHT - self.height, WIDTH, self.height);
        weakSelf.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    } completion:^(BOOL finished) {
        completion(finished);
        weakSelf.isShow = YES;
    }];
}
-(void)dismiss:(NSTimeInterval)duration andCompletion:(void (^ __nullable)(BOOL finished))completion{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        CGFloat WIDTH = [UIScreen mainScreen].bounds.size.width;
        CGFloat HEIGHT = [UIScreen mainScreen].bounds.size.height;
        weakSelf.mainView.frame = CGRectMake(0, HEIGHT,WIDTH, self.height);
        weakSelf.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
    } completion:^(BOOL finished) {
        completion(finished);
        weakSelf.isShow = NO;
    }];
}
# pragma mark - UIPickerViewDataSource代理事件
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    switch (_item.mode) {
        case 0:{ return 1; }
        case 1:{ return _item.multiValue.count; }
        default:{ return 0; }
    }
}
- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (_item.mode) {
        case 0:{ return _item.list.count; }
        case 1:{
            NSArray<SanYueMultiPickListItem *> *arr = _item.list;
            for (int i = 0; i < component; i++) {
                int index = [_selecIndexList[i] intValue];
                SanYueMultiPickListItem *item = arr[index];
                arr = item.list;
            }
            return arr.count;
        }
        default:{ return 0; }
    }
}
# pragma mark - UIPickerViewDelegate代理事件
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (_item.mode) {
        case 0:{ return _item.list[row]; }
        case 1:{
            NSArray<SanYueMultiPickListItem *> *arr = _item.list;
            for (int i = 0; i < component; i++) {
                int index = [_selecIndexList[i] intValue];
                SanYueMultiPickListItem *item = arr[index];
                arr = item.list;
            }
            SanYueMultiPickListItem *item = arr[row];
            return item.name;
        }
        default:{ return nil; }
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (_item.mode) {
        case 0:{
            int selectIndex = (int)row;
            if(_selectIndex != selectIndex){
                _selectIndex = selectIndex;
                if (_item.listenChange) { _selectBlock(_selectIndex,1); }
            }
            break;
        }
        case 1:{
            NSInteger nowSelect = [_selecIndexList[component] integerValue];
            if (nowSelect == row) {
                return;
            }
            NSMutableArray<NSNumber *> *arr = [NSMutableArray arrayWithArray:_selecIndexList];
            for (int i = (int)component; i < _selecIndexList.count; i++) {
                if (i == component) { arr[i] = [[NSNumber alloc] initWithInteger:row];}
                else{
                    arr[i] = [[NSNumber alloc] initWithInteger:0];
                    [pickerView selectRow:0 inComponent:i animated:NO];
                }
            }
            _selecIndexList = arr;
            if (_item.listenChange) { _selectMultiBlock(_selecIndexList,1); }
            [pickerView reloadAllComponents];
            break;
        }
        default:{  }
    }
}
@end
