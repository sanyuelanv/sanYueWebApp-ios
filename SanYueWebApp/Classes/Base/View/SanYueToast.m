//
//  XiaoZhuanLanToast.m
//  XiaoZhuanLan
//
//  Created by 宋航 on 2019/2/13.
//  Copyright © 2019 宋航. All rights reserved.
//

#import "SanYueToast.h"
@interface SanYueToast()
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, weak) UIView *toastView;
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *label;
@property (nonatomic, assign) int isShow;
@property (nonatomic, weak) UIActivityIndicatorView *loading;
@end
@implementation SanYueToast
-(UIView *)toastView{
	if (!_toastView) {
		UIView *toastView = [[UIView alloc] init];
		UILabel *label = [[UILabel alloc] init];
		UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(35, 25, 50, 50)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
		loading.center = CGPointMake(60, 50);
		toastView.layer.cornerRadius = 5;
		toastView.layer.masksToBounds = YES;
		toastView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.65];
		label.textColor = UIColor.whiteColor;
		label.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
		label.textAlignment = NSTextAlignmentCenter;
		[loading setHidden:YES];
		[imageView setHidden:YES];
		[toastView addSubview:label];
		[toastView addSubview:loading];
		[toastView addSubview:imageView];
		[self addSubview:toastView];
		_imageView = imageView;
		_toastView = toastView;
		_label = label;
		_loading = loading;
	}
	return _toastView;
}
-(instancetype)initWithSuperViewFrame:(CGRect)frame{
	self = [self init];
	_superViewFrame = frame;
	return self;
}
-(void)showToast:(CGFloat)time withText:(nullable NSString *)text withIcon:(nullable NSString *)icon withIsMask:(BOOL)isMask{
	// 清去上一次的
	if(_timer != nil){
		[_timer invalidate];
		_timer = nil;
	}
	CGRect toastRect = CGRectMake((_superViewFrame.size.width - 120) * 0.5, (_superViewFrame.size.height - 120) * 0.5, 120, 120);
	if (icon == nil) {
        CGFloat maxW = [UIScreen mainScreen].bounds.size.width * 0.7;
        CGSize textSize = [text boundingRectWithSize:CGSizeMake(maxW - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont fontWithName:@"PingFangSC-Medium" size: 16] } context:nil].size;
        
        CGFloat minW = 120;
        
        CGFloat textW = textSize.width + 20;
        if (textW < minW) {
            textW = minW;
        }
        else if (textW >= maxW) {
            textW = maxW;
        }
        //textW = maxW;
        CGFloat textH = textSize.height + 24;
		toastRect = CGRectMake(([UIScreen mainScreen].bounds.size.width - textW) * 0.5, (_superViewFrame.size.height - textH) * 0.5, textW, textH);
	}
	if (isMask) {
		self.frame = _superViewFrame;
		self.toastView.frame = toastRect;
	}
	else{
		self.frame = toastRect;
		self.toastView.frame = CGRectMake(0, 0, toastRect.size.width, toastRect.size.height);
	}
	// 设置 label 位置
	if (icon == nil || [icon isEqual:[NSNull null]]) {
        _label.numberOfLines = -1;
		_label.frame = CGRectMake(10, 12, toastRect.size.width - 20, toastRect.size.height - 24);
		[_imageView setHidden:YES];
		[_loading setHidden:YES];
		[_loading stopAnimating];
	}
	else{
		// 设置 icon
		if ([icon isEqualToString:@"loading"]) {
			[_imageView setHidden:YES];
			[_loading setHidden:NO];
			[_loading startAnimating];
			_label.text = @"loading";
		}
		else{
			[_imageView setHidden:NO];
			UIImage *image=[[UIImage alloc]initWithContentsOfFile:icon];
			[_imageView setImage:image];
			[_loading setHidden:YES];
			[_loading stopAnimating];
		}
		_label.numberOfLines = 1;
		_label.frame = CGRectMake(10, 73, 100, 40);
		
	}
	if (text != nil) { _label.text = text; }
	if (_isShow == 0) {
		_toastView.alpha = 0.1f;
		[self setHidden:NO];
		[self.toastView setHidden:NO];
		_isShow = 1;
		__weak typeof(self) weakSelf = self;
		[UIView animateWithDuration:0.25f animations:^{ weakSelf.toastView.alpha = 1.0f; }];
	}
	else if (_isShow == 2) {
		[_toastView.layer removeAllAnimations];
		_toastView.alpha = 1.0f;
		_isShow = 1;
	}
	// 计时
	if (time > 0) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(timeEvent) userInfo:nil repeats:NO];
	}
}
-(void)timeEvent{
    _timer = nil;
    [self closeToast];
}
-(void)closeToast{
	if(_timer != nil){ return; }
	_isShow = 2;
	__weak typeof(self) weakSelf = self;
	[UIView animateWithDuration:0.25f animations:^{
		weakSelf.toastView.alpha = 0.1f;
	} completion:^(BOOL finished) {
		if(weakSelf.isShow == 2){
			[weakSelf setHidden:YES];
			weakSelf.isShow = 0;
			[weakSelf.toastView setHidden:YES];
		}
	}];
}
-(void)dealloc{
	if(_timer != nil){
		[_timer invalidate];
		_timer = nil;
	}
}
@end
