//
//  InterstitialVC.m
//  iOSDemo
//
//  Created by ltz on 2025/1/6.
//

#import "InterstitialVC.h"

#import <SmartdigimktSDK/SmartdigimktSDK.h>
  
@interface InterstitialVC () <SDMPublicLoadingDelegate, SDMPubInterstitialDelegate>

@property (nonatomic, assign) NSInteger retryAttempt; // 重试次数计数器

@property (nonatomic, strong) SDMInterstitialAd * interstitialAd;

@end

@implementation InterstitialVC
 
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadAd];
}

#pragma mark - Load Ad
- (void)loadAd {
 
    self.interstitialAd = [[SDMInterstitialAd alloc] initAdWithPlacementId:InterstitialPlacementID];
    
    self.interstitialAd.loadDelegate = self;
    self.interstitialAd.showDelegate = self;
    
    //设置额外参数字典对象，可选接入
//    self.interstitialAd.extra = xxx
    
    [self.interstitialAd load];
}
 
#pragma mark - Show Ad
- (void)showAd {
    if ( [self.interstitialAd isReady] ) {
        self.interstitialAd.showViewController = self;
        [self.interstitialAd showAd];
    }
}
 
#pragma mark - SDMPublicLoadingDelegate
/// Callback when the successful loading of the ad
- (void)onAdLoaded:(SDMBaseAd *)item {
    
    [self showLog:[NSString stringWithFormat:@"onAdLoaded:%@", item.placementId]];
     
    // Reset retry attempt
    self.retryAttempt = 0;
    
    // 获取价格
//    SDMAd *ad = [item getSDMAd];
//    double ecpm = [ad.ecpmInfo currentEcpm:SDMAdCurrencyTypeCNY];
//    double ecpmUSD = [ad.ecpmInfo currentEcpm:SDMAdCurrencyTypeUSD];
    
    //发起竞胜
//    SDMWinInfo *winInfo = [[SDMWinInfo alloc] init];
//    winInfo.networkName = @"TopOn";
//    winInfo.secondPrice = xxx;
//    winInfo.extraInfo = @{
//        @"m_platform": @1,
//        @"nw" : @"TopOn",
//        @"price" : @0.0001,
//        @"m_wf":  @[@{
//            @"nw": @"TopOn",
//            @"price": @2,
//            @"is_bid": @NO,
//        },@{
//            @"nw": @"TopOn",
//            @"price": @0.0001,
//            @"is_bid": @NO,
//        }],
//    };
//    winInfo.currencyType = SDMAdCurrencyTypeUSD;
//    [self.interstitialAd notifyWin:winInfo];
    
    //发起竞败
//    SDMLossInfo *lossInfo = [[SDMLossInfo alloc] init];
//    lossInfo.networkName = @"TopOn";
//    lossInfo.winPrice = xxx;
//    lossInfo.reason = SDMLossReasonxxx;
//    lossInfo.extraInfo = @{
//        @"m_platform": @1,
//        @"nw" : @"TopOn",
//        @"price" : @0.0001,
//        @"m_wf":  @[@{
//            @"nw": @"TopOn",
//            @"price": @2,
//            @"is_bid": @NO,
//        },@{
//            @"nw": @"TopOn",
//            @"price": @0.0001,
//            @"is_bid": @NO,
//        }],
//    };
//    lossInfo.currencyType = SDMAdCurrencyTypeUSD;
//    [self.interstitialAd notifyLoss:lossInfo];
}

/// Callback of ad loading failure
- (void)onAdLoadFail:(SDMBaseAd *)item
               error:(NSError *)error {
    [self showLog:[NSString stringWithFormat:@"onAdLoadFail:%@ error:%ld msg:%@", item.placementId, error.code,[NSString stringWithFormat:@"%@ %@",error.description,error.userInfo]]];
    
    self.retryAttempt++;
    NSInteger delaySec = pow(2, MIN(6, self.retryAttempt));
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delaySec * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self loadAd];
    });
}

#pragma mark - SDMPubInterstitialDelegate
- (void)onAdShow:(SDMInterstitialAd *)item {
    //获得了展示收益
    SDMAd *ad = [item getSDMAd];
    double ecpmCNY = [ad.ecpmInfo currentEcpm:SDMAdCurrencyTypeCNY];
    double revenCNY = [ad.ecpmInfo currentRevenueEcpm:SDMAdCurrencyTypeCNY];
    double ecpmUSD = [ad.ecpmInfo currentEcpm:SDMAdCurrencyTypeUSD];
    double revenUSD = [ad.ecpmInfo currentRevenueEcpm:SDMAdCurrencyTypeUSD];
    
    [self showLog:[NSString stringWithFormat:@"onAdShow\nplacementId: %@\neCPM(CNY): ¥%.4f\nRevenue(CNY): ¥%.4f\neCPM(USD): $%.4f\nRevenue(USD): $%.4f",
                   item.placementId,
                   ecpmCNY,
                   revenCNY,
                   ecpmUSD,
                   revenUSD]];
}

/// Ad click
- (void)onAdClick:(SDMRewardedVideoAd *)item extra:(nullable NSDictionary *)extra {
    [self showLog:[NSString stringWithFormat:@"onAdClick:%@ extra:%@",item.placementId,extra]];
}

/// Ad closed
- (void)onAdClose:(SDMInterstitialAd *)item extra:(nullable NSDictionary *)extra {
    [self showLog:[NSString stringWithFormat:@"onAdClose:%@ extra:%@",item.placementId,extra]];
    
    [self loadAd];
}

/// @optional
/// Interstitial ad display failed
- (void)onAdShowFail:(SDMInterstitialAd *)item
               error:(NSError *)error {
    [self showLog:[NSString stringWithFormat:@"onAdShowFail:%@ error:%@ ",item.placementId,error]];
    
    [self loadAd];
}

/// @optional
/// Interstitial video ad playback start
- (void)onAdVideoStart:(SDMInterstitialAd *)item {
    [self showLog:[NSString stringWithFormat:@"onAdVideoStart:%@", item.placementId]];
}

/// @optional
/// Interstitial playback end
- (void)onAdVideoEnd:(SDMInterstitialAd *)item {
    [self showLog:[NSString stringWithFormat:@"onAdVideoEnd:%@", item.placementId]];
}

/// Whether the click jump on the interstitial advertisement is in the form of Deeplink
- (void)onDeeplinkCallback:(SDMInterstitialAd *)item
                    result:(BOOL)success {
    [self showLog:[NSString stringWithFormat:@"onDeeplinkCallback:%@ result:%d ", item.placementId,success]];
}

@end
