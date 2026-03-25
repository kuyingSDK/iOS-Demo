//
//  SplashVC.m
//  iOSDemo
//
//  Created by ltz on 2025/1/18.
//

#import "SplashVC.h"

#import <SmartdigimktSDK/SmartdigimktSDK.h>
 
@interface SplashVC () <SDMPubSplashDelegate, SDMPubSplashLoadingDelegate>

@property (strong, nonatomic) SDMSplashAd * splashAd;

@property (strong, nonatomic) UIView * bottomLogoView;
 
@end
 
@implementation SplashVC
 
- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self loadAd];
}

#pragma mark - Load Ad
- (void)loadAd {
    self.splashAd = [[SDMSplashAd alloc] initAdWithPlacementId:SplashPlacementID];
 
    self.splashAd.loadDelegate = self;
    self.splashAd.showDelegate = self;
    //超时时间
    self.splashAd.fetchAdTimeout = FirstAppOpen_Timeout;
    
    [self.splashAd load];
}

#pragma mark - Show Ad
- (void)showAd {
    //设置底部logo view
    self.bottomLogoView = [self footLogoView];
    self.splashAd.containerView = self.bottomLogoView;
    
    self.splashAd.window = [UIApplication sharedApplication].keyWindow;
    self.splashAd.showViewController = self.tabBarController;
    
    //检查是否就绪
    BOOL ready = [self.splashAd isReady];
    if (ready) {
        //展示
        [self.splashAd showAd];
    }
}
 
/// 可选接入开屏底部LogoView
- (UIView *)footLogoView {
    
    //建议宽度为屏幕宽度,高度<=25%的屏幕高度
    UIView * footerCtrView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kOrientationScreenWidth, 120)];
    footerCtrView.backgroundColor = UIColor.whiteColor;
    
    //添加图片
    UIImageView * logoImageView = [UIImageView new];
    logoImageView.image = [UIImage imageNamed:@"logo"];
    logoImageView.contentMode = UIViewContentModeScaleAspectFill;
    logoImageView.frame = CGRectMake(0, 0, 40, 40);
    logoImageView.center = footerCtrView.center;
    [footerCtrView addSubview:logoImageView];
    
    //添加点击事件
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(footerImgClick:)];
    logoImageView.userInteractionEnabled = YES;
    [logoImageView addGestureRecognizer:tap];
      
    return footerCtrView;
}
 
/// footer点击事件
- (void)footerImgClick:(UITapGestureRecognizer *)tap {
    [self showLog:[NSString stringWithFormat:@"footer click !!"]];
}
 
#pragma mark - SDMPubSplashLoadingDelegate
- (void)onAdLoaded:(SDMSplashAd *)item isTimeout:(BOOL)isTimeout {
    [self showLog:[NSString stringWithFormat:@"onAdLoaded:%@ isTimeout:%d",item.placementId,isTimeout]];
    if (!isTimeout) {
        //加载成功，没有超时
        [self showLog:[NSString stringWithFormat:@"onAdLoaded:isTimeout: --> Load success,not timeout"]];
    }else {
        //加载成功，但超时了
        [self showLog:[NSString stringWithFormat:@"onAdLoaded:isTimeout: --> Load success,but timeout"]];
    }
}

/// Splash ad loading timeout callback
- (void)onAdLoadTimeout:(SDMSplashAd *)item {
    //超时了
    [self showLog:[NSString stringWithFormat:@"Splash load timeout"]];
}

#pragma mark - SDMPublicLoadingDelegate
/// Callback when the successful loading of the ad
- (void)onAdLoaded:(SDMBaseAd *)item {
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
//    [self.splashAd notifyWin:winInfo];
    
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
//    [self.splashAd notifyLoss:lossInfo];
}

/// Callback of ad loading failure
- (void)onAdLoadFail:(SDMBaseAd *)item
               error:(NSError *)error {
    [self showLog:[NSString stringWithFormat:@"onAdLoadFail:%@ error:%ld msg:%@", item.placementId, error.code,[NSString stringWithFormat:@"%@ %@",error.description,error.userInfo]]];
}
  
#pragma mark - SDMPubSplashDelegate
- (void)onAdShow:(SDMSplashAd *)item {
    //获得了展示收益
    SDMAd *ad = [item getSDMAd];
    double ecpmCNY = [ad.ecpmInfo currentEcpm:SDMAdCurrencyTypeCNY];
    double revenCNY = [ad.ecpmInfo currentRevenueEcpm:SDMAdCurrencyTypeCNY];
    double ecpmUSD = [ad.ecpmInfo currentEcpm:SDMAdCurrencyTypeUSD];
    double revenUSD = [ad.ecpmInfo currentRevenueEcpm:SDMAdCurrencyTypeUSD];
    
    [self showLog:[NSString stringWithFormat:@"onAdPlayStart\nplacementId: %@\neCPM(CNY): ¥%.4f\nRevenue(CNY): ¥%.4f\neCPM(USD): $%.4f\nRevenue(USD): $%.4f",
                   item.placementId,
                   ecpmCNY,
                   revenCNY,
                   ecpmUSD,
                   revenUSD]];
}

/// Splash ad click
- (void)onAdClick:(SDMSplashAd *)item extra:(nullable NSDictionary *)extra {
    [self showLog:[NSString stringWithFormat:@"onAdClick:%@",item.placementId]];
}

/// Splash ad closed
- (void)onAdClose:(SDMSplashAd *)item extra:(nullable NSDictionary *)extra {
    [self showLog:[NSString stringWithFormat:@"onAdClose:%@ ",item.placementId]];
}

/// @optional
///  Whether the click jump of Splash ad is in the form of Deeplink
- (void)onDeeplinkCallback:(SDMSplashAd *)item
                    result:(BOOL)success {
    [self showLog:[NSString stringWithFormat:@"onDeeplinkCallback:%@ result:%d ", item.placementId,success]];
}

/// @optional
/// Splash ad show fail with error
- (void)onAdShowFail:(SDMSplashAd *)item
               error:(NSError *)error {
    [self showLog:[NSString stringWithFormat:@"onAdShowFail:%@ error:%@ ",item.placementId,error]];
}
  
@end
