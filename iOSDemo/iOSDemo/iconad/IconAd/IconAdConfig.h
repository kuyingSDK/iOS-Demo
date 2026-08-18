//
//  IconAdConfig.h
//  Icon Ad — native self-render wrapper
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class IconAdConfigBuilder;

/// FLOAT: overlay, draggable. ANCHOR: fixed in a container.
typedef NS_ENUM(NSInteger, IconAdDisplayMode) {
    IconAdDisplayModeFLOAT = 0,
    IconAdDisplayModeANCHOR
};

/// ROUND: circle. ROUNDED_SQUARE: rounded rect.
typedef NS_ENUM(NSInteger, IconAdShape) {
    IconAdShapeROUND = 0,
    IconAdShapeROUNDED_SQUARE
};

@interface IconAdConfig : NSObject

@property (nonatomic, assign, readonly) IconAdDisplayMode displayMode;
@property (nonatomic, assign, readonly) IconAdShape shape;
@property (nonatomic, assign, readonly) NSInteger sizeDp;

+ (instancetype)defaults;
+ (IconAdConfigBuilder *)builder;

@end

@interface IconAdConfigBuilder : NSObject

- (IconAdConfigBuilder *)displayMode:(IconAdDisplayMode)displayMode;
- (IconAdConfigBuilder *)shape:(IconAdShape)shape;
- (IconAdConfigBuilder *)size:(NSInteger)sizeDp;
- (IconAdConfig *)build;

@end

NS_ASSUME_NONNULL_END
