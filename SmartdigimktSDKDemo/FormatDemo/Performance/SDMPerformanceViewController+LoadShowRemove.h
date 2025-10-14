//
//  SDMPerformanceViewController+LoadShowRemove.h
//  AnyThinkSDKDemo
//
//  Created by GUO PENG on 2022/4/24.
//  Copyright © 2022 AnyThink. All rights reserved.
//

#import "SDMPerformanceViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDMPerformanceViewController (LoadShowRemove)
- (void)loadAllSplashAd;

- (void)loadAllBannerAd;

- (void)loadAllNativeAd;

- (void)loadAllRewardVideoAd;

- (void)loadAllInterstitialAd;

- (void)showSplahAd;

- (void)showBannerAd;

- (void)showNativeAd;

- (void)showInterAd;

- (void)showRewardAd;

- (void)removeBanner;

- (void)removeNative;

- (void)loadAllAd;

@end

NS_ASSUME_NONNULL_END
