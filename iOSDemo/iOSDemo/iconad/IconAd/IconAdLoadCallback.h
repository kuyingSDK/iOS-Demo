//
//  IconAdLoadCallback.h
//  Icon Ad — native self-render wrapper
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class IconAd;

@protocol IconAdLoadCallback <NSObject>

- (void)onLoaded:(IconAd *)ad;

- (void)onFailed:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
