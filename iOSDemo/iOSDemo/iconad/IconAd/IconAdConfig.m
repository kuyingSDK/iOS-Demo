//
//  IconAdConfig.m
//  Icon Ad — native self-render wrapper
//

#import "IconAdConfig.h"

@interface IconAdConfig ()
@property (nonatomic, assign, readwrite) IconAdDisplayMode displayMode;
@property (nonatomic, assign, readwrite) IconAdShape shape;
@property (nonatomic, assign, readwrite) NSInteger sizeDp;
@end

@implementation IconAdConfig

+ (instancetype)defaults {
    return [[self builder] build];
}

+ (IconAdConfigBuilder *)builder {
    return [[IconAdConfigBuilder alloc] init];
}

@end

@interface IconAdConfigBuilder ()
@property (nonatomic, assign) IconAdDisplayMode displayMode;
@property (nonatomic, assign) IconAdShape shape;
@property (nonatomic, assign) NSInteger sizeDp;
@end

@implementation IconAdConfigBuilder

- (instancetype)init {
    if (self = [super init]) {
        _displayMode = IconAdDisplayModeFLOAT;
        _shape = IconAdShapeROUND;
        _sizeDp = 64;
    }
    return self;
}

- (IconAdConfigBuilder *)displayMode:(IconAdDisplayMode)displayMode {
    _displayMode = displayMode;
    return self;
}

- (IconAdConfigBuilder *)shape:(IconAdShape)shape {
    _shape = shape;
    return self;
}

- (IconAdConfigBuilder *)size:(NSInteger)sizeDp {
    _sizeDp = sizeDp;
    return self;
}

- (IconAdConfig *)build {
    IconAdConfig *config = [[IconAdConfig alloc] init];
    config.displayMode = _displayMode;
    config.shape = _shape;
    config.sizeDp = _sizeDp < 40 ? 40 : MIN(_sizeDp, 120);
    return config;
}

@end
