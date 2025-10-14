//
//  SDMDemoSplash.h
//  SmartdigimktSDKDemo
//
//  Created by xuejingwei on 2025/8/26.
//

#import <Foundation/Foundation.h>
#import <SmartdigimktSDK/SDMPubSplashDelegate.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SDMDemoSplashDelegate <NSObject>

/// Splash ad displayed successfully
- (void)splashOnAdShow:(SDMSplashAd *)item;

/// Splash ad click
- (void)splashOnAdClick:(SDMSplashAd *)item;

/// Splash ad closed
- (void)splashOnAdClose:(SDMSplashAd *)item;


///  Whether the click jump of Splash ad is in the form of Deeplink
- (void)splashOnDeeplinkCallback:(SDMSplashAd *)item
                    result:(BOOL)success;

- (void)splashOnAdShowFail:(SDMSplashAd *)item
               error:(NSError *)error;

- (void)splashOnAdLoad:(SDMSplashAd *)item;

- (void)splashOnAdLoadFail:(SDMSplashAd *)item;

@end

@interface SDMDemoSplash : NSObject <SDMPubSplashDelegate, SDMPubSplashLoadingDelegate>

@property (nonatomic, weak) id<SDMDemoSplashDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
