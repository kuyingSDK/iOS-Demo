//
//  SDMDemoBanner.m
//  SmartdigimktSDKDemo
//
//  Created by xuejingwei on 2025/8/26.
//

#import "SDMDemoBanner.h"

@implementation SDMDemoBanner

- (void)onAdLoaded:(SDMBannerView *)bannerView {
    if ([self.delegate respondsToSelector:@selector(bannerOnAdLoaded:)]) {
        [self.delegate bannerOnAdLoaded:bannerView];
    }
}

- (void)onAdLoadFail:(SDMBannerView *)bannerView error:(NSError*)error {
    if ([self.delegate respondsToSelector:@selector(bannerOnAdLoadFail:error:)]) {
        [self.delegate bannerOnAdLoadFail:bannerView error:error];
    }
}

- (void)onAdShow:(SDMBannerView *)bannerView {
    if ([self.delegate respondsToSelector:@selector(bannerOnAdShow:)]) {
        [self.delegate bannerOnAdShow:bannerView];
    }
}

- (void)onAdClick:(SDMBannerView *)bannerView extra:(nullable NSDictionary *)extra {
    if ([self.delegate respondsToSelector:@selector(bannerOnAdClick:)]) {
        [self.delegate bannerOnAdClick:bannerView];
    }
}

- (void)onAdClose:(SDMBannerView *)bannerView extra:(nullable NSDictionary *)extra {
    if ([self.delegate respondsToSelector:@selector(bannerOnAdClick:)]) {
        [self.delegate bannerOnAdClick:bannerView];
    }
}

- (void)onDeeplinkCallback:(nonnull SDMBannerView *)bannerView result:(BOOL)success { 
    
}


@end
