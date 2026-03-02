//
//  NativeExpressVC.m
//  iOSDemo
//
//  Created by SDK Demo
//

#import "NativeExpressVC.h"
#import <SmartdigimktSDK/SmartdigimktSDK.h>

@interface NativeExpressVC () <SDMNativeLoadDelegate, SDMPubNativeDelegate, SDMPubNativeMediaViewDelegate>

@property (nonatomic, strong) SDMNative *nativeAdLoader;
@property (nonatomic, strong) SDMNativeAd *nativeAd;
@property (nonatomic, strong) UIView *nativeAdView;
@property (nonatomic, strong) UIView *adContainerView;

@end

@implementation NativeExpressVC
 
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupAdContainer];
 
    _nativeAdLoader = [[SDMNative alloc] initAdWithPlacementId:NativeExpressPlacementID];
    _nativeAdLoader.delegate = self;
    
    // 设置模板广告尺寸
    SDMAdRequest *adRequest = [[SDMAdRequest alloc] init];
    adRequest.adWidth = kScreenW;
    adRequest.adHeight = 350; // 模板广告高度
    _nativeAdLoader.adRequest = adRequest;
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
     
    // 获取SDK渲染好的模板视图
    UIView *templateView = _nativeAd.nativeAdOffer.templateView;
    
    if (!templateView) {
        return;
    }
    
    _nativeAdView = templateView;
 
    // 添加到容器
    [_adContainerView addSubview:_nativeAdView];
    
    // 布局模板视图
    CGRect frame = _nativeAdView.frame;
    _nativeAdView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    
    [_nativeAdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.adContainerView);
        make.top.equalTo(self.adContainerView);
        make.width.mas_equalTo(frame.size.width);
        make.height.mas_equalTo(frame.size.height);
    }];
     
    [_nativeAd registerAdView:nil
                  clickViews:nil 
                 prepareInfo:nil 
                 configParam:nil 
                   closeView:nil];
    
    [self showLog:@"模板广告展示完成"];
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
