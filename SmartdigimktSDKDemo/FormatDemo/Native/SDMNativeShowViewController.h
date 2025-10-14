//
//  SDMNativeShowViewController.h
//  AnyThingSDKDemo
//
//  Created by mac on 2021/12/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SDMNativeAd;

@interface SDMNativeShowViewController : UIViewController

- (instancetype)initWithAdView:(UIView *)adView nativeAd:(SDMNativeAd *)nativeAd;

@end

NS_ASSUME_NONNULL_END
