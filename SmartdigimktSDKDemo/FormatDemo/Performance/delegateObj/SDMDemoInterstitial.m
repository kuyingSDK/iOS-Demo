//
//  SDMDemoInterstitial.m
//  SmartdigimktSDKDemo
//
//  Created by xuejingwei on 2025/8/26.
//

#import "SDMDemoInterstitial.h"

@implementation SDMDemoInterstitial

#pragma mark - InterstitialAd
/// Interstitial ad displayed successfully
- (void)onAdShow:(SDMInterstitialAd *)item {
    if ([self.delegate respondsToSelector:@selector(interstitialOnAdShow:)]) {
        [self.delegate interstitialOnAdShow:item];
    }
}

/// Interstitial ad clicked
- (void)onAdClick:(SDMInterstitialAd *)item extra:(nullable NSDictionary *)extra {
    if ([self.delegate respondsToSelector:@selector(interstitialOnAdClick:)]) {
        [self.delegate interstitialOnAdClick:item];
    }
}

/// Interstitial ad closed
- (void)onAdClose:(SDMInterstitialAd *)item extra:(nullable NSDictionary *)extra {
    if ([self.delegate respondsToSelector:@selector(interstitialOnAdClose:)]) {
        [self.delegate interstitialOnAdClose:item];
    }
}


/// Interstitial ad display failed
- (void)onAdShowFail:(SDMInterstitialAd *)item
               error:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(interstitialOnAdShowFail:error:)]) {
        [self.delegate interstitialOnAdShowFail:item error:error];
    }
}

/// Interstitial video ad playback start
- (void)onAdVideoStart:(SDMInterstitialAd *)item {
    if ([self.delegate respondsToSelector:@selector(interstitialOnAdVideoStart:)]) {
        [self.delegate interstitialOnAdVideoStart:item];
    }
}

/// Interstitial playback end
- (void)onAdVideoEnd:(SDMInterstitialAd *)item {
    if ([self.delegate respondsToSelector:@selector(interstitialOnAdVideoEnd:)]) {
        [self.delegate interstitialOnAdVideoEnd:item];
    }
}

/// Whether the click jump on the interstitial advertisement is in the form of Deeplink
- (void)onDeeplinkCallback:(SDMInterstitialAd *)item
                    result:(BOOL)success {
    if ([self.delegate respondsToSelector:@selector(interstitialOnDeeplinkCallback:result:)]) {
        [self.delegate interstitialOnDeeplinkCallback:item result:success];
    }
}


/// Callback when the successful loading of the ad
- (void)onAdLoaded:(SDMBaseAd *)item {
    if ([self.delegate respondsToSelector:@selector(interstitialOnAdLoaded:)]) {
        [self.delegate interstitialOnAdLoaded:item];
    }
}

/// Callback of ad loading failure
- (void)onAdLoadFail:(SDMBaseAd *)item
               error:(NSError*)error {
    if ([self.delegate respondsToSelector:@selector(interstitialOnAdLoadFail:error:)]) {
        [self.delegate interstitialOnAdLoadFail:item error:error];
    }
}

@end
