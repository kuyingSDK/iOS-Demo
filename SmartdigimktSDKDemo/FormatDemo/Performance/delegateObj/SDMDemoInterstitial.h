//
//  SDMDemoInterstitial.h
//  SmartdigimktSDKDemo
//
//  Created by xuejingwei on 2025/8/26.
//

#import <Foundation/Foundation.h>
#import <SmartdigimktSDK/SDMPubInterstitialDelegate.h>
#import <SmartdigimktSDK/SDMPublicLoadingDelegate.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SDMDemoInterstitialDelegate <NSObject>

/// Callback when the successful loading of the ad
- (void)interstitialOnAdLoaded:(SDMBaseAd *)item;

/// Callback of ad loading failure
- (void)interstitialOnAdLoadFail:(SDMBaseAd *)item
               error:(NSError*)error;

/// Interstitial ad displayed successfully
- (void)interstitialOnAdShow:(SDMInterstitialAd *)item;

/// Interstitial ad clicked
- (void)interstitialOnAdClick:(SDMInterstitialAd *)item;

/// Interstitial ad closed
- (void)interstitialOnAdClose:(SDMInterstitialAd *)item;

/// Interstitial ad display failed
- (void)interstitialOnAdShowFail:(SDMInterstitialAd *)item
               error:(NSError *)error;

/// Interstitial video ad playback start
- (void)interstitialOnAdVideoStart:(SDMInterstitialAd *)item;

/// Interstitial playback end
- (void)interstitialOnAdVideoEnd:(SDMInterstitialAd *)item;

/// Whether the click jump on the interstitial advertisement is in the form of Deeplink
- (void)interstitialOnDeeplinkCallback:(SDMInterstitialAd *)item
                                result:(BOOL)success;
@end

@interface SDMDemoInterstitial : NSObject <SDMPubInterstitialDelegate, SDMPublicLoadingDelegate>

@property (nonatomic, weak) id<SDMDemoInterstitialDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
