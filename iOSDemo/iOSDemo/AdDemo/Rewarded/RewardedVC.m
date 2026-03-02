//
//  RewardedVC.m
//  iOSDemo
//
//  Created by ltz on 2025/1/7.
//

#import "RewardedVC.h"

#import <SmartdigimktSDK/SmartdigimktSDK.h>

@interface RewardedVC () <SDMPublicLoadingDelegate, SDMPubRewardedVideoDelegate>

@property (nonatomic, assign) NSInteger retryAttempt; // 重试次数计数器

@property (nonatomic, strong) SDMRewardedVideoAd * rewardedAd;

@end

@implementation RewardedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadAd];
}

#pragma mark - Load Ad
- (void)loadAd {
 
    self.rewardedAd = [[SDMRewardedVideoAd alloc] initAdWithPlacementId:RewardedPlacementID];
    
    self.rewardedAd.loadDelegate = self;
    self.rewardedAd.showDelegate = self;
    
    //设置额外参数字典对象，可选接入
//    self.interstitialAd.extra = xxx
    
    [self.rewardedAd load];
}
 
#pragma mark - Show Ad
- (void)showAd {
    if ( [self.rewardedAd isReady] ) {
        self.rewardedAd.showViewController = self;
        [self.rewardedAd showAd];
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
//    [self.rewardedAd notifyWin:winInfo];
    
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
//    [self.rewardedAd notifyLoss:lossInfo];
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

#pragma mark - SDMPubRewardedVideoDelegate
- (void)onAdPlayStart:(SDMRewardedVideoAd *)item {
    //获得了展示收益
    SDMAd *ad = [item getSDMAd];
    double ecpmCNY = [ad.ecpmInfo currentEcpm:SDMAdCurrencyTypeCNY];
    double revenCNY = [ad.ecpmInfo currentRevenueEcpm:SDMAdCurrencyTypeCNY];
    double ecpmUSD = [ad.ecpmInfo currentEcpm:SDMAdCurrencyTypeUSD];
    double revenUSD = [ad.ecpmInfo currentRevenueEcpm:SDMAdCurrencyTypeUSD];
    
    [self showLog:[NSString stringWithFormat:@"onAdPlayStart\nplacementId: %@\neCPM(CNY): ¥%.4f\nRevenue(CNY): ¥%.4f\neCPM(USD): $%.4f\nRevenue(USD): $%.4f",
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

/// ad play ends
- (void)onAdPlayEnd:(SDMRewardedVideoAd *)item {
    [self showLog:[NSString stringWithFormat:@"onAdPlayStart:%@", item.placementId]];
}

/// Rewarded video ad reward distribution
- (void)onAdReward:(SDMRewardedVideoAd *)item {
    [self showLog:[NSString stringWithFormat:@"onAdReward:%@ ",item.placementId]];
}

/// Ad closed
- (void)onAdClose:(SDMRewardedVideoAd *)item
         rewarded:(BOOL)rewarded {
    [self showLog:[NSString stringWithFormat:@"onAdClose:%@ rewarded:%d",item.placementId,rewarded]];
    
    [self loadAd];
}
 
/// @optional
/// Ad display failed
- (void)onAdPlayFailed:(SDMRewardedVideoAd *)item
               error:(NSError *)error {
    [self showLog:[NSString stringWithFormat:@"onAdShowFail:%@ error:%@ ",item.placementId,error]];
    
    [self loadAd];
}
 
/// @optional
/// Whether the click jump on the advertisement is in the form of Deeplink
- (void)onDeeplinkCallback:(SDMRewardedVideoAd *)item
                    result:(BOOL)success {
    [self showLog:[NSString stringWithFormat:@"onDeeplinkCallback:%@ result:%d ", item.placementId,success]];
}

@end
