//
//  SDMPerformanceViewController.h
//  AnyThinkSDKDemo
//
//  Created by GUO PENG on 2022/4/21.
//  Copyright © 2022 AnyThink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZYGCDTimer.h>
#import "SDMDemoBanner.h"
#import "SDMDemoInterstitial.h"
#import "SDMDemoNative.h"
#import "SDMDemoReward.h"
#import "SDMDemoSplash.h"
#import <SmartdigimktSDK/SDMBannerView.h>
#import <SmartdigimktSDK/SDMInterstitialAd.h>
#import <SmartdigimktSDK/SDMNativeAd.h>
#import <SmartdigimktSDK/SDMRewardedVideoAd.h>
#import <SmartdigimktSDK/SDMSplashAd.h>

NS_ASSUME_NONNULL_BEGIN

@class SDMBannerView, SDMInterstitialAd, SDMNative, SDMRewardedVideoAd, SDMSplashAd, SDMNativeAd;

@interface SDMPerformanceViewController : UIViewController

@property (nonatomic, strong) SDMBannerView *bannerAd;
@property (nonatomic, strong) SDMInterstitialAd *interAd;
@property (nonatomic, strong) SDMNative *nativeOperate;
@property (nonatomic, strong) SDMNativeAd *nativeAd;
@property (nonatomic, strong) SDMRewardedVideoAd *rewardAd;
@property (nonatomic, strong) SDMSplashAd *splashAd;

@property(nonatomic, strong) ZYGCDTimer *checkLoadStatusTimer;

@property(nonatomic, strong) SDMDemoBanner *bannerProxy;
@property(nonatomic, strong) SDMDemoInterstitial *interstitialProxy;
@property(nonatomic, strong) SDMDemoNative *nativeProxy;
@property(nonatomic, strong) SDMDemoReward *rewardProxy;
@property(nonatomic, strong) SDMDemoSplash *splashProxy;

@property (nonatomic, strong, nullable) UIView *renderMulView;

@property(nonatomic, copy) NSString *splashPid;
@property(nonatomic, copy) NSString *bannerPid;
@property(nonatomic, copy) NSString *nativePid;
@property(nonatomic, copy) NSString *interstitialPid;
@property(nonatomic, copy) NSString *rewardVideoPid;
@property(nonatomic, assign) BOOL isSplashShow;

@property (nonatomic, assign) BOOL isNormalFullFormatShow;

@property (nonatomic, assign) NSInteger flag;

@property (nonatomic, strong, nullable) UIView *bannerAdView;

@property(nonatomic, assign) CGSize bannerAdSize;
@property(nonatomic, assign) CGSize nativeAdSize;
@property(nonatomic, assign) BOOL timeOn;
@property (nonatomic, assign) BOOL isAutoShow;

- (UIInterfaceOrientation)currentInterfaceOrientation;
- (void)CallPolice:(NSDate*)lastDate;
- (NSString *)getRandomID:(NSArray *)idArray placementID:(NSString *)placementID;

@end

NS_ASSUME_NONNULL_END
