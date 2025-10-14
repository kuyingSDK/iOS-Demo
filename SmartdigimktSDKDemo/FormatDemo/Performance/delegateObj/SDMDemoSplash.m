//
//  SDMDemoSplash.m
//  SmartdigimktSDKDemo
//
//  Created by xuejingwei on 2025/8/26.
//

#import "SDMDemoSplash.h"

@implementation SDMDemoSplash

/// Splash ad displayed successfully
- (void)onAdShow:(SDMSplashAd *)item {
    if ([self.delegate respondsToSelector:@selector(splashOnAdShow:)]) {
        [self.delegate splashOnAdShow:item];
    }
}

/// Splash ad click
- (void)onAdClick:(SDMSplashAd *)item extra:(nullable NSDictionary *)extra {
    if ([self.delegate respondsToSelector:@selector(splashOnAdClick:)]) {
        [self.delegate splashOnAdClick:item];
    }
}

/// Splash ad closed
- (void)onAdClose:(SDMSplashAd *)item extra:(nullable NSDictionary *)extra {
    if ([self.delegate respondsToSelector:@selector(splashOnAdClose:)]) {
        [self.delegate splashOnAdClose:item];
    }
}

///  Whether the click jump of Splash ad is in the form of Deeplink
- (void)onDeeplinkCallback:(SDMSplashAd *)item
                    result:(BOOL)success {
    if ([self.delegate respondsToSelector:@selector(splashOnDeeplinkCallback:result:)]) {
        [self.delegate splashOnDeeplinkCallback:item result:success];
    }
}

- (void)onAdShowFail:(SDMSplashAd *)item
               error:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(splashOnAdShowFail:error:)]) {
        [self.delegate splashOnAdShowFail:item error:error];
    }
}

/// Callback when the splash ad is loaded successfully
/// @param isTimeout whether timeout
- (void)onAdLoaded:(SDMSplashAd *)item isTimeout:(BOOL)isTimeout {
    if ([self.delegate respondsToSelector:@selector(splashOnAdLoad:)]) {
        [self.delegate splashOnAdLoad:item];
    }
}

/// Splash ad loading timeout callback
- (void)onAdLoadTimeout:(SDMSplashAd *)item {
    
}

/// Callback when the successful loading of the ad
- (void)onAdLoaded:(SDMBaseAd *)item {
    
}

/// Callback of ad loading failure
- (void)onAdLoadFail:(SDMBaseAd *)item
               error:(NSError*)error {
    if ([self.delegate respondsToSelector:@selector(splashOnAdLoadFail:)]) {
        [self.delegate splashOnAdLoadFail:item];
    }
}

@end
