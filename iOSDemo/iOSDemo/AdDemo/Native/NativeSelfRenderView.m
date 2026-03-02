//
//  NativeSelfRenderView.m
//  iOSDemo
//
//  Created by SDK Demo
//

#import "NativeSelfRenderView.h"
#import <SmartdigimktSDK/SmartdigimktSDK.h>
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>

@interface NativeSelfRenderView()

@property (nonatomic, strong) SDMNativeAd *nativeAd;

@end

@implementation NativeSelfRenderView

- (instancetype)initWithNativeAd:(SDMNativeAd *)nativeAd {
    if (self = [super init]) {
        _nativeAd = nativeAd;
        [self setupUI];
        [self updateAdData];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    // 图标
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    _iconImageView.clipsToBounds = YES;
    _iconImageView.layer.cornerRadius = 4;
    [self addSubview:_iconImageView];
    
    // 标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.numberOfLines = 1;
    [self addSubview:_titleLabel];
    
    // 描述
    _textLabel = [[UILabel alloc] init];
    _textLabel.font = [UIFont systemFontOfSize:14];
    _textLabel.textColor = [UIColor darkGrayColor];
    _textLabel.numberOfLines = 2;
    [self addSubview:_textLabel];
 
    // CTA按钮
    _ctaLabel = [[UILabel alloc] init];
    _ctaLabel.font = [UIFont boldSystemFontOfSize:14];
    _ctaLabel.textColor = [UIColor whiteColor];
    _ctaLabel.backgroundColor = [UIColor colorWithRed:0.28 green:0.43 blue:1.0 alpha:1.0];
    _ctaLabel.textAlignment = NSTextAlignmentCenter;
    _ctaLabel.layer.cornerRadius = 4;
    _ctaLabel.clipsToBounds = YES;
    [self addSubview:_ctaLabel];
    
    // 主图
    _mainImageView = [[UIImageView alloc] init];
    _mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    _mainImageView.clipsToBounds = YES;
    [self addSubview:_mainImageView];
    
    // 媒体容器
    _mediaContainerView = [[UIView alloc] init];
    _mediaContainerView.backgroundColor = [UIColor blackColor];
    _mediaContainerView.clipsToBounds = YES;
    [self addSubview:_mediaContainerView];
    
    // Logo
    _logoImageView = [[UIImageView alloc] init];
    _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_logoImageView];
    
    _ratingLabel = [[UILabel alloc]init];
    _ratingLabel.font = [UIFont systemFontOfSize:15.0f];
    _ratingLabel.textColor = [UIColor blackColor];
    _ratingLabel.userInteractionEnabled = YES;
    _ratingLabel.layer.masksToBounds = YES;
    _ratingLabel.layer.cornerRadius = 10;
    [self addSubview:_ratingLabel];
    
    _advertiserLabel = [[UILabel alloc]init];
    _advertiserLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    _advertiserLabel.textColor = [UIColor blackColor];
    _advertiserLabel.textAlignment = NSTextAlignmentLeft;
    _advertiserLabel.userInteractionEnabled = YES;
    _advertiserLabel.layer.masksToBounds = YES;
    _advertiserLabel.layer.cornerRadius = 10;
    [self addSubview:_advertiserLabel];
    
    // 关闭按钮
    UIImage *closeImg = [UIImage imageNamed:@"icon_webview_close" inBundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"SmartdigimktSDK" ofType:@"bundle"]] compatibleWithTraitCollection:nil];
    _dislikeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_dislikeButton setImage:closeImg forState:UIControlStateNormal];
    _dislikeButton.tintColor = [UIColor grayColor];
    [self addSubview:_dislikeButton];
    
    [self setupConstraints];
}

- (void)setupConstraints {
    // 图标
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(12);
        make.width.height.mas_equalTo(50);
    }];
    
    // 标题
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(12);
        make.right.equalTo(self.dislikeButton.mas_left).offset(-8);
        make.top.equalTo(self.iconImageView);
    }];
    
    // 描述
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(12);
        make.right.equalTo(self.dislikeButton.mas_left).offset(-8);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
    }];
  
    // 关闭按钮
    [_dislikeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-12);
        make.top.equalTo(self).offset(12);
        make.width.height.mas_equalTo(24);
    }];
    
    // CTA按钮
    [_ctaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self.mas_centerX).offset(-12);
        make.height.mas_equalTo(44);
        make.bottom.equalTo(self).offset(-12);
    }];
    
    [_ratingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ctaLabel);
        make.left.equalTo(self.ctaLabel.mas_right).offset(10);
        make.right.equalTo(self).offset(-10);
    }];
    
    [_advertiserLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.ctaLabel.mas_bottom);
        make.left.equalTo(self.ctaLabel.mas_right).offset(10);
        make.right.equalTo(self).offset(-10);
    }];
    
    // 媒体容器
    [_mediaContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(10);
        make.bottom.equalTo(self.ctaLabel.mas_top).offset(-5);
    }];
    
    // 主图
    [_mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(10);
        make.bottom.equalTo(self.ctaLabel.mas_top).offset(-5);
    }];
     
    // Logo
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.width.height.mas_equalTo(20);
    }];
}

- (void)updateAdData {
    if (!_nativeAd || !_nativeAd.nativeAdOffer) {
        return;
    }
    
    SDMNativeAdOffer *offer = _nativeAd.nativeAdOffer;
    
    // 设置文本
    _titleLabel.text = offer.title ?: @"";
    _textLabel.text = offer.mainText ?: @"";
    _ctaLabel.text = offer.ctaText ?: @"立即下载";
    
 
    // 加载图标
    if (offer.iconUrl.length > 0) {
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:offer.iconUrl] placeholderImage:nil];
    }
    
    // 加载主图
    if (offer.imageUrl.length > 0) {
        [_mainImageView sd_setImageWithURL:[NSURL URLWithString:offer.imageUrl] placeholderImage:nil];
    }
    
    // 加载Logo
    if (offer.logoUrl.length > 0) {
        [_logoImageView sd_setImageWithURL:[NSURL URLWithString:offer.logoUrl] placeholderImage:nil];
    }
    
    // 判断是否有视频
    if (offer.isVideoContents) {
        _mainImageView.hidden = YES;
        _mediaContainerView.hidden = NO;
    } else {
        _mainImageView.hidden = NO;
        _mediaContainerView.hidden = YES;
    }
}

@end
