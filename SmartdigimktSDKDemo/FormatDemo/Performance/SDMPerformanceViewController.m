//
//  SDMPerformanceViewController.m
//  AnyThinkSDKDemo
//
//  Created by GUO PENG on 2022/4/21.
//  Copyright © 2022 AnyThink. All rights reserved.
//

#import "SDMPerformanceViewController.h"
#import "SDMPerformanceViewController+Timer.h"
#import "SDMPerformanceViewController+LoadShowRemove.h"
#import <SmartdigimktSDK/SDMBaseAd.h>
#import <SmartdigimktSDK/SDMNative.h>
#import <SmartdigimktSDK/SDMNativeAd.h>
#import <SmartdigimktSDK/SDMBannerView.h>
#import <SmartdigimktSDK/SDMInterstitialAd.h>
#import <SmartdigimktSDK/SDMSplashAd.h>
#import <SmartdigimktSDK/SDMRewardedVideoAd.h>
#import <Masonry/Masonry.h>
#import "KKCallStack.h"

void AudioServicesPlaySystemSoundWithVibration(int, id, NSDictionary *);

#define CallPoliceValue 600000

@interface SDMPerformanceViewController () <SDMNativeLoadDelegate, SDMDemoBannerDelegate, SDMDemoInterstitialDelegate, SDMDemoSplashDelegate, SDMDemoRewardDelegate, SDMDemoNativeDelegate, SDMPublicLoadingDelegate>

@property (nonatomic, strong) UIButton *autoShowBtn;
@property (nonatomic, strong) SDMNative *native;

@end

@implementation SDMPerformanceViewController


#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _splashPid = @"b5fa25036683d2";
    _bannerPid = @"b5fa24ff8a7446";
    _nativePid = @"b5fa25023d0767";
    _interstitialPid = @"b5fa25016e80bd";
    _rewardVideoPid = @"b5fa2500639c86";
    
    _native = [[SDMNative alloc] initAdWithPlacementId:_nativePid];
    _native.delegate = self;
    
    [self setConfiguration];
    [self setUI];
    [self launchTimer];
    [self loadAllAd];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.timeOn = YES;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.timeOn = NO;
}

- (void)dealloc{
    NSLog(@"🔥----SDMPerformanceViewController------销毁");
}

#pragma mark - init
- (void)setConfiguration {
    self.bannerAdSize = CGSizeMake(CGRectGetWidth(self.view.bounds), 80.0f);
    self.nativeAdSize = CGSizeMake(CGRectGetWidth(self.view.bounds), 320.0f);
}

- (void)setUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *showAutoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [showAutoBtn setTitle:self.isAutoShow ? @"自动" : @"手动" forState:UIControlStateNormal];
    [showAutoBtn setBackgroundColor:[UIColor grayColor]];
    [showAutoBtn addTarget:self action:@selector(autoShowAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showAutoBtn];
    [showAutoBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-150);
        make.width.mas_equalTo(93);
        make.height.mas_equalTo(34);
        make.centerX.equalTo(self.view);
    }];
    
    UIButton *showSplashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [showSplashBtn setTitle:@"展示开屏" forState:UIControlStateNormal];
    [showSplashBtn setBackgroundColor:[UIColor grayColor]];
    [showSplashBtn addTarget:self action:@selector(showSplash:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showSplashBtn];
    [showSplashBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-100);
        make.width.mas_equalTo(93);
        make.height.mas_equalTo(34);
        make.left.mas_equalTo(20);
    }];
    
    UIButton *showRewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [showRewBtn setTitle:@"展示激励" forState:UIControlStateNormal];
    [showRewBtn setBackgroundColor:[UIColor grayColor]];
    [showRewBtn addTarget:self action:@selector(showRew:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showRewBtn];
    [showRewBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-100);
        make.width.mas_equalTo(93);
        make.height.mas_equalTo(34);
        make.left.mas_equalTo(showSplashBtn.mas_right).offset(20);
    }];
    
    UIButton *showIntBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [showIntBtn setTitle:@"展示插屏" forState:UIControlStateNormal];
    [showIntBtn setBackgroundColor:[UIColor grayColor]];
    [showIntBtn addTarget:self action:@selector(showInt:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showIntBtn];
    [showIntBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-100);
        make.width.mas_equalTo(93);
        make.height.mas_equalTo(34);
        make.left.mas_equalTo(showRewBtn.mas_right).offset(20);
    }];
    
    UIButton *onOfferBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [onOfferBtn setTitle:self.timeOn ? @"ON" : @"OFF" forState:UIControlStateNormal];
    [onOfferBtn setBackgroundColor:[UIColor grayColor]];
    [onOfferBtn addTarget:self action:@selector(timeSwitchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:onOfferBtn];
    [onOfferBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
        make.width.mas_equalTo(93);
        make.height.mas_equalTo(34);
        make.left.mas_equalTo(20);
    }];
    
    UIButton *readyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [readyBtn setTitle:@"ready" forState:UIControlStateNormal];
    [readyBtn setBackgroundColor:[UIColor grayColor]];
    [readyBtn addTarget:self action:@selector(allReadyAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:readyBtn];
    [readyBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
        make.width.mas_equalTo(93);
        make.height.mas_equalTo(34);
        make.left.mas_equalTo(onOfferBtn.mas_right).offset(20);
    }];
    
    UIButton *logBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logBtn setTitle:@"log" forState:UIControlStateNormal];
    [logBtn setBackgroundColor:[UIColor grayColor]];
    [logBtn addTarget:self action:@selector(logALLCallStackAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logBtn];
    [logBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
        make.width.mas_equalTo(93);
        make.height.mas_equalTo(34);
        make.left.mas_equalTo(readyBtn.mas_right).offset(20);
    }];
}

#pragma mark - action

- (void)allReadyAction {
    NSLog(@"🔥--激励:--- isReady:%d", [self.rewardAd isReady]);
    NSLog(@"🔥--开屏:--- isReady:%d", [self.splashAd isReady]);
//    NSLog(@"🔥--原生:--- isReady:%d", [self.nativeAd isReady]);
    NSLog(@"🔥--插屏:--- isReady:%d", [self.interAd isReady]);
//    NSLog(@"🔥--banner:--- isReady:%d", [self.bannerAd isReady]);
}

- (void)timeSwitchAction:(UIButton *)btn {
    self.timeOn = self.timeOn ? NO : YES;
    [btn setTitle:self.timeOn ? @"ON" : @"OFF" forState:UIControlStateNormal];
}

- (void)logALLCallStackAction {
    [KKCallStack callStackWithType:KKCallStackTypeAll];
}

- (void)autoShowAction:(UIButton *)sender {
    self.isAutoShow = !self.isAutoShow;
    [sender setTitle:self.isAutoShow ? @"自动" : @"手动" forState:UIControlStateNormal];
}

- (void)showSplash:(UIButton *)sender {
    [self showSplahAd];
}

- (void)showInt:(UIButton *)sender {
    [self showInterAd];
}

- (void)showRew:(UIButton *)sender {
    [self showRewardAd];
}

#pragma mark - Set
- (void)setTimeOn:(BOOL)timeOn{
    if (timeOn && _timeOn == NO) {
        NSLog(@"🔥定时器启动");
        [self.checkLoadStatusTimer fire];
    }
    
    if (timeOn == NO && _timeOn == YES) {
        NSLog(@"🔥定时器暂停");
        [self.checkLoadStatusTimer pause];
    }

    _timeOn = timeOn;
}


#pragma mark - SDMPubBannerDelegate


/// Whether the bannerView click jump is in the form of Deeplink
- (void)adxBannerDidDeepLinkOrJump:(SDMBaseAd *)item result:(BOOL)success {
    NSLog(@"SDMBannerViewController:: didDeepLinkOrJumpForPlacementID:placementID:%@ with extra: %@, success:%@", item.placementId, item.adSourceExtra, success ? @"YES" : @"NO");
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    [self printSaveLog:fStr placementID:item.placementId];
}

#pragma mark - SDMPubNativeDelegate
/// Native video ad starts playing
- (void)adxDidStartPlayingVideo:(SDMBaseAd *)item {
    NSLog(@"Performance:: didStartPlayingVideoInAdView:%@ extra: %@", item.placementId, item.adSourceExtra);
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    [self printSaveLog:fStr placementID:item.placementId];
}

/// Native video ad ends playing
- (void)adxDidEndPlayingVideo:(SDMBaseAd *)item {
    NSLog(@"Performance:: didEndPlayingVideoInAdView:%@ extra: %@", item.placementId, item.adSourceExtra);
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    [self printSaveLog:fStr placementID:item.placementId];
}

/// Native ads click to close the details page
- (void)adxDidCloseDetail:(SDMBaseAd *)item {
    NSLog(@"Performance:: didCloseDetailInAdView:%@ extra:%@", item.placementId, item.adSourceExtra);
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    [self printSaveLog:fStr placementID:item.placementId];
}

#pragma mark - SDMPubRewardedVideoDelegate


/// Rewarded video ad rewatch ad playback fail
- (void)adxRewardedVideoAgainDidFailToPlay:(SDMBaseAd *)item
                                     error:(NSError *)error {
    NSLog(@"SDMRewardVideoViewController::rewardedVideoAgainDidFailToPlayForPlacementID:%@ extra:%@", item.placementId, item.adSourceExtra);
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    [self printSaveLog:fStr placementID:item.placementId];
}

/// Rewarded video ad rewatch ad playback clicked
- (void)adxRewardedVideoAgainDidClick:(SDMBaseAd *)item {
    NSLog(@"SDMRewardVideoViewController::rewardedVideoAgainDidClickForPlacementID:%@ extra:%@", item.placementId, item.adSourceExtra);
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    [self printSaveLog:fStr placementID:item.placementId];
}

/// Rewarded video ad rewatch ad rewarded distribution
- (void)adxRewardedVideoAgainDidRewardSuccess:(SDMBaseAd *)item {
    NSLog(@"SDMRewardVideoViewController::rewardedVideoAgainDidRewardSuccessForPlacemenID:%@ extra:%@", item.placementId, item.adSourceExtra);
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    [self printSaveLog:fStr placementID:item.placementId];
}

#pragma mark - Loading

- (void)didFinishLoadingADXItem:(SDMBaseAd *)item {
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    [self printSaveLog:fStr placementID:item.placementId];
}

/// Callback of ad loading failure
- (void)didFailToLoadADXItem:(SDMBaseAd *)item
                       error:(NSError*)error {
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    [self printSaveLog:fStr placementID:item.placementId];
}

/// Callback when the successful loading of the ad
- (void)didFinishLoadingADXItem:(SDMBaseAd *)item bannerView:(UIView *)bannerView {
    BOOL ready = [item isReady];
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    [self printSaveLog:fStr placementID:item.placementId];
}


#pragma mark - private

- (void)printSaveLog:(NSString *)messageStr placementID:(NSString *)placementID{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"AT_AnyThinkAdTrack"] = @(3);
    dic[@"action"] = messageStr;
    dic[@"placementID"] = placementID;

    NSString *logString = [NSString stringWithFormat:@"⚽️⚽️%@⚽️", [self jsonString_anythink:dic]];
    NSLog(@"%@",logString);
}

-(NSString*) jsonString_anythink:(NSDictionary *)dic {
    NSError *error;
    NSData *jsonData;
    
    if (![NSJSONSerialization isValidJSONObject:dic]) {
      
        return @"{}";
    }
    
    @try {
        jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                           options:kNilOptions
                                                             error:&error];
    } @catch (NSException *exception) {
        
     
        return @"{}";
    } @finally {}
    
    if (!jsonData) {
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}
- (UIInterfaceOrientation)currentInterfaceOrientation
{
    if (@available(iOS 13.0, *)) {
        UIWindow *firstWindow = [[[UIApplication sharedApplication] windows] firstObject];
        if (firstWindow == nil) { return UIInterfaceOrientationUnknown; }
        
        UIWindowScene *windowScene = firstWindow.windowScene;
        if (windowScene == nil){ return UIInterfaceOrientationUnknown; }
        
        return windowScene.interfaceOrientation;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return UIApplication.sharedApplication.statusBarOrientation;
#pragma clang diagnostic pop
        
    }
}

- (void)CallPolice:(NSDate*)lastDate{
    if (lastDate == nil) {
        return;
    }
    double date = [self getGapDate:lastDate];
    if (date > CallPoliceValue) {

    }
}

- (double)getGapDate:(NSDate *)loadDate{
    double date1 = [loadDate timeIntervalSince1970] * 1000;
    double date2 = [[NSDate date] timeIntervalSince1970] * 1000;
    double date = date2 - date1;
    return date * 0.001;
}

- (SDMDemoBanner *)bannerProxy {
    if (!_bannerProxy) {
        _bannerProxy = [[SDMDemoBanner alloc] init];
        _bannerProxy.delegate = self;
    }
    return _bannerProxy;
}

- (SDMDemoInterstitial *)interstitialProxy {
    if (!_interstitialProxy) {
        _interstitialProxy = [[SDMDemoInterstitial alloc] init];
        _interstitialProxy.delegate = self;
    }
    return _interstitialProxy;
}

- (SDMDemoNative *)nativeProxy {
    if (!_nativeProxy) {
        _nativeProxy = [[SDMDemoNative alloc] init];
        _nativeProxy.delegate = self;
    }
    return _nativeProxy;
}

- (SDMDemoReward *)rewardProxy {
    if (!_rewardProxy) {
        _rewardProxy = [[SDMDemoReward alloc] init];
        _rewardProxy.delegate = self;
    }
    return _rewardProxy;
}

- (SDMDemoSplash *)splashProxy {
    if (!_splashProxy) {
        _splashProxy = [[SDMDemoSplash alloc] init];
        _splashProxy.delegate = self;
    }
    return _splashProxy;
}

#pragma mark - Banner
- (void)bannerOnAdClick:(nonnull SDMBannerView *)bannerView {
    NSLog(@"SDMBannerViewController::bannerView:didClickWithPlacementID:%@ ", bannerView.placementId);
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    [self printSaveLog:fStr placementID:bannerView.placementId];
}

- (void)bannerOnAdClose:(nonnull SDMBannerView *)bannerView { 
    NSLog(@"SDMBannerViewController::bannerView:didTapCloseButtonWithPlacementID:%@ ", bannerView.placementId);
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    [self printSaveLog:fStr placementID:bannerView.placementId];
}

- (void)bannerOnAdLoadFail:(nonnull SDMBannerView *)bannerView error:(nonnull NSError *)error { 
    NSLog(@"Performance::banner fail");
}

- (void)bannerOnAdLoaded:(nonnull SDMBannerView *)bannerView {
    NSLog(@"Performance::bannerDidload");
    [self.bannerAd removeFromSuperview];
    [self.bannerAd destroy];
    
    self.bannerAd = bannerView;
}

- (void)bannerOnAdShow:(nonnull SDMBannerView *)bannerView { 
    NSLog(@"SDMBannerViewController::bannerView:didShowAdWithPlacementID:%@", bannerView.placementId);
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    [self printSaveLog:fStr placementID:bannerView.placementId];
    
    NSLog(@"🔥---横幅展示成功");

    BOOL bannerReady = [bannerView isAdReady];
//    if (bannerReady == NO) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self loadAllBannerAd];
//        });
//    }
}

#pragma mark - Interstitial
/// Callback when the successful loading of the ad
- (void)interstitialOnAdLoaded:(SDMBaseAd *)item {
    NSLog(@"Performance::interstitialDidLoad");
    self.interAd = item;
}

/// Callback of ad loading failure
- (void)interstitialOnAdLoadFail:(SDMBaseAd *)item
                           error:(NSError*)error {
    NSLog(@"Performance::interstitial Fail");
}

- (void)interstitialOnAdClick:(nonnull SDMInterstitialAd *)item {
    NSLog(@"Performance::interstitialDidClickForPlacementID:%@ extra:%@", item.placementId, item.adSourceExtra);
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    [self printSaveLog:fStr placementID:item.placementId];
}

- (void)interstitialOnAdClose:(nonnull SDMInterstitialAd *)item { 
    NSLog(@"Performance::interstitialDidCloseForPlacementID:%@ extra:%@", item.placementId, item.adSourceExtra);
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    [self printSaveLog:fStr placementID:item.placementId];
    self.isNormalFullFormatShow = NO;
}

- (void)interstitialOnAdShow:(nonnull SDMInterstitialAd *)item { 
    NSLog(@"Performance::interstitialDidShowForPlacementID:%@ extra:%@", item.placementId, item.adSourceExtra);
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    [self printSaveLog:fStr placementID:item.placementId];
}

/// Interstitial ad display failed
- (void)interstitialOnAdShowFail:(SDMInterstitialAd *)item
                           error:(NSError *)error {
    NSLog(@"Performance::interstitialFailedToShowForPlacementID:%@ error:%@ extra:%@", item.placementId, error, item.adSourceExtra);
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    [self printSaveLog:fStr placementID:item.placementId];
    self.isNormalFullFormatShow = NO;
}

/// Interstitial video ad playback start
- (void)interstitialOnAdVideoStart:(SDMInterstitialAd *)item {
    NSLog(@"Performance::interstitialDidStartPlayingVideoForPlacementID:%@ extra:%@", item.placementId, item.adSourceExtra);
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    [self printSaveLog:fStr placementID:item.placementId];
}

/// Interstitial playback end
- (void)interstitialOnAdVideoEnd:(SDMInterstitialAd *)item {
    NSLog(@"Performance::interstitialDidEndPlayingVideoForPlacementID:%@ extra:%@", item.placementId, item.adSourceExtra);
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    [self printSaveLog:fStr placementID:item.placementId];
}

/// Whether the click jump on the interstitial advertisement is in the form of Deeplink
- (void)interstitialOnDeeplinkCallback:(SDMInterstitialAd *)item
                    result:(BOOL)success {
    NSLog(@"Performance:: interstitialDeepLinkOrJumpForPlacementID:placementID:%@ with extra: %@, success:%@", item.placementId, item.adSourceExtra, success ? @"YES" : @"NO");
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    [self printSaveLog:fStr placementID:item.placementId];
}

#pragma mark - splash
- (void)splashOnAdLoad:(SDMSplashAd *)item {
    NSLog(@"Performance::splashOnAdLoad");
    self.splashAd = item;
}

- (void)splashOnAdLoadFail:(SDMSplashAd *)item {
    NSLog(@"Performance::splash load fail");
}

- (void)splashOnAdClick:(nonnull SDMSplashAd *)item {
    NSLog(@"开屏Performance::splashDidClickForPlacementID:%@ extra:%@", item.placementId, item.adSourceExtra);
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    [self printSaveLog:fStr placementID:item.placementId];
}

- (void)splashOnAdClose:(nonnull SDMSplashAd *)item { 
    self.isSplashShow = NO;
    NSLog(@"开屏Performance::splashDidCloseForPlacementID:%@ extra:%@", item.placementId, item.adSourceExtra);
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    [self printSaveLog:fStr placementID:item.placementId];
    self.isNormalFullFormatShow = NO;
}

- (void)splashOnAdShow:(nonnull SDMSplashAd *)item { 
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    [self printSaveLog:fStr placementID:item.placementId];
    self.isSplashShow = YES;
        
    BOOL splashReady = [self.splashAd isReady];
    if (splashReady == NO) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadAllSplashAd];
        });
    }
}

- (void)splashOnAdShowFail:(nonnull SDMSplashAd *)item error:(nonnull NSError *)error { 
    NSLog(@"开屏Performance::splashDidShowFailedForPlacementID:%@ error:%@ extra:%@", item.placementId ,error, item.adSourceExtra);
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    [self printSaveLog:fStr placementID:item.placementId];
}

- (void)splashOnDeeplinkCallback:(nonnull SDMSplashAd *)item result:(BOOL)success { 
    NSLog(@"开屏Performance:: splashDeepLinkOrJumpForPlacementID:placementID:%@ with extra: %@, success:%@", item.placementId, item.adSourceExtra, success ? @"YES" : @"NO");
     NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
     [self printSaveLog:fStr placementID:item.placementId];
}

#pragma mark - Reward
- (void)rewardOnAdClick:(nonnull SDMRewardedVideoAd *)item {
    NSLog(@"Performance::rewardedVideoDidClickForPlacementID:%@ extra:%@", item.placementId, item.adSourceExtra);
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    [self printSaveLog:fStr placementID:item.placementId];
}

- (void)rewardOnAdClose:(nonnull SDMRewardedVideoAd *)item rewarded:(BOOL)rewarded { 
    NSLog(@"ATPerformance::rewardedVideoDidCloseForPlacementID:%@, rewarded:%@ extra:%@", item.placementId, rewarded ? @"yes" : @"no", item.adSourceExtra);
    self.isNormalFullFormatShow = NO;
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    [self printSaveLog:fStr placementID:item.placementId];
}

- (void)rewardOnAdPlayEnd:(nonnull SDMRewardedVideoAd *)item { 
    NSLog(@"ATPerformance::rewardedVideoDidEndPlayingForPlacementID:%@ extra:%@", item.placementId, item.adSourceExtra);
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    [self printSaveLog:fStr placementID:item.placementId];
}

- (void)rewardOnAdPlayStart:(nonnull SDMRewardedVideoAd *)item { 
    NSLog(@"ATPerformance::rewardedVideoDidStartPlayingForPlacementID:%@ extra:%@", item.placementId, item.adSourceExtra);
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    [self printSaveLog:fStr placementID:item.placementId];
}

/// Rewarded video ad play failed
- (void)rewardOnAdPlayFailed:(SDMRewardedVideoAd *)item
                 error:(NSError *)error {
    NSLog(@"ATPerformance::rewardedVideoDidFailToPlayForPlacementID:%@ error:%@ extra:%@", item.placementId, error, item.adSourceExtra);
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    [self printSaveLog:fStr placementID:item.placementId];
    self.isNormalFullFormatShow = NO;
}

/// Whether the click jump of rewarded video ad is in the form of Deeplink
- (void)rewardOnDeeplinkCallback:(SDMRewardedVideoAd *)item
                    result:(BOOL)success {
    NSLog(@"ATPerformance:: rewardedVideoDidDeepLinkOrJumpForPlacementID:placementID:%@ with extra: %@, success:%@", item.placementId, item.adSourceExtra, success ? @"YES" : @"NO");
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    [self printSaveLog:fStr placementID:item.placementId];
}

- (void)rewardOnAdReward:(nonnull SDMRewardedVideoAd *)item { 
    NSLog(@"ATPerformance::rewardedVideoDidRewardSuccessForPlacemenID:%@ extra:%@", item.placementId, item.adSourceExtra);
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    [self printSaveLog:fStr placementID:item.placementId];
}

#pragma mark - native
- (void)nativeOnAdClick:(nonnull SDMNativeAd *)item {
    NSLog(@"Performance:: didClickNativeAdInAdView:%@ extra:%@", item.placementId, item.adSourceExtra);
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    [self printSaveLog:fStr placementID:item.placementId];
}

- (void)nativeOnAdClosed:(nonnull SDMNativeAd *)item { 
    NSLog(@"Performance:: didTapCloseButtonInAdView:%@ extra:%@", item.placementId, item.adSourceExtra);
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    [self printSaveLog:fStr placementID:item.placementId];
}

- (void)nativeOnAdLoadFail:(nonnull NSError *)error {
    NSLog(@"Performance::native load fail");
    [self.nativeAd destroy];
}

- (void)nativeOnAdLoaded:(nonnull SDMNativeAd *)nativeAd {
    NSLog(@"Performance::nativedidload");
    [self.nativeAd destroy];
    self.nativeAd = nativeAd;
}

- (void)nativeOnAdShow:(nonnull SDMNativeAd *)item { 
    if (![item isKindOfClass:[SDMNativeAd class]]) {
        return;
    }
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    [self printSaveLog:fStr placementID:item.placementId];
    
    BOOL nativeReady = [item isReady];
    if (nativeReady == NO) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadAllNativeAd];
        });
    }
}

- (void)nativeOnDeeplinkCallback:(nonnull SDMNativeAd *)item result:(BOOL)success { 
    NSLog(@"Performance:: didDeepLinkOrJumpInAdView:placementID:%@ with extra: %@, success:%@", item.placementId, item.adSourceExtra, success ? @"YES" : @"NO");
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    [self printSaveLog:fStr placementID:item.placementId];
}

@end
