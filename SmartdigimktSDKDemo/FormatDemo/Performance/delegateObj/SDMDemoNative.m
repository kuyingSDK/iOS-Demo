//
//  SDMDemoNative.m
//  SmartdigimktSDKDemo
//
//  Created by xuejingwei on 2025/8/26.
//

#import "SDMDemoNative.h"

@implementation SDMDemoNative
- (void)onAdLoaded:(SDMNativeAd *)nativeAd {
    if ([self.delegate respondsToSelector:@selector(nativeOnAdLoaded:)]) {
        [self.delegate nativeOnAdLoaded:nativeAd];
    }
}

- (void)onAdLoadFail:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(nativeOnAdLoadFail:)]) {
        [self.delegate nativeOnAdLoadFail:error];
    }
}
/// Native ads displayed successfully
- (void)onAdShow:(SDMNativeAd *)item {
    if ([self.delegate respondsToSelector:@selector(nativeOnAdShow:)]) {
        [self.delegate nativeOnAdShow:item];
    }
}

/// Native ad click
- (void)onAdClick:(SDMNativeAd *)item extra:(nullable NSDictionary *)extra {
    if ([self.delegate respondsToSelector:@selector(nativeOnAdClick:)]) {
        [self.delegate nativeOnAdClick:item];
    }
}

/// Native ad close button cliecked
- (void)onAdClosed:(SDMNativeAd *)item extra:(nullable NSDictionary *)extra {
    if ([self.delegate respondsToSelector:@selector(nativeOnAdClosed:)]) {
        [self.delegate nativeOnAdClosed:item];
    }
}

/// Whether the click jump of Native ads is in the form of Deeplink
- (void)onDeeplinkCallback:(SDMNativeAd *)item
                    result:(BOOL)success {
    if ([self.delegate respondsToSelector:@selector(nativeOnDeeplinkCallback:result:)]) {
        [self.delegate nativeOnDeeplinkCallback:item result:success];
    }
}

@end
