//
//  SDMNativeSelfRenderView.m
//  AnyThinkSDKDemo
//
//  Created by GUO PENG on 2022/5/7.
//  Copyright © 2022 AnyThink. All rights reserved.
//

#import "SDMNativeSelfRenderView.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>
#import <SmartdigimktSDK/SDMNativeAd.h>
#import "SDMDemoUIHeader.h"

@interface SDMNativeSelfRenderView()

@property (nonatomic, strong) SDMNativeAd *nativeAd;

@end

@implementation SDMNativeSelfRenderView

- (void)dealloc {
    NSLog(@"🔥---SDMNativeSelfRenderView--销毁");
    [self destory];
}

- (void)destory {
    // 更及时销毁 offer
    _nativeAd = nil;
}

- (instancetype)initWithOffer:(SDMNativeAd *)offer {
    if (self = [super init]) {
        _nativeAd = offer;
        
        [self addView];
        [self makeConstraintsForSubviews];
        [self setupUI];
    }
    return self;
}

- (void)addView {
    self.advertiserLabel = [[UILabel alloc]init];
    self.advertiserLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    self.advertiserLabel.textColor = [UIColor blackColor];
    self.advertiserLabel.textAlignment = NSTextAlignmentLeft;
    self.advertiserLabel.userInteractionEnabled = YES;
    self.advertiserLabel.layer.masksToBounds = YES;
    self.advertiserLabel.layer.cornerRadius = 10;
    [self addSubview:self.advertiserLabel];
        
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.userInteractionEnabled = YES;
    self.titleLabel.layer.masksToBounds = YES;
    self.titleLabel.layer.cornerRadius = 10;
    [self addSubview:self.titleLabel];
    
    self.textLabel = [[UILabel alloc]init];
    self.textLabel.font = [UIFont systemFontOfSize:15.0f];
    self.textLabel.textColor = [UIColor blackColor];
    self.textLabel.userInteractionEnabled = YES;
    self.textLabel.layer.masksToBounds = YES;
    self.textLabel.layer.cornerRadius = 10;
    [self addSubview:self.textLabel];
    
    self.ctaLabel = [[UILabel alloc]init];
    self.ctaLabel.font = [UIFont systemFontOfSize:15.0f];
    self.ctaLabel.textColor = [UIColor blackColor];
    self.ctaLabel.userInteractionEnabled = YES;
    self.ctaLabel.backgroundColor = randomColor;
    self.ctaLabel.layer.masksToBounds = YES;
    self.ctaLabel.layer.cornerRadius = 10;
    [self addSubview:self.ctaLabel];

    self.ratingLabel = [[UILabel alloc]init];
    self.ratingLabel.font = [UIFont systemFontOfSize:15.0f];
    self.ratingLabel.textColor = [UIColor blackColor];
    self.ratingLabel.userInteractionEnabled = YES;
    self.ratingLabel.layer.masksToBounds = YES;
    self.ratingLabel.layer.cornerRadius = 10;
    [self addSubview:self.ratingLabel];
        
    self.iconImageView = [[UIImageView alloc]init];
    self.iconImageView.layer.cornerRadius = 4.0f;
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.iconImageView.userInteractionEnabled = YES;
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 10;
    [self addSubview:self.iconImageView];
    
    self.mainImageView = [[UIImageView alloc]init];
    self.mainImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.mainImageView.userInteractionEnabled = YES;
    self.mainImageView.layer.masksToBounds = YES;
    self.mainImageView.layer.cornerRadius = 10;
    [self addSubview:self.mainImageView];
    
    
    self.mediaContainerView = [[UIView alloc] init];
    self.mediaContainerView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.mediaContainerView];
    
    UIImage *closeImg = [UIImage imageNamed:@"icon_webview_close" inBundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"SmartdigimktSDK" ofType:@"bundle"]] compatibleWithTraitCollection:nil];
    self.dislikeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.dislikeButton.backgroundColor = randomColor;
    self.dislikeButton.layer.masksToBounds = YES;
    self.dislikeButton.layer.cornerRadius = 10;
    [self.dislikeButton setImage:closeImg forState:0];
    [self addSubview:self.dislikeButton];
}

- (void)setupUI {
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.nativeAd.nativeAdOffer.iconUrl]];
    NSLog(@"🔥AnyThinkDemo::iconUrl:%@",self.nativeAd.nativeAdOffer.iconUrl);

    [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:self.nativeAd.nativeAdOffer.imageUrl]];
    NSLog(@"🔥AnyThinkDemo::imageUrl:%@",self.nativeAd.nativeAdOffer.imageUrl);
    
    NSLog(@"🔥----logoUrl:%@",self.nativeAd.nativeAdOffer.logoUrl);
//    NSLog(@"🔥----logoSet:%@",self.nativeAd.nativeAdOffer.logoSet);
    
//    self.advertiserLabel.text = self.nativeAd.nativeAdOffer.advertiser;
    self.titleLabel.text = self.nativeAd.nativeAdOffer.title;
    self.textLabel.text = self.nativeAd.nativeAdOffer.mainText;
    self.ctaLabel.text = self.nativeAd.nativeAdOffer.ctaText;
//    self.ratingLabel.text = [NSString stringWithFormat:@"%@", self.nativeAd.nativeAdOffer.rating ? self.nativeAd.nativeAdOffer.rating : @""];
    
    NSLog(@"🔥AnythinkDemo::native文本内容title:%@ ; text:%@ ; cta:%@ ",self.nativeAd.nativeAdOffer.title, self.nativeAd.nativeAdOffer.mainText, self.nativeAd.nativeAdOffer.ctaText);
}

- (void)makeConstraintsForSubviews {
    self.titleLabel.backgroundColor = randomColor;
    self.textLabel.backgroundColor = randomColor;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(100);
        make.right.equalTo(self).offset(-40);
        make.top.equalTo(self).offset(20);
        make.height.equalTo(@20);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(100);
        make.right.equalTo(self).offset(-40);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.height.equalTo(@20);
    }];
    
    [self.ctaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLabel.mas_bottom).equalTo(@5);
        make.left.equalTo(self.textLabel.mas_left);
        make.width.equalTo(@100);
        make.height.equalTo(@40);
    }];
    
    [self.ratingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ctaLabel.mas_right).offset(20);
        make.top.equalTo(self.ctaLabel.mas_top).offset(0);
        make.width.equalTo(@20);
        make.height.equalTo(@40);
    }];
    
    [self.advertiserLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).equalTo(@-5);
        make.left.equalTo(self.ctaLabel.mas_right).offset(50);
        make.bottom.equalTo(self.iconImageView.mas_bottom);
        make.height.equalTo(@30);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self).offset(20);
        make.height.width.equalTo(@75);
    }];
    
    [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(25);
        make.bottom.equalTo(self).offset(-5);
    }];

    [self.dislikeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).equalTo(@5);
        make.right.equalTo(self.mas_right).equalTo(@-5);
        make.height.width.equalTo(@30);
    }];
    
    [self.mediaContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(25);
        make.bottom.equalTo(self).offset(-5);
    }];
}

@end
