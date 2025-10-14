//
//  SDMDemoNative.h
//  SmartdigimktSDKDemo
//
//  Created by xuejingwei on 2025/8/26.
//

#import <Foundation/Foundation.h>
#import <SmartdigimktSDK/SDMNative.h>
#import <SmartdigimktSDK/SDMPubNativeDelegate.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SDMDemoNativeDelegate <NSObject>

- (void)nativeOnAdLoaded:(SDMNativeAd *)nativeAd;
- (void)nativeOnAdLoadFail:(NSError *)error;
/// Native ads displayed successfully
- (void)nativeOnAdShow:(SDMNativeAd *)item;

/// Native ad click
- (void)nativeOnAdClick:(SDMNativeAd *)item;

/// Native ad close button cliecked
- (void)nativeOnAdClosed:(SDMNativeAd *)item;

/// Whether the click jump of Native ads is in the form of Deeplink
- (void)nativeOnDeeplinkCallback:(SDMNativeAd *)item
                    result:(BOOL)success;

@end

@interface SDMDemoNative : NSObject <SDMNativeLoadDelegate, SDMPubNativeDelegate>

@property (nonatomic, weak) id<SDMDemoNativeDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
