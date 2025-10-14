//
//  SDMDemoBanner.h
//  SmartdigimktSDKDemo
//
//  Created by xuejingwei on 2025/8/26.
//

#import <Foundation/Foundation.h>
#import <SmartdigimktSDK/SDMBannerView.h>

NS_ASSUME_NONNULL_BEGIN
@protocol SDMDemoBannerDelegate <NSObject>

- (void)bannerOnAdLoaded:(SDMBannerView *)bannerView;

- (void)bannerOnAdLoadFail:(SDMBannerView *)bannerView error:(NSError*)error;

- (void)bannerOnAdShow:(SDMBannerView *)bannerView;

- (void)bannerOnAdClick:(SDMBannerView *)bannerView;

- (void)bannerOnAdClose:(SDMBannerView *)bannerView;

@end

@interface SDMDemoBanner : NSObject <SDMBannerViewDelegate>

@property (nonatomic, weak) id<SDMDemoBannerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
