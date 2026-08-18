//
//  IconAd.h
//  Icon Ad — native self-render wrapper
//
//  Looks like a new ad format; internally native self-render.
//  Copy this folder (iconad/IconAd/) to use IconAd.
//
//  IconAd.load(placementId, callback) -> setListener -> show -> destroy
//

#import <UIKit/UIKit.h>
#import "IconAdConfig.h"
#import "IconAdLoadCallback.h"
#import "IconAdListener.h"

NS_ASSUME_NONNULL_BEGIN

@interface IconAd : NSObject

/// Written into native extra at load. Value is @"icon".
@property (class, nonatomic, readonly) NSString *SCENARIO;

@property (nonatomic, copy, readonly) NSString *placementId;

+ (void)load:(nullable id)context
 placementId:(NSString *)placementId
    callback:(id<IconAdLoadCallback>)callback;

- (void)show:(UIViewController *)viewController;
- (void)show:(UIViewController *)viewController container:(UIView *)container;
- (void)show:(UIViewController *)viewController config:(IconAdConfig *)config;
- (void)show:(UIViewController *)viewController
   container:(nullable UIView *)container
      config:(nullable IconAdConfig *)config;

- (BOOL)isReady;
- (NSString *)getPlacementId;
- (void)setListener:(nullable id<IconAdListener>)listener;

/// Forwarded to native video pause/resume.
- (void)onResume;
- (void)onPause;

- (void)destroy;

@end

NS_ASSUME_NONNULL_END
