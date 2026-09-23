//
//  NativeSelfRenderVC.m
//  iOSDemo
//
//  Created by SDK Demo
//

#import "NativeSelfRenderVC.h"
#import <SmartdigimktSDK/SmartdigimktSDK.h>
#import "NativeSelfRenderView.h"

@interface NativeSelfRenderVC () <SDMNativeLoadDelegate, SDMPubNativeDelegate, SDMPubNativeMediaViewDelegate>

@property (nonatomic, strong) SDMNative *nativeAdLoader;
@property (nonatomic, strong) SDMNativeAd *nativeAd;
@property (nonatomic, strong) NativeSelfRenderView *nativeAdView;
@property (nonatomic, strong) UIView *adContainerView;

@end

@implementation NativeSelfRenderVC
 
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupAdContainer];
     
    _nativeAdLoader = [[SDMNative alloc] initAdWithPlacementId:NativeSelfRenderPlacementID];
    _nativeAdLoader.delegate = self;
}

- (void)setupAdContainer {
    _adContainerView = [[UIView alloc] init];
    _adContainerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_adContainerView];
    
    [_adContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(15);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(kScreenW);
        make.bottom.equalTo(self.footView.mas_top).offset(-15);
    }];
}

- (void)dealloc {
    [self cleanUpAd];
    ATDemoLog(@"NativeExpressVC dealloc");
}
 
#pragma mark - Ad Operations

- (void)loadAd {
    [_nativeAdLoader load];
}

- (void)showAd {
    if (!_nativeAd || ![_nativeAd isReady]) {
        [self loadAd];
        return;
    }
     
    // 创建自定义渲染视图
    _nativeAdView = [[NativeSelfRenderView alloc] initWithNativeAd:_nativeAd];
    _nativeAdView.backgroundColor = [UIColor whiteColor];
    _nativeAdView.layer.cornerRadius = 8;
    _nativeAdView.clipsToBounds = YES;
    
    
    // 获取媒体视图
    UIView *mediaView = [_nativeAd getMediaViewWithDelegate:self];
    
    // 构建可点击视图数组
    NSMutableArray *clickableViews = [@[
        _nativeAdView.iconImageView,
        _nativeAdView.titleLabel,
        _nativeAdView.textLabel,
        _nativeAdView.ctaLabel,
        _nativeAdView.mainImageView
    ] mutableCopy];
    
    // 如果有媒体视图，添加到媒体容器并加入可点击数组
    if (mediaView) {
        _nativeAdView.mediaContainerView.hidden = NO;
        _nativeAdView.mediaView = mediaView;
        [_nativeAdView.mediaContainerView addSubview:mediaView];
        [mediaView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.nativeAdView.mediaContainerView);
        }];
        [clickableViews addObject:mediaView];
        [_nativeAdView bringSubviewToFront:_nativeAdView.logoImageView];
    } else {
        _nativeAdView.mediaContainerView.hidden = YES;
    }
    
    if (_nativeAdView.mediaContainerView) {
        [clickableViews addObject:_nativeAdView.mediaContainerView];
    }
    
    // 创建准备信息
    SDMNativePrepareInfo *prepareInfo = [SDMNativePrepareInfo loadPrepareInfo:^(SDMNativePrepareInfo * _Nonnull info) {
        info.textLabel = self.nativeAdView.textLabel;
        info.advertiserLabel = self.nativeAdView.advertiserLabel;
        info.titleLabel = self.nativeAdView.titleLabel;
        info.ratingLabel = self.nativeAdView.ratingLabel;
        info.iconImageView = self.nativeAdView.iconImageView;
        info.mainImageView = self.nativeAdView.mainImageView;
        info.dislikeButton = self.nativeAdView.dislikeButton;
        info.ctaLabel = self.nativeAdView.ctaLabel;
        info.mediaView = self.nativeAdView.mediaView;
        info.mediaContainerView = self.nativeAdView.mediaContainerView;
    }];
    
    // 创建布局配置
    SDMNativeLayoutParams *layoutParams = [[SDMNativeLayoutParams alloc] init];
    layoutParams.AdFrame = _nativeAdView.frame;
    layoutParams.mediaViewFrame = _nativeAdView.mediaContainerView.frame;
    layoutParams.sizeToFit = YES;
    layoutParams.rootViewController = self;
    layoutParams.videoPlayType = SDMNativeAdOfferVideoPlayOnlyWiFiAutoPlayType;
    layoutParams.logoViewFrame = CGRectMake(0, 0, 20, 20); //广告标志位置
//    layoutParams.adChoicesViewOrigin //感叹号位置
    
    // 注册广告视图
    [_nativeAd registerAdView:_nativeAdView 
                  clickViews:clickableViews 
                 prepareInfo:prepareInfo 
                 configParam:layoutParams 
                   closeView:_nativeAdView.dislikeButton];
    
    // 添加到容器
    [_adContainerView addSubview:_nativeAdView];
    [_nativeAdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.adContainerView);
    }];
}
 
- (void)cleanUpAd {
    if (_nativeAdView) {
        [_nativeAdView removeFromSuperview];
        _nativeAdView = nil;
    }
    
    if (_nativeAd) {
        [_nativeAd destroy];
        _nativeAd = nil;
    }
}

#pragma mark - SDMNativeLoadDelegate

- (void)onAdLoaded:(SDMNativeAd *)nativeAd {
    [self showLog:[NSString stringWithFormat:@"onAdLoaded:%@", nativeAd.placementId]];
    
    _nativeAd = nativeAd;
    _nativeAd.showDelegate = self;
 
    // 获取价格
//    SDMAd *ad = [item getSDMAd];
//    double ecpm = [ad.ecpmInfo currentEcpm:SDMAdCurrencyTypeCNY];
//    double ecpmUSD = [ad.ecpmInfo currentEcpm:SDMAdCurrencyTypeUSD];
    
    //发起竞胜
//    SDMWinInfo *winInfo = [[SDMWinInfo alloc] init];
//    winInfo.networkName = @"TopOn";
//    winInfo.secondPrice = xxx;
//    winInfo.extraInfo = @{
//        @"m_platform": @1,
//        @"nw" : @"TopOn",
//        @"price" : @0.0001,
//        @"m_wf":  @[@{
//            @"nw": @"TopOn",
//            @"price": @2,
//            @"is_bid": @NO,
//        },@{
//            @"nw": @"TopOn",
//            @"price": @0.0001,
//            @"is_bid": @NO,
//        }],
//    };
//    winInfo.currencyType = SDMAdCurrencyTypeUSD;
//    [self.nativeAd notifyWin:winInfo];
    
    //发起竞败
//    SDMLossInfo *lossInfo = [[SDMLossInfo alloc] init];
//    lossInfo.networkName = @"TopOn";
//    lossInfo.winPrice = xxx;
//    lossInfo.reason = SDMLossReasonxxx;
//    lossInfo.extraInfo = @{
//        @"m_platform": @1,
//        @"nw" : @"TopOn",
//        @"price" : @0.0001,
//        @"m_wf":  @[@{
//            @"nw": @"TopOn",
//            @"price": @2,
//            @"is_bid": @NO,
//        },@{
//            @"nw": @"TopOn",
//            @"price": @0.0001,
//            @"is_bid": @NO,
//        }],
//    };
//    lossInfo.currencyType = SDMAdCurrencyTypeUSD;
//    [self.nativeAd notifyLoss:lossInfo];
}

- (void)onAdLoadFail:(NSError *)error {
    [self showLog:[NSString stringWithFormat:@"onAdLoadFail:%ld ", (long)error.code]];
}

#pragma mark - SDMPubNativeDelegate

- (void)onAdShow:(SDMNativeAd *)item {
    //获得了展示收益
    SDMAd *ad = [item getSDMAd];
    double ecpmCNY = [ad.ecpmInfo currentEcpm:SDMAdCurrencyTypeCNY];
    double revenCNY = [ad.ecpmInfo currentRevenueEcpm:SDMAdCurrencyTypeCNY];
    double ecpmUSD = [ad.ecpmInfo currentEcpm:SDMAdCurrencyTypeUSD];
    double revenUSD = [ad.ecpmInfo currentRevenueEcpm:SDMAdCurrencyTypeUSD];
    
    [self showLog:[NSString stringWithFormat:@"onAdShow\nplacementId: %@\neCPM(CNY): ¥%.4f\nRevenue(CNY): ¥%.4f\neCPM(USD): $%.4f\nRevenue(USD): $%.4f",
                   item.placementId,
                   ecpmCNY,
                   revenCNY,
                   ecpmUSD,
                   revenUSD]];
}

- (void)onAdClick:(SDMNativeAd *)item extra:(nullable NSDictionary *)extra {
    [self showLog:[NSString stringWithFormat:@"onAdClick:%@ extra:%@",item.placementId,extra]];
}

- (void)onAdClosed:(SDMNativeAd *)item extra:(nullable NSDictionary *)extra {
    [self showLog:[NSString stringWithFormat:@"onAdClosed:%@ extra:%@",item.placementId,extra]];
    
    [self cleanUpAd];
}

- (void)onDeeplinkCallback:(SDMNativeAd *)item result:(BOOL)success {
    [self showLog:[NSString stringWithFormat:@"onDeeplinkCallback:%@ result:%d ", item.placementId,success]];
}

#pragma mark - SDMPubNativeMediaViewDelegate

- (void)onVideoAdStartPlay:(SDMNativeAd *)item duration:(double)duration {
    
}

- (void)onVideoAdComplete:(SDMNativeAd *)item {
    
}

- (void)onVideoError:(SDMNativeAd *)item error:(NSError *)error {
    
}

- (void)onProgressUpdate:(SDMNativeAd *)item current:(double)current duration:(double)duration {
    
}

@end
