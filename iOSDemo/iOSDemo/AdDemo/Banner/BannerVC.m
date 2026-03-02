//
//  BannerVC.m
//  iOSDemo
//
//  Created by ltz on 2025/1/11.
//

#import "BannerVC.h"

#import <SmartdigimktSDK/SmartdigimktSDK.h>

@interface BannerVC () <SDMBannerViewDelegate>

@property (nonatomic, strong) SDMBannerView * adView;

@end

//请注意，banner size需要和后台配置的比例一致
#define BannerSize CGSizeMake(320, 50)

@implementation BannerVC

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.adView = [[SDMBannerView alloc] initWithFrame:CGRectMake(0, 0, BannerSize.width, BannerSize.height)];
    self.adView.placementId = BannerPlacementID;
    
    self.adView.delegate = self;
    
    SDMAdRequest *adRequest = [[SDMAdRequest alloc] init];
    adRequest.adWidth = BannerSize.width;
    adRequest.adHeight = BannerSize.height;
    adRequest.bannerRefresh = YES;//设置自动刷新
    [self.adView loadWithAdRequest:adRequest];
}

#pragma mark - Show Ad
- (void)showAd {
    //检查是否就绪
    BOOL ready = [self.adView isAdReady];
    if (ready) {
        //展示
        [self.view addSubview:self.adView];
        
        //布局
        [self.adView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.height.equalTo(@(BannerSize.height));
            make.width.equalTo(@(BannerSize.width));
            make.top.equalTo(self.textView.mas_bottom).offset(5);
        }];
    }
}

#pragma mark - 销毁广告
- (void)removeAd {
    [self.adView destroy];
    [self.adView removeFromSuperview];
    self.adView = nil;
}

#pragma mark - Demo按钮操作
/// 通过demo移除按钮点击来移除banner广告
- (void)removeAdButtonClickAction {
    [self removeAd];
}
 
//临时隐藏，隐藏后会停止自动加载
- (void)hiddenAdButtonClickAction {
    self.adView.hidden = YES;
}
 
//隐藏后重新展示
- (void)reshowAd {
    self.adView.hidden = NO;
}
 
#pragma mark - SDMBannerViewDelegate
/// Callback when the successful loading of the ad
- (void)onAdLoaded:(SDMBannerView *)item {
    [self showLog:[NSString stringWithFormat:@"onAdLoaded:%@", item.placementId]];
     
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
//    [self.adView notifyWin:winInfo];
    
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
//    [self.adView notifyLoss:lossInfo];
}

/// Callback of ad loading failure
- (void)onAdLoadFail:(SDMBannerView *)item error:(NSError *)error {
    [self showLog:[NSString stringWithFormat:@"onAdLoadFail:%@ error:%ld msg:%@", item.placementId, error.code,[NSString stringWithFormat:@"%@ %@",error.description,error.userInfo]]];
}
   
- (void)onAdShow:(SDMBannerView *)item {
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

/// ad click
- (void)onAdClick:(SDMBannerView *)item extra:(nullable NSDictionary *)extra {
    [self showLog:[NSString stringWithFormat:@"onAdClick:%@",item.placementId]];
}

/// ad closed
- (void)onAdClose:(SDMBannerView *)item extra:(nullable NSDictionary *)extra {
    [self showLog:[NSString stringWithFormat:@"onAdClose:%@ ",item.placementId]];
}

/// @optional
///  Whether the click jump of  ad is in the form of Deeplink
- (void)onDeeplinkCallback:(SDMBannerView *)item
                    result:(BOOL)success {
    [self showLog:[NSString stringWithFormat:@"onDeeplinkCallback:%@ result:%d ", item.placementId,success]];
}
 
@end
