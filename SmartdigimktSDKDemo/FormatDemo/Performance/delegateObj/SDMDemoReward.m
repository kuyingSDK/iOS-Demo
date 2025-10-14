//
//  SDMDemoReward.m
//  SmartdigimktSDKDemo
//
//  Created by xuejingwei on 2025/8/26.
//

#import "SDMDemoReward.h"

@implementation SDMDemoReward

#pragma mark - RewardVideo
/// Rewarded video ad play starts
- (void)onAdPlayStart:(SDMRewardedVideoAd *)item {
    if ([self.delegate respondsToSelector:@selector(rewardOnAdPlayStart:)]) {
        [self.delegate rewardOnAdPlayStart:item];
    }
}


/// Rewarded video ad play ends
- (void)onAdPlayEnd:(SDMRewardedVideoAd *)item {
    if ([self.delegate respondsToSelector:@selector(rewardOnAdPlayEnd:)]) {
        [self.delegate rewardOnAdPlayEnd:item];
    }
}

/// Rewarded video ad clicks
- (void)onAdClick:(SDMRewardedVideoAd *)item extra:(nullable NSDictionary *)extra {
    if ([self.delegate respondsToSelector:@selector(rewardOnAdClick:)]) {
        [self.delegate rewardOnAdClick:item];
    }
}

/// Rewarded video ad closed
- (void)onAdClose:(SDMRewardedVideoAd *)item
         rewarded:(BOOL)rewarded {
    if ([self.delegate respondsToSelector:@selector(rewardOnAdClose:rewarded:)]) {
        [self.delegate rewardOnAdClose:item rewarded:rewarded];
    }
}

/// Rewarded video ad reward distribution
- (void)onAdReward:(SDMRewardedVideoAd *)item {
    if ([self.delegate respondsToSelector:@selector(rewardOnAdReward:)]) {
        [self.delegate rewardOnAdReward:item];
    }
}


/// Rewarded video ad play failed
- (void)onAdPlayFailed:(SDMRewardedVideoAd *)item
                 error:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(rewardOnAdPlayFailed:error:)]) {
        [self.delegate rewardOnAdPlayFailed:item error:error];
    }
}

/// Whether the click jump of rewarded video ad is in the form of Deeplink
- (void)onDeeplinkCallback:(SDMRewardedVideoAd *)item
                    result:(BOOL)success {
    if ([self.delegate respondsToSelector:@selector(rewardOnDeeplinkCallback:result:)]) {
        [self.delegate rewardOnDeeplinkCallback:item result:success];
    }
}

- (void)onAdLoadFail:(nonnull SDMBaseAd *)item error:(nonnull NSError *)error { 
    if ([self.delegate respondsToSelector:@selector(rewardOnAdLoadFail:)]) {
        [self.delegate rewardOnAdLoadFail:item];
    }
}

- (void)onAdLoaded:(nonnull SDMBaseAd *)item {
    if ([self.delegate respondsToSelector:@selector(rewardOnAdLoad:)]) {
        [self.delegate rewardOnAdLoad:item];
    }
}

@end
