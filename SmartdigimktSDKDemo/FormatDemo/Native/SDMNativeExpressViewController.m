//
//  SDMNativeExpressViewController.m
//  AnyThinkSDKDemo
//
//  Created by Topon on 7/28/22.
//  Copyright © 2022 抽筋的灯. All rights reserved.
//

#import "SDMNativeExpressViewController.h"
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

@interface SDMNativeExpressViewController() <SDMPubNativeDelegate, SDMNativeLoadDelegate>

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

@implementation SDMNativeExpressViewController

#pragma mark - 生命周期
- (void)dealloc {
    NSLog(@"🔥----SDMNativeExpressViewController销毁%@", NSStringFromSelector(_cmd));
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
    SDMAdRequest *adRequest = [[SDMAdRequest alloc] init];
    adRequest.adWidth = kScreenW;
    adRequest.adHeight = 350;
    _native.adRequest = adRequest;
}

#pragma mark - 广告位
- (NSString *)getPlacementID {
    return @"b64e6fc9ceecdd";
}

#pragma mark - UI Layout
- (void)setupUI {
    
    self.title = @"Native Express";
    self.view.backgroundColor = kRGB(245, 245, 245);
    
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
    NSLog(@"SDMNativeExpressViewController -- 发起竞胜");
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

#pragma mark - 广告 加载 展示
- (void)multipleLoad {
    SDMAdRequest *adRequest = [[SDMAdRequest alloc] init];
    adRequest.adWidth = CGRectGetWidth(self.view.bounds);
    adRequest.adHeight = 400;
    self.native.adRequest = adRequest;
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
//
- (void)mutilShowAd {
    if (_selectSubMenuIndexArr.count <= 1) {
        [self showLog:@"广告列表为空，请先加载广告"];
        return;
    }
    
    if ([self.currentSubMenuKey isEqualToString:@"add"]) {
        [self showLog:@"先在菜单处选择广告对象"];
        return;
    }
    // 判断广告isReady状态
    SDMNativeAd *adInfo = self.selectSubMenuInfo[self.currentSubMenuKey];
    [adInfo registerAdView:nil clickViews:nil prepareInfo:nil configParam:nil closeView:nil];
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
    UIView *mediaView = adInfo.nativeAdOffer.templateView;
    SDMNativeAdRenderType nativeAdRenderType = [adInfo.nativeAdOffer nativeAdRenderType];
    if (nativeAdRenderType == SDMNativeAdRenderExpress) {
        NSLog(@"🔥--原生模板");
    }else{
        NSLog(@"🔥--原生自渲染");
    }
    if (SDMMultipleDemoSendWin) {
        [self sendWin:adInfo];
    }
    BOOL isVideoContents = [adInfo.nativeAdOffer isVideoContents];
    NSLog(@"🔥--是否为原生视频广告：%d", adInfo.nativeAdOffer.isVideoContents);
    CGRect frame = mediaView.frame;
//    mediaView.frame = CGRectMake(0, kNavigationBarHeight, kScreenW, 350);
    mediaView.frame = CGRectMake(0, kNavigationBarHeight, frame.size.width, frame.size.height);
    self.adView = mediaView;
    SDMNativeShowViewController *vc = [[SDMNativeShowViewController alloc] initWithAdView:mediaView nativeAd:adInfo];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)multipleLoadMoreAd {
    self.currentSubMenuKey = @"add";
    for (int i = 0; i < SDMMultipleDemoSynLoadCountKey; i++) {
        [self multipleLoad];
    }
}
//
- (void)destroyAd {
    SDMNativeAd *adInfo = nil;
    if ([self.currentSubMenuKey isEqualToString:@"add"]) {
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

- (void)removeAd {
    if (self.adView && self.adView.superview) {
        [self.adView removeFromSuperview];
    }
    self.adView = nil;
}
//
- (void)hidenAd {
//    if (kTopOnDemoNativeSuperViewHiddenSwitch) {
//        self.nativeSuperView.hidden = !self.nativeSuperView.hidden;
//    }
}
//
- (void)reShowAd {
//    if (kTopOnDemoNativeSuperViewHiddenSwitch) {
//        self.nativeSuperView = [[UIView alloc] init];
//        [self.nativeSuperView addSubview:self.adView];
//        
//        [self.view addSubview:self.nativeSuperView];
//        [self.nativeSuperView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.view).offset(kNavigationBarHeight);
//            make.left.equalTo(self.view);
//            make.right.equalTo(self.view);
//            make.height.mas_equalTo(350);
//        }];
//        
//        [self.adView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.nativeSuperView);
//        }];
//    }
}

#pragma mark - 日志
- (void)clearLog {
    self.textView.text = @"";
}

- (void)showLog:(NSString *)logStr {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *logS = self.textView.text;
        NSString *log = nil;
        if (![logS isEqualToString:@""]) {
            log = [NSString stringWithFormat:@"%@\n%@", logS, logStr];
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

//#pragma mark - SDMPubNativeDelegate
///// Native ads displayed successfully
//- (void)adxDidShowNativeAd:(SDMBaseAd *)item {
//    if (![item isKindOfClass:[SDMNativeAd class]]) {
//        return;
//    }
//    SDMNativeAd *nativeItem = (SDMNativeAd *)item;
//    nativeItem.nativeView.mainImageView.hidden = [nativeItem.nativeView isVideoContents];
//    ATDemoLog(@"ATNativeViewController:: didShowNativeAdInAdView:%@ extra:%@", item.placementId, item.adSourceExtra);
//    [self showLog:[NSString stringWithFormat:@"didShowNativeAdInAdView:%@ ad:%p \n requestid=%@", item.placementId, item, item.adInfo.requestId]];
//}
//
///// Native ad click
//- (void)adxDidClickNativeAd:(SDMBaseAd *)item {
//    ATDemoLog(@"ATNativeViewController:: didClickNativeAdInAdView:%@ extra:%@", item.placementId, item.adSourceExtra);
//    [self showLog:[NSString stringWithFormat:@"didClickNativeAdInAdView:%@ ad:%p \n requestid=%@", item.placementId, item, item.adInfo.requestId]];
//}
//
///// Native video ad starts playing
//- (void)adxDidStartPlayingVideo:(SDMBaseAd *)item {
//    ATDemoLog(@"ATNativeViewController:: didStartPlayingVideoInAdView:%@ extra: %@", item.placementId, item.adSourceExtra);
//    [self showLog:[NSString stringWithFormat:@"didStartPlayingVideoInAdView:%@ ad:%p \n requestid=%@", item.placementId, item, item.adInfo.requestId]];
//}
//
///// Native video ad ends playing
//- (void)adxDidEndPlayingVideo:(SDMBaseAd *)item {
//    ATDemoLog(@"ATNativeViewController:: didEndPlayingVideoInAdView:%@ extra: %@", item.placementId, item.adSourceExtra);
//    [self showLog:[NSString stringWithFormat:@"didEndPlayingVideoInAdView:%@ ad:%p \n requestid=%@", item.placementId, item, item.adInfo.requestId]];
//}
//
///// Native ad close button cliecked
//- (void)adxDidTapCloseButton:(SDMBaseAd *)item {
//    NSLog(@"ATNativeViewController:: didTapCloseButtonInAdView:%@ extra:%@", item.placementId, item.adSourceExtra);
//    [self.adView removeFromSuperview];
//    self.adView = nil;
//    [self showLog:[NSString stringWithFormat:@"didTapCloseButtonInAdView:%@ ad:%p \n requestid=%@", item.placementId, item, item.adInfo.requestId]];
//}
//
///// Native ads click to close the details page
//- (void)adxDidCloseDetail:(SDMBaseAd *)item {
//    ATDemoLog(@"ATNativeViewController:: didCloseDetailInAdView:%@ extra:%@", item.placementId, item.adSourceExtra);
//    [self showLog:[NSString stringWithFormat:@"didCloseDetailInAdView:%@ ad:%p \n requestid=%@", item.placementId, item, item.adInfo.requestId]];
//}
//
///// Whether the click jump of Native ads is in the form of Deeplink
//- (void)adxDidDeepLinkOrJump:(SDMBaseAd *)item
//                      result:(BOOL)success {
//    ATDemoLog(@"ATNativeViewController:: didDeepLinkOrJumpInAdView:placementID:%@ with extra: %@, success:%@", item.placementId, item.adSourceExtra, success ? @"YES" : @"NO");
//    [self showLog:[NSString stringWithFormat:@"ATNativeViewController:: didDeepLinkOrJumpInAdView:%@, success:%@ ad:%p \n requestid=%@", item.placementId, success ? @"YES" : @"NO", item]];
//}
//
//#pragma mark - SDMPublicLoadingDelegate
//
//- (void)didFinishLoadingADXItem:(SDMBaseAd *)item {
//    [self showLog:@"unuse callback call"];
//}
//
///// Callback when the successful loading of the ad
//- (void)didFinishLoadingADXNativeItem:(SDMBaseAd *)item nativeView:(ATNativeADView *)nativeView {
//    BOOL ready = [item isReady:nil];
//    [self showLog:[NSString stringWithFormat:@"didFinishLoadingADWithPlacementID:%@--isReady:%@ \n requestid=%@", item.placementId, ready ? @"YES":@"NO", item.adInfo.requestId]];
//}
//
///// Callback of ad loading failure
//- (void)didFailToLoadADXItem:(SDMBaseAd *)item
//                       error:(NSError*)error {
//    [self showLog:[NSString stringWithFormat:@"didFailToLoadADXWithPlacementID:%@ errorCode:%ld error=%@ \n requestid=%@", item.placementId, (long)error.code, error.domain, item.adInfo.requestId]];
//}

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
    [self showLog:[NSString stringWithFormat:@"NativeViewController:: didDeepLinkOrJumpInAdView:%@, success:%@ ad:%p \n", item.placementId, success ? @"YES" : @"NO", item]];
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
