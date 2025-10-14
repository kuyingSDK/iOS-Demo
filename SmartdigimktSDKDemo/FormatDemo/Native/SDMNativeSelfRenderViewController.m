//
//  SDMNativeSelfRenderViewController.m
//  AnyThingSDKDemo
//
//  Created by mac on 2021/12/6.
//

#import "SDMNativeSelfRenderViewController.h"
#import <Masonry/Masonry.h>
#import "SDMDemoUIHeader.h"
#import "SDMTestMutilDefine.h"
#import "SDMMenuView.h"
#import "SDMHomeTableViewCell.h"
#import <SmartdigimktSDK/SDMNative.h>
#import <SmartdigimktSDK/SDMNativeAd.h>
#import <SmartdigimktSDK/SDMAPI.h>
#import <SmartdigimktSDK/SDMNativePrepareInfo.h>
#import <SmartdigimktSDK/SDMNativeLayoutParams.h>
#import "SDMDemoUIHeader.h"
#import "SDMNativeSelfRenderView.h"
#import "SDMModelButton.h"
#import "SDMNativeShowViewController.h"


@interface SDMNativeSelfRenderViewController () <SDMNativeLoadDelegate, SDMPubNativeDelegate>

@property (nonatomic, strong) UIView * renderView;
@property (nonatomic, copy) NSString *nativeStr;
@property (nonatomic, strong) UIView *showView;
@property (nonatomic, strong) UIImageView *iconview;
@property (nonatomic, strong) UIView *nativeSuperView;
@property (nonatomic, strong) SDMMenuView *menuView;
@property (nonatomic, strong) UIButton *loadBtn;
@property (nonatomic, strong) UIButton *isReadyBtn;
@property (nonatomic, strong) UIButton *showBtn;
@property (nonatomic, strong) UIButton *destroyBtn;
@property (nonatomic, strong) UIButton *allLoadBtn;
@property (nonatomic, strong) UIButton *removeBtn;
@property (nonatomic, strong) UIButton *reShowBtn;
@property (nonatomic, strong) UIButton *hiddenBtn;
@property (nonatomic, strong) UIButton *multipleLoadMoreBtn;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSMutableDictionary *selectSubMenuInfo;
@property (nonatomic, strong) NSMutableArray *selectSubMenuIndexArr;
@property (nonatomic, copy) NSString *currentSubMenuKey;
@property (nonatomic, strong) UIView *adView; // 广告视图
@property (nonatomic, strong) SDMNative *native;
@property (nonatomic, strong) SDMNativeSelfRenderView *nativeSelfRenderView;

@end

@implementation SDMNativeSelfRenderViewController
//
//#pragma mark - 生命周期
- (void)dealloc {
    NSLog(@"🔥----ATNativeViewController销毁%@", NSStringFromSelector(_cmd));
    [self removeAd];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectSubMenuInfo = [NSMutableDictionary dictionary];
    _selectSubMenuIndexArr = [NSMutableArray array];
    NSString *key = @"add";
    _selectSubMenuInfo[key] = @"new object";
    [_selectSubMenuIndexArr addObject:key];
    _currentSubMenuKey = key;
    
    [self setupUI];
    [self actionUICallback];
    
    _native = [[SDMNative alloc] initAdWithPlacementId:[self getPlacementID]];
    _native.delegate = self;
}

#pragma mark - 广告位
- (NSString *)getPlacementID {
    return @"b5fa25023d0767";
}

#pragma mark - UI Layout
- (void)setupUI {
    
    self.view.backgroundColor = kRGB(245, 245, 245);
    self.title = @"Native";
    
    UIButton *clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    [clearBtn setTitle:@"clear log" forState:UIControlStateNormal];
    [clearBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clearLog) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:clearBtn];
    self.navigationItem.rightBarButtonItem = btnItem;
    
    [self.view addSubview:self.menuView];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.loadBtn];
    [self.view addSubview:self.isReadyBtn];
    [self.view addSubview:self.showBtn];
    [self.view addSubview:self.destroyBtn];
    [self.view addSubview:self.allLoadBtn];
    [self.view addSubview:self.multipleLoadMoreBtn];
    [self.view addSubview:self.removeBtn];
    [self.view addSubview:self.reShowBtn];
    [self.view addSubview:self.hiddenBtn];
    
    CGFloat width = (kScreenW - kScaleW(52) - kScaleW(26)) / 2;
    
    [self.menuView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenW - kScaleW(52));
        make.height.mas_equalTo(kScaleW(242));
        make.top.equalTo(self.view.mas_top).offset(kNavigationBarHeight + kScaleW(20));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.loadBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.menuView.mas_bottom).offset(kScaleW(20));
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(kScaleW(76));
        make.left.equalTo(self.view.mas_left).offset(kScaleW(26));
    }];
    [self.removeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.menuView.mas_bottom).offset(kScaleW(20));
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(kScaleW(76));
        make.left.equalTo(self.loadBtn.mas_right).offset(kScaleW(26));
    }];
    
    [self.isReadyBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loadBtn.mas_bottom).offset(kScaleW(20));
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(kScaleW(76));
        make.left.equalTo(self.view.mas_left).offset(kScaleW(26));
    }];
    [self.reShowBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loadBtn.mas_bottom).offset(kScaleW(20));
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(kScaleW(76));
        make.left.equalTo(self.isReadyBtn.mas_right).offset(kScaleW(26));
    }];
    
    [self.showBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.isReadyBtn.mas_bottom).offset(kScaleW(20));
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(kScaleW(76));
        make.left.equalTo(self.view.mas_left).offset(kScaleW(26));
    }];
    [self.hiddenBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.isReadyBtn.mas_bottom).offset(kScaleW(20));
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(kScaleW(76));
        make.left.equalTo(self.showBtn.mas_right).offset(kScaleW(26));
    }];
    
    [self.destroyBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.showBtn.mas_bottom).offset(kScaleW(20));
        make.width.mas_equalTo(kScreenW - kScaleW(52));
        make.height.mas_equalTo(kScaleW(76));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    [self.allLoadBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.destroyBtn.mas_bottom).offset(kScaleW(20));
        make.width.mas_equalTo(kScreenW - kScaleW(52));
        make.height.mas_equalTo(kScaleW(76));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    [self.multipleLoadMoreBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.allLoadBtn.mas_bottom).offset(kScaleW(20));
        make.width.mas_equalTo(kScreenW - kScaleW(52));
        make.height.mas_equalTo(kScaleW(76));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.multipleLoadMoreBtn.mas_bottom).offset(kScaleW(20));
        make.bottom.equalTo(self.view.mas_bottom).offset(kScaleW(-20));
        make.width.mas_equalTo(kScreenW - kScaleW(52));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}
#pragma mark - UI Action
- (void)actionUICallback {
    __weak typeof(self) weakSelf = self;
    [self.menuView setSelectSubMenu:^(NSString * _Nonnull selectSubMenu) {
        [weakSelf updateCurrentSubMenuKey:selectSubMenu];
    }];
}

- (void)resetSubMenuList {
    NSUInteger index = [self.selectSubMenuIndexArr indexOfObject:self.currentSubMenuKey];
    [self.menuView resetSubMenuList:self.selectSubMenuIndexArr index:index];
}

- (void)updateCurrentSubMenuKey:(NSString *)selectSubMenu {
    self.currentSubMenuKey = selectSubMenu;
    SDMBaseAd *adInfo = nil;
    if (!self.currentSubMenuKey && ![self.currentSubMenuKey isEqualToString:@"add"]) {
        adInfo = self.selectSubMenuInfo[self.currentSubMenuKey];
    }
}

#pragma mark - 广告 加载 展示
- (void)removeAd {
    if (self.adView && self.adView.superview) {
        [self.adView removeFromSuperview];
    }
//    [self.adView destroyNative];
    self.adView = nil;
    // 更及时销毁offer
//    [_nativeSelfRenderView destory];
//    _nativeSelfRenderView = nil;
}
//
- (void)hidenAd {
    
}

- (void)reShowAd {
    
}

#pragma mark - Private
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)updateButtonUI:(UIButton *)btn title:(NSString *)title {
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.layer.borderColor = kRGB(73, 109, 255).CGColor;
    btn.layer.borderWidth = kScaleW(3);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [btn setTitleColor:kRGB(73, 109, 255) forState:UIControlStateNormal];
    [btn setBackgroundImage:[self imageWithColor:kRGB(73, 109, 255)] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
}

- (void)sendWin:(SDMBaseAd *)ad {
    if (!SDMMultipleDemoSendWin) {
        return;
    }
    SDMWinInfo *winInfo = [[SDMWinInfo alloc] init];
    winInfo.networkName = @"TopOn";
    winInfo.secondPrice = kSDMDemoBidPrice;
    winInfo.extraInfo = @{
        @"m_platform": @1,
        @"nw" : @"TopOn",
        @"price" : @0.0001,
        @"m_wf":  @[@{
            @"nw": @"TopOn",
            @"price": @2,
            @"is_bid": @NO,
        },@{
            @"nw": @"TopOn",
            @"price": @0.0001,
            @"is_bid": @NO,
        }],
    };
    winInfo.currencyType = SDMAdCurrencyTypeUSD;
    NSLog(@"SDMNativeSelfRenderViewController -- 发起竞胜");
    [ad notifyWin:winInfo];
}

- (void)sendLoss:(SDMBaseAd *)ad reason:(SDMLossReason)reason {
    SDMLossInfo *lossInfo = [[SDMLossInfo alloc] init];
    lossInfo.networkName = @"TopOn";
    lossInfo.winPrice = kSDMDemoBidPrice;
    lossInfo.reason = reason;
    lossInfo.extraInfo = @{
        @"m_platform": @1,
        @"nw" : @"TopOn",
        @"price" : @0.0001,
        @"m_wf":  @[@{
            @"nw": @"TopOn",
            @"price": @2,
            @"is_bid": @NO,
        },@{
            @"nw": @"TopOn",
            @"price": @0.0001,
            @"is_bid": @NO,
        }],
    };
    lossInfo.currencyType = SDMAdCurrencyTypeUSD;
    NSLog(@"native -- 发起竞败");
    [ad notifyLoss:lossInfo];
}
- (void)sendLoss:(SDMBaseAd *)ad {
    if (!SDMMultipleDemoSendLoss) {
        return;
    }
    [self sendLoss:ad reason:SDMLossToExpire];
}

#pragma mark - 日志
- (void)showLog:(NSString *)logStr {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *logS = self.textView.text;
        NSString *log = nil;
        if (![logS isEqualToString:@""]) {
            log = [NSString stringWithFormat:@"%@\n\n%@", logS, logStr];
        } else {
            log = [NSString stringWithFormat:@"%@", logStr];
        }
        self.textView.text = log;
        if(([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeLeft) || ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeRight)){//横屏
            return;
        }
        [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length, 1)];
    });
}

- (void)clearLog {
    self.textView.text = @"";
}

//#pragma mark - Show Action
- (SDMNativeLayoutParams *)getNativeADConfiguration {
    SDMNativeLayoutParams *config = [[SDMNativeLayoutParams alloc] init];
    config.AdFrame = CGRectMake(0, kNavigationBarHeight, kScreenW, 350);
    config.mediaViewFrame = CGRectMake(0, kNavigationBarHeight + 150.0f, kScreenW - 40, 350 - 150);
    config.sizeToFit = YES;
    config.rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    config.videoPlayType = SDMNativeAdOfferVideoPlayOnlyWiFiAutoPlayType;
    config.logoViewFrame = CGRectMake(0, 0, 20, 20);
    return config;
}
//
- (SDMNativeSelfRenderView *)getSelfRenderViewOffer:(SDMNativeAd *)nativeAd {
    SDMNativeSelfRenderView *selfRenderView = [[SDMNativeSelfRenderView alloc] initWithOffer:nativeAd];
    self.nativeSelfRenderView = selfRenderView;
    selfRenderView.backgroundColor = randomColor;
    return selfRenderView;
}

- (void)updateNativeAdView:(SDMNativeAd *)nativeAd selfRenderView:(SDMNativeSelfRenderView *)selfRenderView {
    UIView *mediaView = [nativeAd.nativeAdOffer mediaView];
    
    NSMutableArray *array = [@[selfRenderView.iconImageView,
                               selfRenderView.titleLabel,
                               selfRenderView.textLabel,
                               selfRenderView.ctaLabel,
                               selfRenderView.mainImageView] mutableCopy];
    if (mediaView) {
        selfRenderView.mediaContainerView.hidden = NO;
        [array addObject:mediaView];
        mediaView.backgroundColor = [UIColor redColor];
        selfRenderView.mediaView = mediaView;
        [selfRenderView.mediaContainerView addSubview:mediaView];
        [mediaView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(selfRenderView.mediaContainerView);
        }];
        [selfRenderView bringSubviewToFront:selfRenderView.logoImageView];
    } else {
        selfRenderView.mediaContainerView.hidden = YES;
    }
    if (selfRenderView.mediaContainerView) {
        [array addObject:selfRenderView.mediaContainerView];
    }
    
    SDMNativeLayoutParams *config = [self getNativeADConfiguration];
    
    SDMNativePrepareInfo *nativePrepareInfo = [self prepareWithNativePrepareInfo:selfRenderView];
    
    [nativeAd registerAdView:selfRenderView clickViews:array prepareInfo:nativePrepareInfo configParam:config closeView:nil];
}

- (SDMNativePrepareInfo *)prepareWithNativePrepareInfo:(SDMNativeSelfRenderView *)selfRenderView {
    SDMNativePrepareInfo *info = [SDMNativePrepareInfo loadPrepareInfo:^(SDMNativePrepareInfo * _Nonnull prepareInfo) {
        prepareInfo.textLabel = selfRenderView.textLabel;
        prepareInfo.advertiserLabel = selfRenderView.advertiserLabel;
        prepareInfo.titleLabel = selfRenderView.titleLabel;
        prepareInfo.ratingLabel = selfRenderView.ratingLabel;
        prepareInfo.iconImageView = selfRenderView.iconImageView;
        prepareInfo.mainImageView = selfRenderView.mainImageView;
        prepareInfo.dislikeButton = selfRenderView.dislikeButton;
        prepareInfo.ctaLabel = selfRenderView.ctaLabel;
        prepareInfo.mediaView = selfRenderView.mediaView;
        prepareInfo.mediaContainerView = selfRenderView.mediaContainerView;
    }];
    
    return info;
}

- (void)multipleLoad {
    if (self.adView) {
        self.adView = nil;
        [self.renderView removeFromSuperview];
    }
    
    CGSize size = CGSizeMake(CGRectGetWidth(self.view.bounds), 400);
    NSMutableDictionary *extra = [@{
        @"native_ad_size": [NSValue valueWithCGSize:size],
//        kATExtraNativeImageSizeKey:kATExtraNativeImageSize690_388,
//        kATNativeAdSizeToFitKey:@YES,
//        kATAdLoadingExtraMediaExtraKey:@"PPPPPP_native",
    } mutableCopy];
    [extra setValue:@"TopOn--1" forKey:@"adLoad"];
    [extra setValue:@"TopOn--2" forKey:@"adGap"];
    [extra setValue:@"TopOn--3" forKey:@"pageId"];
    [extra setValue:@"TopOn--4" forKey:@"sectionId"];
    [extra setValue:@"TopOn--5" forKey:@"custom"];
    
//    SDMFloorPrice *floorPrice = [[SDMFloorPrice alloc] init];
//    floorPrice.value = @"1";
//    floorPrice.type = SDMFloorPriceTypeG;
    
//    NSMutableDictionary *extra1 = @{}.mutableCopy;
//    extra1[kSDMFloorPriceLoadTopOnWaterfall] = @[@"22222"];
//    extra1[kSDMFloorPriceLoadTopOnWaterfallLastStopPrice] = @1;
//    floorPrice.extra = extra1;
    [self.native load];
}

- (void)mutilCheckAd {    
    NSMutableString *logString = [NSMutableString stringWithString:@"ADX广告状态:\n"];
    for (NSString *key in self.selectSubMenuIndexArr) {
        if ([key isEqualToString:@"add"]) {
            continue;
        }
        SDMNativeAd *adInfo = self.selectSubMenuInfo[key];
        if ([adInfo isKindOfClass:[SDMNativeAd class]]) {
            BOOL isADXReady = [adInfo isReady];
            [logString appendFormat:@"key:%@ → %@\n", key, isADXReady ? @"Ready" : @"Not Ready"];
            if (!isADXReady) {
                [self sendLoss:adInfo];
            }
        }
    }
    [self showLog:logString];
}

- (void)mutilShowAd {
    if (_selectSubMenuIndexArr.count <= 1) {
        [self showLog:@"广告列表为空，请先加载广告"];
        return;
    }
    
    if ([self.currentSubMenuKey isEqualToString:@"add"]) {
        [self showLog:@"先在菜单处选择广告对象"];
        return;
    }
    
    SDMNativeAd *adInfo = self.selectSubMenuInfo[self.currentSubMenuKey];
    BOOL ready = [adInfo isReady];
    if (ready == NO) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Not Yet!" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alert dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return;
    }
    if (!adInfo) {
        [self showLog:@"show fail, reason=updateNativeOffer fail"];
        return;
    }
    NSLog(@"🔥--ADX-原生广告--宽高：%@",NSStringFromCGSize(CGSizeMake(adInfo.nativeAdOffer.mainImageWidth, adInfo.nativeAdOffer.mainImageHeight)));
    NSLog(@"🔥--ADX-原生广告--点击交换类型：%ld", adInfo.nativeAdOffer.interactionType);
    NSLog(@"🔥--ADX-原生广告--logoUrl: %@", adInfo.nativeAdOffer.logoUrl);
//    NSDictionary *offerDict = [ATUtilitiesTool getNativeAdOfferExtraDic:adInfo.nativeAdOffer];
//    NSLog(@"🔥--原生广告素材：%@",offerDict);
//    NSLog(@"🔥--原生广告adInfo信息，展示前：%@", adInfo.nativeAdOffer);
    
//    [adInfo showNativeViewWithConfig:showConfig nativeConfig:config];
    if (SDMMultipleDemoSendWin) {
        [self sendWin:adInfo];
    }
    
    SDMNativeSelfRenderView *selfRenderView = [self getSelfRenderViewOffer:adInfo];
    [self updateNativeAdView:adInfo selfRenderView:selfRenderView];
    
    
    SDMNativeAdRenderType nativeAdRenderType = adInfo.nativeAdOffer.nativeAdRenderType;
    
    if (nativeAdRenderType == SDMNativeAdRenderExpress) {
        NSLog(@"🔥--adx原生模板");
    } else {
        NSLog(@"🔥--adx原生自渲染");
    }
    
    BOOL isVideoContents = adInfo.nativeAdOffer.isVideoContents;
    NSLog(@"🔥--是否为原生视频广告：%d",isVideoContents);
    self.adView = selfRenderView;
    selfRenderView.frame = CGRectMake(0, kNavigationBarHeight, kScreenW, 350);
    
    SDMNativeShowViewController *vc = [[SDMNativeShowViewController alloc] initWithAdView:selfRenderView nativeAd:adInfo];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)multipleLoadMoreAd {
    for (int i = 0; i < SDMMultipleDemoSynLoadCountKey; i++) {
        [self multipleLoad];
    }
}

- (void)destroyAd {
    SDMNativeAd *adInfo = nil;
    if (self.selectSubMenuInfo.count <= 0) {
        return;
    }
    adInfo = self.selectSubMenuInfo[self.currentSubMenuKey];
    [adInfo destroy];
    [self.selectSubMenuInfo removeObjectForKey:self.currentSubMenuKey];
    [self.selectSubMenuIndexArr removeObject:self.currentSubMenuKey];
    self.currentSubMenuKey = @"add";
    
    [self showLog:[NSString stringWithFormat:@"%@ adInfo %p did destroy", NSStringFromClass([adInfo class]), adInfo]];
    [self resetSubMenuList];
}

- (void)allLoadEvent {

}

- (void)removeAdAction {
    
}

#pragma mark - SDMNativeLoadDelegate
- (void)onAdLoaded:(SDMNativeAd *)nativeAd {
    BOOL ready = [nativeAd isReady];
    SDMAd *ad = [nativeAd getSDMAd];
    double ecpm = [ad.ecpmInfo currentEcpm:SDMAdCurrencyTypeCNY];
    double ecpmUSD = [ad.ecpmInfo currentEcpm:SDMAdCurrencyTypeUSD];
    if (ecpmUSD < kSDMDemoBidPrice) {
        [self showLog:[NSString stringWithFormat:@"finish时获取价格低于底价，当前广告ecpm=%f USD", ecpmUSD]];
        [self sendLoss:nativeAd reason:SDMLossToAuctionFloor];
    } else {
        [self showLog:[NSString stringWithFormat:@"didFinishLoadingADWithPlacementID:%@--isReady:%@  ", nativeAd.placementId, ready ? @"YES":@"NO"]];
        NSString *key = [NSString stringWithFormat:@"%p", nativeAd];
        nativeAd.showDelegate = self;
        _selectSubMenuInfo[key] = nativeAd;
        [_selectSubMenuIndexArr addObject:key];
    }
}

- (void)onAdLoadFail:(NSError *)error {
    [self showLog:[NSString stringWithFormat:@"didFailToLoadADX errorCode:%ld error=%@", (long)error.code, error.domain]];
}

#pragma mark - SDMPubNativeDelegate

/// Native ads displayed successfully
- (void)onAdShow:(SDMNativeAd *)item {
    if (![item isKindOfClass:[SDMNativeAd class]]) {
        return;
    }
    
    SDMAd *ad = [item getSDMAd];
    double ecpm = [ad.ecpmInfo currentEcpm:SDMAdCurrencyTypeCNY];
    double reven = [ad.ecpmInfo currentRevenueEcpm:SDMAdCurrencyTypeCNY];
    double ecpmUSD = [ad.ecpmInfo currentEcpm:SDMAdCurrencyTypeUSD];
    double revenUSD = [ad.ecpmInfo currentRevenueEcpm:SDMAdCurrencyTypeUSD];
    double rate = [[ad.ecpmInfo valueForKey:@"rateDecimal"] doubleValue];
    [self showLog:[NSString stringWithFormat:@"CNY reven ecpm:%f reven=%f, rate=%f", ecpm, reven, rate]];
    [self showLog:[NSString stringWithFormat:@"USD reven ecpm:%f reven=%f, rate=%f", ecpmUSD, revenUSD, rate]];
    
    NSLog(@"NativeViewController:: didShowNativeAdInAdView:%@ extra:%@", item.placementId, item.adSourceExtra);
    [self showLog:[NSString stringWithFormat:@"didShowNativeAdInAdView:%@ ad:%p \n requestid=%@", item.placementId, item, ad.placementInfo.requestId]];
}

/// Native ad click
- (void)onAdClick:(SDMNativeAd *)item extra:(nullable NSDictionary *)extra {
    [self showLog:[NSString stringWithFormat:@"didClickNativeAdInAdView:%@ ad:%p \n", item.placementId, item]];
}

/// Native ad close button cliecked
- (void)onAdClosed:(SDMNativeAd *)item extra:(nullable NSDictionary *)extra {
    [self showLog:[NSString stringWithFormat:@"didTapCloseButtonInAdView:%@ ad:%p \n", item.placementId, item]];
    [self removeAd];
}

/// Whether the click jump of Native ads is in the form of Deeplink
- (void)onDeeplinkCallback:(SDMNativeAd *)item
                    result:(BOOL)success {
    [self showLog:[NSString stringWithFormat:@"ATNativeViewController:: didDeepLinkOrJumpInAdView:%@, success:%@ ad:%p \n", item.placementId, success ? @"YES" : @"NO", item]];
}

#pragma mark - lazy
- (UIView *)showView {
    if (!_showView) {
        _showView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
        _showView.backgroundColor = [UIColor whiteColor];
    }
    return _showView;
}

- (SDMMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[SDMMenuView alloc] initWithMenuList:@[[self getPlacementID]] subMenuList:self.selectSubMenuIndexArr];
        _menuView.layer.masksToBounds = YES;
        _menuView.layer.cornerRadius = 5;
    }
    return _menuView;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.layer.masksToBounds = YES;
        _textView.layer.cornerRadius = 5;
        _textView.editable = NO;
        _textView.text = nil;
    }
    return _textView;
}

- (UIButton *)loadBtn {
    if (!_loadBtn) {
        _loadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loadBtn addTarget:self action:@selector(multipleLoad) forControlEvents:UIControlEventTouchUpInside];
        [self updateButtonUI:_loadBtn title:@"load ad"];
    }
    return _loadBtn;
}

- (UIButton *)isReadyBtn {
    if (!_isReadyBtn) {
        _isReadyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_isReadyBtn addTarget:self action:@selector(mutilCheckAd) forControlEvents:UIControlEventTouchUpInside];
        [self updateButtonUI:_isReadyBtn title:@"is ready"];
    }
    return _isReadyBtn;
}

- (UIButton *)showBtn {
    if (!_showBtn) {
        _showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showBtn addTarget:self action:@selector(mutilShowAd) forControlEvents:UIControlEventTouchUpInside];
        [self updateButtonUI:_showBtn title:@"show ad"];
    }
    return _showBtn;
}

- (UIButton *)destroyBtn {
    if (!_destroyBtn) {
        _destroyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_destroyBtn addTarget:self action:@selector(destroyAd) forControlEvents:UIControlEventTouchUpInside];
        [self updateButtonUI:_destroyBtn title:@"destroy"];
    }
    return _destroyBtn;
}

- (UIButton *)allLoadBtn {
    if (!_allLoadBtn) {
        _allLoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_allLoadBtn addTarget:self action:@selector(allLoadEvent) forControlEvents:UIControlEventTouchUpInside];
        [self updateButtonUI:_allLoadBtn title:@"all load"];
    }
    return _allLoadBtn;
}

- (UIButton *)multipleLoadMoreBtn {
    if (!_multipleLoadMoreBtn) {
        _multipleLoadMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self updateButtonUI:_multipleLoadMoreBtn title:@"multiple load more ad"];
        [_multipleLoadMoreBtn addTarget:self action:@selector(multipleLoadMoreAd) forControlEvents:UIControlEventTouchUpInside];
    }
    return _multipleLoadMoreBtn;
}

- (UIButton *)reShowBtn {
    if (!_reShowBtn) {
        _reShowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self updateButtonUI:_reShowBtn title:@"reShow ad"];
        [_reShowBtn addTarget:self action:@selector(reShowAd) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reShowBtn;
}

- (UIButton *)hiddenBtn {
    if (!_hiddenBtn) {
        _hiddenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self updateButtonUI:_hiddenBtn title:@"hidden ad"];
        [_hiddenBtn addTarget:self action:@selector(hidenAd) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hiddenBtn;
}

- (UIButton *)removeBtn {
    if (!_removeBtn) {
        _removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self updateButtonUI:_removeBtn title:@"remove ad"];
        [_removeBtn addTarget:self action:@selector(removeAd) forControlEvents:UIControlEventTouchUpInside];
    }
    return _removeBtn;
}

@end
