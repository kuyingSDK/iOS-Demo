//
//  IconAdListener.h
//  Icon Ad — native self-render wrapper
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IconAdListener <NSObject>

/// Impression. One registerAdView maps to one expose.
- (void)onExpose;

- (void)onClick;

/// Close tapped. Ad is already destroyed.
- (void)onClose;

- (void)onShowFailed:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
