//
//  NativeSelfRenderView.h
//  iOSDemo
//
//  Created by SDK Demo
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SDMNativeAd;

@interface NativeSelfRenderView : UIView

/// 图标
@property (nonatomic, strong) UIImageView *iconImageView;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 描述文本
@property (nonatomic, strong) UILabel *textLabel;
/// 广告商
@property (nonatomic, strong) UILabel *advertiserLabel;
/// 评分
@property (nonatomic, strong) UILabel *ratingLabel;
/// CTA按钮
@property (nonatomic, strong) UILabel *ctaLabel;
/// 主图
@property (nonatomic, strong) UIImageView *mainImageView;
/// 媒体视图容器
@property (nonatomic, strong) UIView *mediaContainerView;
/// 媒体视图
@property (nonatomic, strong) UIView *mediaView;
/// Logo图标
@property (nonatomic, strong) UIImageView *logoImageView;
/// 关闭按钮
@property (nonatomic, strong) UIButton *dislikeButton;

- (instancetype)initWithNativeAd:(SDMNativeAd *)nativeAd;

@end

NS_ASSUME_NONNULL_END
