//
//  IconView.h
//  Icon Ad — native self-render wrapper
//
//  Close button stays outside the registerAdView container
//  so the SDK does not treat close as an ad click.
//

#import <UIKit/UIKit.h>
#import "IconAdConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface IconView : UIView

@property (nonatomic, strong, readonly) UIImageView *iconImageView;
@property (nonatomic, strong, readonly) UIView *adContainer;
@property (nonatomic, strong, readonly) UIView *closeView;
@property (nonatomic, copy, nullable) void (^closeCallback)(void);

- (instancetype)initWithConfig:(IconAdConfig *)config;

- (void)attachToHost:(UIView *)host config:(IconAdConfig *)config;
- (void)bindImageURL:(nullable NSString *)url placeholder:(nullable NSString *)placeholder;
- (void)releaseView;

@end

NS_ASSUME_NONNULL_END
