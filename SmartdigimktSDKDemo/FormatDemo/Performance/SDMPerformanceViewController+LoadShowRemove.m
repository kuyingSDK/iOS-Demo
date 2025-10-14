//
//  SDMPerformanceViewController+LoadShowRemove.m
//  AnyThinkSDKDemo
//
//  Created by GUO PENG on 2022/4/24.
//  Copyright © 2022 AnyThink. All rights reserved.
//

#import "SDMPerformanceViewController+LoadShowRemove.h"
#import <SmartdigimktSDK/SDMBannerView.h>
#import <SmartdigimktSDK/SDMInterstitialAd.h>
#import <SmartdigimktSDK/SDMNativeAd.h>
#import <SmartdigimktSDK/SDMRewardedVideoAd.h>
#import <SmartdigimktSDK/SDMSplashAd.h>
#import <SmartdigimktSDK/SDMNativeLayoutParams.h>
#import "SDMDemoUIHeader.h"
#import <Masonry/Masonry.h>
#import "SDMNativeSelfRenderView.h"
#import <SmartdigimktSDK/SDMNativePrepareInfo.h>
#import <SmartdigimktSDK/SDMNativeLayoutParams.h>


@implementation SDMPerformanceViewController (LoadShowRemove)

#define kSDMSplashPlacement @"b5fa25036683d2"
#define kSDMBannerPlacement @"b5fa24ff8a7446"
#define kSDMNativePlacement @"b5fa25023d0767"
#define kSDMInterstitialPlacement @"b5fa25016e80bd"
#define kSDMRewardVideoPlacement @"b5fa2500639c86"

#pragma mark - load
- (void)loadAllAd {
    [self loadAllSplashAd];
    [self loadAllBannerAd];
    [self loadAllNativeAd];
    [self loadAllInterstitialAd];
    [self loadAllRewardVideoAd];
}

- (void)loadAllSplashAd {
    [self loadSplashAd:kSDMSplashPlacement];
}

- (void)loadAllBannerAd {
    [self loadBannerAd:kSDMBannerPlacement];
}

- (void)loadAllNativeAd {
    [self loadNativeAd:kSDMNativePlacement];
}

- (void)loadAllInterstitialAd {
    [self loadInterstitialAd:kSDMInterstitialPlacement];
}

- (void)loadAllRewardVideoAd {
    [self loadRewardVideoAd:kSDMRewardVideoPlacement];
}

- (void)loadRewardVideoAd:(NSString *)placementId {
    if (!self.rewardAd) {
        SDMRewardedVideoAd *adInfo = [[SDMRewardedVideoAd alloc] initAdWithPlacementId:placementId];
        self.rewardAd = adInfo;
        self.rewardAd.loadDelegate = self.rewardProxy;
        self.rewardAd.showDelegate = self.rewardProxy;
    }
//    self.rewardAd.extra = dict;
    [self.rewardAd load];
}

- (void)loadInterstitialAd:(NSString *)placementId {
    if (!self.interAd) {
        SDMInterstitialAd *adInfo = [[SDMInterstitialAd alloc] initAdWithPlacementId:placementId];
        self.interAd = adInfo;
        self.interAd.loadDelegate = self.interstitialProxy;
        self.interAd.showDelegate = self.interstitialProxy;
    }
    CGSize size = CGSizeMake(CGRectGetWidth(self.view.bounds) - 30.0f, 550.0f);
    
//    self.interAd.showViewController = inViewController;
    [self.interAd load];
}


- (void)loadSplashAd:(NSString *)splashPlacementId {
    if (!self.splashAd) {
        SDMSplashAd *adInfo = [[SDMSplashAd alloc] initAdWithPlacementId:splashPlacementId];
        self.splashAd = adInfo;
        self.splashAd.loadDelegate = self.splashProxy;
        self.splashAd.showDelegate = self.splashProxy;
    }
    
    [self.splashAd load];
}

- (void)loadBannerAd:(NSString *)bannerPlacementId {
    if (!self.bannerAd) {
        CGSize adSize = CGSizeMake(CGRectGetWidth(self.view.bounds), 250);
        SDMBannerView *bannerView = [[SDMBannerView alloc] initWithFrame:CGRectMake(0, 0, adSize.width, adSize.height)];
        self.bannerAd = bannerView;
        bannerView.placementId = bannerPlacementId;
        bannerView.delegate = self.bannerProxy;
    }
    SDMAdRequest *adRequest = [[SDMAdRequest alloc] init];
    adRequest.adWidth = 320;
    adRequest.adHeight = 250;
    [self.bannerAd loadWithAdRequest:adRequest];
}

- (void)loadNativeAd:(NSString *)nativePlacementId {
    if (!self.nativeOperate) {
        SDMNative *adInfo = [[SDMNative alloc] initAdWithPlacementId:nativePlacementId];
        self.nativeOperate = adInfo;
        adInfo.delegate = self.nativeProxy;
    }
    [self.nativeOperate load];
}

#pragma mark - show
- (void)showSplahAd {
    if (!self.splashAd) {
        return;
    }
    UIWindow *mainWindow = nil;
    if ( @available(iOS 13.0, *) ) {
        mainWindow = [UIApplication sharedApplication].windows.firstObject;
        [mainWindow makeKeyWindow];
    }else {
        mainWindow = [UIApplication sharedApplication].keyWindow;
    }
    self.splashAd.window = mainWindow;
    self.isNormalFullFormatShow = YES;
    [self.splashAd showAd];
}

- (void)showBannerAd {
    if (!self.bannerAd) {
        return;
    }
    NSInteger tag = 3333333;
    [[self.view viewWithTag:tag] removeFromSuperview];

    UIView *bannerView = self.bannerAd;
    if (bannerView != nil) {
        bannerView.translatesAutoresizingMaskIntoConstraints = NO;
        bannerView.tag = tag;
        self.bannerAdView = [[UIView alloc]init];// bannerView;
        self.bannerAdView.backgroundColor =  randomColor;
        [self.bannerAdView addSubview:bannerView];
        [self.view addSubview:self.bannerAdView];
        CGFloat y = self.nativeAdSize.height + kNavigationBarHeight + 20 + 50;
        self.bannerAdView.frame = CGRectMake(0, y, self.bannerAdSize.width, self.bannerAdSize.height);
        [bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bannerAdView);
        }];
    }
    
}

- (void)showNativeAd {
    if (!self.nativeAd) {
        return;
    }
    
    if (self.renderMulView) {
        [self.renderMulView removeFromSuperview];
    }

    SDMNativeLayoutParams *config = [[SDMNativeLayoutParams alloc] init];
    config.AdFrame = CGRectMake(.0f, kNavigationBarHeight + 20, self.nativeAdSize.width, self.nativeAdSize.height);
    config.mediaViewFrame = CGRectMake(0, 110, self.nativeAdSize.width, self.nativeAdSize.height - 110.0f);
    config.sizeToFit = YES;
    config.rootViewController = self;
    SDMNativeSelfRenderView *selfRenderView = [[SDMNativeSelfRenderView alloc] initWithOffer:self.nativeAd];
    self.renderMulView = selfRenderView;
    selfRenderView.frame = CGRectMake(0, kNavigationBarHeight, kScreenW, 350);
    //    [nativeADView registerClickableViewArray:];
//
//    self.nativeAdView  = nativeADView;
//    self.nativeAdView.backgroundColor = randomColor;
//    
//    UIView *mediaView = [nativeADView getMediaView];
//    
//    mediaView.frame =  CGRectMake(0, 110, self.nativeAdSize.width, self.nativeAdSize.height - 110.0f);
//    
//    mediaView.backgroundColor = randomColor;
//    
//    [selfRenderView addSubview:mediaView];
    SDMNativePrepareInfo *info = [SDMNativePrepareInfo loadPrepareInfo:^(SDMNativePrepareInfo * _Nonnull prepareInfo) {
        prepareInfo.textLabel = selfRenderView.textLabel;
        prepareInfo.advertiserLabel = selfRenderView.advertiserLabel;
        prepareInfo.titleLabel = selfRenderView.titleLabel;
        prepareInfo.ratingLabel = selfRenderView.ratingLabel;
        prepareInfo.iconImageView = selfRenderView.iconImageView;
        prepareInfo.mainImageView = selfRenderView.mainImageView;
        prepareInfo.dislikeButton = selfRenderView.dislikeButton;
        prepareInfo.ctaLabel = selfRenderView.ctaLabel;
        prepareInfo.mediaView = selfRenderView.mediaView;
        prepareInfo.mediaContainerView = selfRenderView.mediaContainerView;
    }];
    NSArray *clickView = @[
        selfRenderView.iconImageView,
        selfRenderView.titleLabel,
        selfRenderView.textLabel,
        selfRenderView.ctaLabel,
        selfRenderView.mainImageView
    ];
    [self.nativeAd registerAdView:selfRenderView clickViews:clickView prepareInfo:info configParam:config closeView:nil];
    
    [self.view addSubview:selfRenderView];
}

- (void)showInterAd {
    if (!self.interAd) {
        return;
    }
    self.interAd.showViewController = self;
    self.isNormalFullFormatShow = YES;
    [self.interAd showAd];
}

- (void)showRewardAd {
    if (!self.rewardAd) {
        return;
    }
    self.rewardAd.showViewController = self;
    self.isNormalFullFormatShow = YES;
    [self.rewardAd showAd];
}

#pragma mark - remove
- (void)removeBanner {
    if (self.bannerAdView && self.bannerAdView.superview) {
        [self.bannerAdView removeFromSuperview];
        self.bannerAdView = nil;
    }
    
}

- (void)removeNative{
    if (self.renderMulView) {
        [self.renderMulView removeFromSuperview];
        self.renderMulView = nil;
    }
}


@end
