//
//  IconView.m
//  Icon Ad — native self-render wrapper
//

#import "IconView.h"
#import <math.h>

static const CGFloat kIconAdClosePad = 6.0;
static const CGFloat kIconAdCloseSize = 22.0;
static const CGFloat kIconAdCornerRadius = 12.0;

static unsigned char *IconAdCopyRGBA(UIImage *image, size_t *outW, size_t *outH) {
    CGImageRef cgImage = image.CGImage;
    if (cgImage == NULL) {
        return NULL;
    }
    size_t width = CGImageGetWidth(cgImage);
    size_t height = CGImageGetHeight(cgImage);
    if (width < 8 || height < 8) {
        return NULL;
    }
    size_t bytesPerRow = width * 4;
    unsigned char *buffer = calloc(height * bytesPerRow, 1);
    if (buffer == NULL) {
        return NULL;
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(buffer, width, height, 8, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        free(buffer);
        return NULL;
    }
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);
    CGContextRelease(context);
    *outW = width;
    *outH = height;
    return buffer;
}

/// Transparent outside the inscribed circle, mostly opaque inside → circular icon.
static BOOL IconAdLooksCircular(unsigned char *buffer, size_t width, size_t height) {
    CGFloat cx = (width - 1) * 0.5;
    CGFloat cy = (height - 1) * 0.5;
    CGFloat radius = MIN(width, height) * 0.5;
    CGFloat innerR = radius * 0.72;
    CGFloat outerR = radius * 0.98;
    NSInteger inside = 0;
    NSInteger insideOpaque = 0;
    NSInteger outside = 0;
    NSInteger outsideClear = 0;
    for (size_t y = 0; y < height; y++) {
        for (size_t x = 0; x < width; x++) {
            unsigned char alpha = buffer[(y * width + x) * 4 + 3];
            CGFloat dx = (CGFloat)x - cx;
            CGFloat dy = (CGFloat)y - cy;
            CGFloat dist = sqrt(dx * dx + dy * dy);
            if (dist <= innerR) {
                inside++;
                if (alpha > 40) {
                    insideOpaque++;
                }
            } else if (dist >= outerR) {
                outside++;
                if (alpha < 20) {
                    outsideClear++;
                }
            }
        }
    }
    if (inside < 20 || outside < 20) {
        return NO;
    }
    return (insideOpaque / (CGFloat)inside) > 0.55 && (outsideClear / (CGFloat)outside) > 0.80;
}

static CGRect IconAdOpaqueBounds(unsigned char *buffer, size_t width, size_t height) {
    size_t minX = width;
    size_t minY = height;
    size_t maxX = 0;
    size_t maxY = 0;
    BOOL found = NO;
    for (size_t y = 0; y < height; y++) {
        for (size_t x = 0; x < width; x++) {
            if (buffer[(y * width + x) * 4 + 3] > 40) {
                found = YES;
                minX = MIN(minX, x);
                minY = MIN(minY, y);
                maxX = MAX(maxX, x);
                maxY = MAX(maxY, y);
            }
        }
    }
    if (!found) {
        return CGRectMake(0, 0, width, height);
    }
    return CGRectMake(minX, minY, maxX - minX + 1, maxY - minY + 1);
}

/// Zoom circular content so it fills the square, then clip to rounded square.
static UIImage *IconAdRoundedSquareFromCircular(UIImage *image, unsigned char *buffer, size_t width, size_t height) {
    CGRect opaquePx = IconAdOpaqueBounds(buffer, width, height);
    CGFloat diameter = MAX(opaquePx.size.width, opaquePx.size.height);
    if (diameter < 8) {
        return image;
    }
    CGFloat imageScale = image.scale > 0 ? image.scale : 1;
    CGSize size = image.size;
    CGPoint contentCenter = CGPointMake(CGRectGetMidX(opaquePx) / imageScale, CGRectGetMidY(opaquePx) / imageScale);
    CGFloat zoom = (MAX(size.width, size.height) * (CGFloat)sqrt(2.0)) / (diameter / imageScale);
    CGRect drawRect = CGRectMake(size.width / 2.0 - contentCenter.x * zoom,
                                 size.height / 2.0 - contentCenter.y * zoom,
                                 size.width * zoom,
                                 size.height * zoom);
    CGFloat corner = kIconAdCornerRadius * (MIN(size.width, size.height) / 64.0);
    UIGraphicsBeginImageContextWithOptions(size, NO, image.scale);
    [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:corner] addClip];
    [image drawInRect:drawRect];
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return output ?: image;
}

static UIImage *IconAdFitCircularIntoRoundedSquareIfNeeded(UIImage *image) {
    size_t width = 0;
    size_t height = 0;
    unsigned char *buffer = IconAdCopyRGBA(image, &width, &height);
    if (buffer == NULL) {
        return image;
    }
    UIImage *result = image;
    if (IconAdLooksCircular(buffer, width, height)) {
        result = IconAdRoundedSquareFromCircular(image, buffer, width, height);
    }
    free(buffer);
    return result;
}

@interface IconView () <UIGestureRecognizerDelegate>
@property (nonatomic, strong, readwrite) UIImageView *iconImageView;
@property (nonatomic, strong, readwrite) UIView *adContainer;
@property (nonatomic, strong, readwrite) UIView *closeView;
@property (nonatomic, assign) BOOL round;
@property (nonatomic, assign) BOOL draggable;
@property (nonatomic, assign) CGFloat iconSize;
@property (nonatomic, assign) BOOL released;
@property (nonatomic, strong) NSURLSessionDataTask *imageTask;
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@end

@implementation IconView

- (instancetype)initWithConfig:(IconAdConfig *)config {
    CGFloat iconSize = [self.class pointsFromDp:config.sizeDp];
    CGRect frame = CGRectMake(0, 0, iconSize + kIconAdClosePad, iconSize + kIconAdClosePad);
    if (self = [super initWithFrame:frame]) {
        _round = (config.shape == IconAdShapeROUND);
        _draggable = (config.displayMode == IconAdDisplayModeFLOAT);
        _iconSize = iconSize;
        self.clipsToBounds = NO;
        self.backgroundColor = [UIColor clearColor];
        [self buildSubviews];
        if (_draggable) {
            _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
            _pan.delegate = self;
            [self addGestureRecognizer:_pan];
        }
    }
    return self;
}

- (void)buildSubviews {
    _adContainer = [[UIView alloc] initWithFrame:CGRectMake(0, kIconAdClosePad, _iconSize, _iconSize)];
    _adContainer.backgroundColor = [UIColor clearColor];
    _adContainer.clipsToBounds = YES;
    [self addSubview:_adContainer];

    _iconImageView = [[UIImageView alloc] initWithFrame:_adContainer.bounds];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    _iconImageView.clipsToBounds = YES;
    _iconImageView.userInteractionEnabled = YES;
    _iconImageView.backgroundColor = [UIColor clearColor];
    [_adContainer addSubview:_iconImageView];
    [self applyShape:_iconImageView];
    [self applyShape:_adContainer];

    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    close.frame = CGRectMake(CGRectGetWidth(self.bounds) - kIconAdCloseSize, 0, kIconAdCloseSize, kIconAdCloseSize);
    [close setTitle:@"×" forState:UIControlStateNormal];
    [close setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    close.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
    close.backgroundColor = [[UIColor colorWithWhite:0.2 alpha:1] colorWithAlphaComponent:0.8];
    close.layer.cornerRadius = kIconAdCloseSize / 2.0;
    close.clipsToBounds = YES;
    [close addTarget:self action:@selector(onCloseTap) forControlEvents:UIControlEventTouchUpInside];
    _closeView = close;
    [self addSubview:_closeView];
}

- (void)attachToHost:(UIView *)host config:(IconAdConfig *)config {
    [self removeFromSuperview];
    CGFloat w = CGRectGetWidth(self.bounds);
    CGFloat h = CGRectGetHeight(self.bounds);
    if (config.displayMode == IconAdDisplayModeFLOAT) {
        CGFloat x = MAX(0, CGRectGetWidth(host.bounds) - w - [self.class pointsFromDp:12]);
        CGFloat y = MAX(0, CGRectGetHeight(host.bounds) - h - [self.class pointsFromDp:80]);
        self.frame = CGRectMake(x, y, w, h);
        [host addSubview:self];
    } else {
        [host addSubview:self];
        self.center = CGPointMake(CGRectGetMidX(host.bounds), CGRectGetMidY(host.bounds));
    }
    [host bringSubviewToFront:self];
    [self bringSubviewToFront:_closeView];
}

- (void)bindImageURL:(NSString *)url placeholder:(NSString *)placeholder {
    if (url.length == 0) {
        self.iconImageView.image = nil;
        return;
    }
    [self.imageTask cancel];
    NSURL *imageURL = [NSURL URLWithString:url];
    if (!imageURL) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    BOOL roundedSquare = !self.round;
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:imageURL
                                                             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        UIImage *image = data ? [UIImage imageWithData:data] : nil;
        if (image && roundedSquare) {
            image = IconAdFitCircularIntoRoundedSquareIfNeeded(image);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) self = weakSelf;
            if (!self || self.released) {
                return;
            }
            if (image) {
                self.iconImageView.image = image;
                [self applyShape:self.iconImageView];
            } else {
                self.iconImageView.image = nil;
            }
            (void)placeholder;
        });
    }];
    self.imageTask = task;
    [task resume];
}

- (void)releaseView {
    self.released = YES;
    self.closeCallback = nil;
    [self.imageTask cancel];
    self.imageTask = nil;
    [self.iconImageView removeFromSuperview];
    self.iconImageView.image = nil;
    [self removeFromSuperview];
}

- (void)onCloseTap {
    if (self.closeCallback) {
        self.closeCallback();
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)pan {
    UIView *parent = self.superview;
    if (!parent) {
        return;
    }
    CGPoint translation = [pan translationInView:parent];
    CGPoint center = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
    CGFloat halfW = CGRectGetWidth(self.bounds) / 2.0;
    CGFloat halfH = CGRectGetHeight(self.bounds) / 2.0;
    center.x = MIN(MAX(halfW, center.x), CGRectGetWidth(parent.bounds) - halfW);
    center.y = MIN(MAX(halfH, center.y), CGRectGetHeight(parent.bounds) - halfH);
    self.center = center;
    [pan setTranslation:CGPointZero inView:parent];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view == self.closeView || [touch.view isDescendantOfView:self.closeView]) {
        return NO;
    }
    return YES;
}

- (void)applyShape:(UIView *)target {
    target.layer.masksToBounds = YES;
    if (self.round) {
        target.layer.cornerRadius = self.iconSize / 2.0;
    } else {
        target.layer.cornerRadius = [self.class pointsFromDp:kIconAdCornerRadius];
    }
}

+ (CGFloat)pointsFromDp:(CGFloat)dp {
    return dp;
}

@end
