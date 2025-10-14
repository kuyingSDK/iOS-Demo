//
//  SDMDemoReward.h
//  SmartdigimktSDKDemo
//
//  Created by xuejingwei on 2025/8/26.
//

#import <Foundation/Foundation.h>
#import <SmartdigimktSDK/SDMPubRewardedVideoDelegate.h>
#import <SmartdigimktSDK/SDMPublicLoadingDelegate.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SDMDemoRewardDelegate <NSObject>


- (void)rewardOnAdLoad:(SDMRewardedVideoAd *)item;

- (void)rewardOnAdLoadFail:(SDMRewardedVideoAd *)item;

- (void)rewardOnAdPlayStart:(SDMRewardedVideoAd *)item;

/// Rewarded video ad play ends
- (void)rewardOnAdPlayEnd:(SDMRewardedVideoAd *)item;

/// Rewarded video ad clicks
- (void)rewardOnAdClick:(SDMRewardedVideoAd *)item;

/// Rewarded video ad closed
- (void)rewardOnAdClose:(SDMRewardedVideoAd *)item
         rewarded:(BOOL)rewarded;

/// Rewarded video ad reward distribution
- (void)rewardOnAdReward:(SDMRewardedVideoAd *)item;

/// Rewarded video ad play failed
- (void)rewardOnAdPlayFailed:(SDMRewardedVideoAd *)item
                 error:(NSError *)error;

/// Whether the click jump of rewarded video ad is in the form of Deeplink
- (void)rewardOnDeeplinkCallback:(SDMRewardedVideoAd *)item
                    result:(BOOL)success;

@end

@interface SDMDemoReward : NSObject <SDMPubRewardedVideoDelegate, SDMPublicLoadingDelegate>

@property (nonatomic, weak) id<SDMDemoRewardDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
