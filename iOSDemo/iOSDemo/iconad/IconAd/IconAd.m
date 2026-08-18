//
//  IconAd.m
//  Icon Ad — native self-render wrapper
//

#import "IconAd.h"
#import "IconView.h"
#import <SmartdigimktSDK/SmartdigimktSDK.h>

static NSString * const kIconAdLogTag = @"sdm_c_ads";
static NSString * const kIconAdErrorDomain = @"com.smartdigimkt.ads.icon";

#define IconAdLog(fmt, ...) NSLog(@"[%@] " fmt, kIconAdLogTag, ##__VA_ARGS__)

@interface IconAdPendingShow : NSObject
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, weak) UIView *container;
@property (nonatomic, strong) IconAdConfig *config;
@end

@implementation IconAdPendingShow
@end

@interface IconAd () <SDMNativeLoadDelegate, SDMPubNativeDelegate>
@property (nonatomic, copy, readwrite) NSString *placementId;
@property (nonatomic, strong) SDMNative *sdmNative;
@property (nonatomic, strong) SDMNativeAd *nativeAd;
@property (nonatomic, weak) id<IconAdListener> listener;
@property (nonatomic, strong) IconView *iconView;
@property (nonatomic, weak) id<IconAdLoadCallback> loadCallback;
@property (nonatomic, strong) IconAdPendingShow *pendingShow;
@property (nonatomic, strong) IconAd *retainedSelf;
@property (nonatomic, assign) BOOL destroyed;
@property (nonatomic, assign) BOOL loading;
@property (nonatomic, assign) BOOL registered;
@end

@implementation IconAd

+ (NSString *)SCENARIO {
    return @"icon";
}

+ (NSError *)errorWithCode:(NSString *)code message:(NSString *)message {
    return [NSError errorWithDomain:kIconAdErrorDomain
                               code:0
                           userInfo:@{
                               NSLocalizedDescriptionKey: message ?: @"",
                               @"code": code ?: @""
                           }];
}

+ (void)load:(id)context
 placementId:(NSString *)placementId
    callback:(id<IconAdLoadCallback>)callback {
    (void)context;
    if (callback == nil) {
        return;
    }
    if (placementId.length == 0) {
        [callback onFailed:[self errorWithCode:@"icon_invalid_argument" message:@"context or placementId is empty"]];
        return;
    }
    IconAd *ad = [[IconAd alloc] init];
    ad.placementId = placementId;
    ad.loadCallback = callback;
    ad.retainedSelf = ad;
    [ad requestFill];
}

- (void)show:(UIViewController *)viewController {
    [self show:viewController container:nil config:[IconAdConfig defaults]];
}

- (void)show:(UIViewController *)viewController container:(UIView *)container {
    IconAdConfig *config = [[[IconAdConfig builder] displayMode:IconAdDisplayModeANCHOR] build];
    [self show:viewController container:container config:config];
}

- (void)show:(UIViewController *)viewController config:(IconAdConfig *)config {
    [self show:viewController container:nil config:config];
}

- (void)show:(UIViewController *)viewController
   container:(UIView *)container
      config:(IconAdConfig *)config {
    if (self.destroyed) {
        [self failShow:@"destroyed"];
        return;
    }
    if (viewController == nil) {
        [self failShow:@"invalid activity"];
        return;
    }
    IconAdConfig *used = config ?: [IconAdConfig defaults];
    if (container != nil) {
        used = [[[[[IconAdConfig builder] displayMode:IconAdDisplayModeANCHOR]
                  shape:used.shape]
                 size:used.sizeDp]
                build];
    }
    IconAdPendingShow *pending = [[IconAdPendingShow alloc] init];
    pending.viewController = viewController;
    pending.container = container;
    pending.config = used;
    self.pendingShow = pending;

    if (self.nativeAd != nil && [self.nativeAd isReady] && !self.registered) {
        [self bindPending];
        return;
    }
    [self requestFill];
}

- (BOOL)isReady {
    return !self.destroyed && self.nativeAd != nil && [self.nativeAd isReady] && !self.registered;
}

- (NSString *)getPlacementId {
    return self.placementId;
}

- (void)setListener:(id<IconAdListener>)listener {
    _listener = listener;
}

- (void)onResume {
    [self.nativeAd resumeVideo];
}

- (void)onPause {
    [self.nativeAd pauseVideo];
}

- (void)destroy {
    if (self.destroyed) {
        return;
    }
    self.destroyed = YES;
    self.loading = NO;
    self.loadCallback = nil;
    self.pendingShow = nil;
    [self dropFill];
    [self dropLoader];
    self.listener = nil;
    self.retainedSelf = nil;
}

- (void)dealloc {
    _sdmNative.delegate = nil;
    _nativeAd.showDelegate = nil;
    [_iconView releaseView];
    [_nativeAd destroy];
}

#pragma mark - load

- (void)requestFill {
    if (self.destroyed) {
        return;
    }
    if (self.loading) {
        return;
    }
    [self dropFill];
    self.loading = YES;
    if (self.sdmNative == nil) {
        self.sdmNative = [[SDMNative alloc] initAdWithPlacementId:self.placementId];
        self.sdmNative.delegate = self;
    }
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    SDMAdRequest *request = [[SDMAdRequest alloc] init];
    request.adWidth = (NSInteger)w;
    request.adHeight = (NSInteger)(w * 3.0 / 4.0);
    self.sdmNative.adRequest = request;
    [self.sdmNative load];
    IconAdLog(@"load %@", self.placementId);
}

- (void)onAdLoaded:(SDMNativeAd *)nativeAd {
    [self runOnMain:^{
        [self handleLoaded:nativeAd];
    }];
}

- (void)onAdLoadFail:(NSError *)error {
    [self runOnMain:^{
        [self handleLoadFail:error];
    }];
}

- (void)handleLoaded:(SDMNativeAd *)ad {
    if (self.destroyed) {
        [ad destroy];
        return;
    }
    self.loading = NO;

    BOOL express = (ad.nativeAdOffer.nativeAdRenderType == SDMNativeAdRenderExpress);
    if (ad == nil || express || ![ad isReady]) {
        [ad destroy];
        [self handleLoadFail:[IconAd errorWithCode:@"icon_load_fail" message:@"need a ready native self-render ad"]];
        return;
    }

    self.nativeAd = ad;
    self.registered = NO;
    ad.showDelegate = self;
    [self markScenarioOnAd:ad];

    id<IconAdLoadCallback> cb = self.loadCallback;
    self.loadCallback = nil;
    if (cb) {
        [cb onLoaded:self];
    }
    if (self.pendingShow != nil) {
        [self bindPending];
    }
    self.retainedSelf = nil;
}

- (void)handleLoadFail:(NSError *)error {
    if (self.destroyed) {
        return;
    }
    self.loading = NO;
    id<IconAdLoadCallback> cb = self.loadCallback;
    self.loadCallback = nil;
    NSError *used = error ?: [IconAd errorWithCode:@"icon_load_fail" message:@"load fail"];
    if (cb) {
        [cb onFailed:used];
    }
    if (self.pendingShow != nil) {
        self.pendingShow = nil;
        [self failShow:used.localizedDescription.length ? used.localizedDescription : @"load fail"];
    }
    self.retainedSelf = nil;
}

- (void)markScenarioOnAd:(SDMNativeAd *)ad {
    NSMutableDictionary *extra = [NSMutableDictionary dictionary];
    if ([ad.extra isKindOfClass:[NSDictionary class]]) {
        [extra addEntriesFromDictionary:ad.extra];
    }
    extra[@"extra_scenario"] = IconAd.SCENARIO;
    extra[@"scenario"] = IconAd.SCENARIO;
    ad.extra = extra;
}

#pragma mark - show

- (void)bindPending {
    IconAdPendingShow *req = self.pendingShow;
    self.pendingShow = nil;
    if (req == nil) {
        return;
    }
    UIViewController *vc = req.viewController;
    if (vc == nil || self.destroyed) {
        [self failShow:@"invalid activity"];
        return;
    }
    if (self.nativeAd == nil || ![self.nativeAd isReady]) {
        [self failShow:@"not ready"];
        return;
    }
    UIView *host = (req.config.displayMode == IconAdDisplayModeANCHOR)
        ? req.container
        : vc.view;
    if (host == nil) {
        [self failShow:@"no container"];
        return;
    }
    @try {
        [self dropView];
        [host layoutIfNeeded];
        self.iconView = [[IconView alloc] initWithConfig:req.config];
        __weak typeof(self) weakSelf = self;
        self.iconView.closeCallback = ^{
            [weakSelf close];
        };
        [self.iconView attachToHost:host config:req.config];
        NSString *url = self.nativeAd.nativeAdOffer.iconUrl;
        if (url.length == 0) {
            url = self.nativeAd.nativeAdOffer.imageUrl;
        }
        [self.iconView bindImageURL:url placeholder:self.nativeAd.nativeAdOffer.title];

        SDMNativePrepareInfo *prepareInfo = [SDMNativePrepareInfo loadPrepareInfo:^(SDMNativePrepareInfo *info) {
            info.iconImageView = self.iconView.iconImageView;
            info.dislikeButton = self.iconView.closeView;
        }];
        SDMNativeLayoutParams *layoutParams = [[SDMNativeLayoutParams alloc] init];
        layoutParams.AdFrame = self.iconView.adContainer.bounds;
        layoutParams.rootViewController = vc;
        layoutParams.sizeToFit = YES;
        layoutParams.context = self.nativeAd.extra;

        [self.nativeAd registerAdView:self.iconView.adContainer
                           clickViews:@[self.iconView.iconImageView]
                          prepareInfo:prepareInfo
                          configParam:layoutParams
                            closeView:self.iconView.closeView];
        [self.nativeAd resumeVideo];
        self.registered = YES;
        NSString *mode = (req.config.displayMode == IconAdDisplayModeFLOAT) ? @"FLOAT" : @"ANCHOR";
        NSString *shape = (req.config.shape == IconAdShapeROUND) ? @"ROUND" : @"ROUNDED_SQUARE";
        IconAdLog(@"show %@ %@ %@", self.placementId, mode, shape);
    } @catch (NSException *exception) {
        IconAdLog(@"show failed %@", exception);
        [self dropView];
        [self failShow:exception.reason];
    }
}

- (void)close {
    if (self.destroyed) {
        return;
    }
    id<IconAdListener> l = self.listener;
    [self destroy];
    if ([l respondsToSelector:@selector(onClose)]) {
        [l onClose];
    }
}

- (void)failShow:(NSString *)msg {
    IconAdLog(@"show failed: %@", msg);
    if ([self.listener respondsToSelector:@selector(onShowFailed:)]) {
        [self.listener onShowFailed:[IconAd errorWithCode:@"icon_show_failed" message:msg ?: @""]];
    }
}

- (void)dropFill {
    [self dropView];
    if (self.nativeAd != nil) {
        self.nativeAd.showDelegate = nil;
        [self.nativeAd destroy];
        self.nativeAd = nil;
    }
    self.registered = NO;
}

- (void)dropView {
    [self.iconView releaseView];
    self.iconView = nil;
}

- (void)dropLoader {
    if (self.sdmNative != nil) {
        self.sdmNative.delegate = nil;
        self.sdmNative = nil;
    }
}

- (void)runOnMain:(void (^)(void))block {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

#pragma mark - SDMPubNativeDelegate

- (void)onAdShow:(SDMNativeAd *)item {
    (void)item;
    if ([self.listener respondsToSelector:@selector(onExpose)]) {
        [self.listener onExpose];
    }
}

- (void)onAdClick:(SDMNativeAd *)item extra:(NSDictionary *)extra {
    (void)item;
    (void)extra;
    if ([self.listener respondsToSelector:@selector(onClick)]) {
        [self.listener onClick];
    }
}

- (void)onAdClosed:(SDMNativeAd *)item extra:(NSDictionary *)extra {
    (void)item;
    (void)extra;
    [self close];
}

- (void)onDeeplinkCallback:(SDMNativeAd *)item result:(BOOL)success {
    (void)item;
    (void)success;
}

@end
