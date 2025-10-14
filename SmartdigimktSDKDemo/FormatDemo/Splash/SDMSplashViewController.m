//
//  SDMSplashViewController.m
//  AnyThingSDKDemo
//
//  Created by mac on 2021/12/6.
//

#import "SDMSplashViewController.h"
#import <Masonry/Masonry.h>
#import <SmartdigimktSDK/SDMSplashAd.h>
#import "SDMDemoUIHeader.h"
#import <SmartdigimktSDK/SDMBaseAd.h>
#import <SmartdigimktSDK/SDMAPI.h>
#import "SDMTestMutilDefine.h"
#import "SDMMenuView.h"

@interface SDMSplashViewController () <SDMPubSplashDelegate, SDMPubSplashLoadingDelegate>

@property (nonatomic, strong) SDMMenuView *menuView;
@property (nonatomic, strong) UIButton *loadBtn;
@property (nonatomic, strong) UIButton *isReadyBtn;
@property (nonatomic, strong) UIButton *showBtn;
@property (nonatomic, strong) UIButton *destroyBtn;
@property (nonatomic, strong) UIButton *allLoadBtn;
@property (nonatomic, strong) UIButton *multipleLoadMoreBtn;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSMutableDictionary *selectSubMenuInfo;
@property (nonatomic, strong) NSMutableArray *selectSubMenuIndexArr;
@property (nonatomic, copy) NSString *currentSubMenuKey;
@property (nonatomic, strong) NSDate *loadSplashDate;
@property (nonatomic, strong) NSDate *showSplashDate;
@property (nonatomic, strong) UIWindow *splashWindow;
@property (nonatomic, strong) UIWindow *mainShowWindow;
@property (nonatomic, strong) UIButton *skipButton;

@end

@implementation SDMSplashViewController

#pragma mark - 生命周期
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
}

#pragma mark - 广告位
- (NSString *)getPlacementID {
    return @"b5fa25036683d2";
}

#pragma mark - UI Layout
- (void)setupUI {
    self.view.backgroundColor = kRGB(245, 245, 245);
    self.title = @"Splash";
    
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
    
    [self.menuView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenW - kScaleW(52));
        make.height.mas_equalTo(kScaleW(242));
        make.top.equalTo(self.view.mas_top).offset(kNavigationBarHeight + kScaleW(20));
        make.centerX.equalTo(self.view.mas_centerX);
    }];

    // 修改loadBtn的顶部约束
    [self.loadBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.menuView.mas_bottom).offset(kScaleW(20));
        make.width.mas_equalTo(kScreenW - kScaleW(52));
        make.height.mas_equalTo(kScaleW(76));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    [self.isReadyBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loadBtn.mas_bottom).offset(kScaleW(20));
        make.width.mas_equalTo(kScreenW - kScaleW(52));
        make.height.mas_equalTo(kScaleW(76));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    [self.showBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.isReadyBtn.mas_bottom).offset(kScaleW(20));
        make.width.mas_equalTo(kScreenW - kScaleW(52));
        make.height.mas_equalTo(kScaleW(76));
        make.centerX.equalTo(self.view.mas_centerX);
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
- (UIInterfaceOrientation)currentInterfaceOrientation {
    if (@available(iOS 13.0, *)) {
        UIWindow *firstWindow = [[[UIApplication sharedApplication] windows] firstObject];
        if (firstWindow == nil) { return UIInterfaceOrientationUnknown; }
        
        UIWindowScene *windowScene = firstWindow.windowScene;
        if (windowScene == nil){ return UIInterfaceOrientationUnknown; }
        
        return windowScene.interfaceOrientation;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return UIApplication.sharedApplication.statusBarOrientation;
#pragma clang diagnostic pop
    }
}

#pragma mark - 广告 加载 展示
- (void)multipleLoad {
    self.loadSplashDate = [NSDate date];
    UIInterfaceOrientation deviceOrientaion = [self currentInterfaceOrientation];
    BOOL landscape = UIInterfaceOrientationIsLandscape(deviceOrientaion);
    
    
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:@(KSDMDemoSplashTimeOut) forKey:@""];
    
    [mutableDict setValue:@"TopOn--1" forKey:@"adLoad"];
    [mutableDict setValue:@"TopOn--2" forKey:@"adGap"];
    [mutableDict setValue:@"TopOn--3" forKey:@"pageId"];
    [mutableDict setValue:@"TopOn--4" forKey:@"sectionId"];
    [mutableDict setValue:@"TopOn--5" forKey:@"custom"];
    
    SDMSplashAd *adInfo = nil;
    if ([self.currentSubMenuKey isEqualToString:@"add"]) {
        adInfo = [[SDMSplashAd alloc] initAdWithPlacementId:[self getPlacementID]];
        
        NSString *key = [NSString stringWithFormat:@"%p", adInfo];
        _selectSubMenuInfo[key] = adInfo;
        [_selectSubMenuIndexArr addObject:key];
    } else {
        adInfo = self.selectSubMenuInfo[self.currentSubMenuKey];
    }
    
    adInfo.extra = mutableDict;
    adInfo.loadDelegate = self;
    adInfo.showDelegate = self;
    adInfo.fetchAdTimeout = KSDMDemoSplashTimeOut;
    [adInfo load];
    [self resetSubMenuList];
}

- (void)mutilCheckAd {
    NSMutableString *logString = [NSMutableString stringWithString:@"ADX广告状态:\n"];
    for (NSString *key in self.selectSubMenuIndexArr) {
        if ([key isEqualToString:@"add"]) {
            continue;
        }
        SDMSplashAd *adInfo = self.selectSubMenuInfo[key];
        if ([adInfo isKindOfClass:[SDMSplashAd class]]) {
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
    
    self.showSplashDate = [NSDate date];
    UIWindow *mainWindow = nil;
    if ( @available(iOS 13.0, *) ) {
        mainWindow = [UIApplication sharedApplication].windows.firstObject;
        [mainWindow makeKeyWindow];
    }else {
        mainWindow = [UIApplication sharedApplication].keyWindow;
    }
    self.mainShowWindow = mainWindow;
    UIWindow *showWindow = self.mainShowWindow;
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:@20000 forKey:kSDMSplashExtraCountdownKey];
    if (kSDMDemoSplashSkipBtnSwitch) {
        // 开发者自定义跳过按钮
        self.skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.skipButton.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
        self.skipButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 80 - 20, 50, 80, 21);
        self.skipButton.layer.cornerRadius = 10.5;
        self.skipButton.titleLabel.textColor = [UIColor greenColor];
        self.skipButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [mutableDict setValue:self.skipButton forKey:kSDMSplashExtraCustomSkipButtonKey];
    }
    
    [mutableDict setValue:@1000 forKey:kSDMSplashExtraCountdownIntervalKey];
        
    UIViewController *inViewController = [self getCurrentViewControllerWithWindow:showWindow];
//    NSArray *splashAdArray = [[ATAdManager sharedManager] getSplashValidAdsForPlacementID:self.currentPlacementIDInfoModel.placementIDString];
//    NSDictionary *splashAdDic = splashAdArray.firstObject;
    SDMSplashAd *adInfo = self.selectSubMenuInfo[self.currentSubMenuKey];
    if (!adInfo) {
        [self showLog:@"查询异常，退出"];
        return;
    }
    if (SDMMultipleDemoSendWin) {
        [self sendWin:adInfo];
    }
    if (SDMSplashShowContainer) {
        UIInterfaceOrientation deviceOrientaion = [self currentInterfaceOrientation];
        BOOL landscape = UIInterfaceOrientationIsLandscape(deviceOrientaion);
        UILabel *label = nil;
        label = [[UILabel alloc] initWithFrame:CGRectMake(.0f, .0f, landscape ? 120 : UIScreen.mainScreen.bounds.size.width, landscape ? UIScreen.mainScreen.bounds.size.height : 100.0f)];
        label.text = @"Container";
        label.font = [UIFont systemFontOfSize:60];
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor redColor];
        label.textAlignment = NSTextAlignmentCenter;
        // 测试 containerView 点击方法 主要是针对GM
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(containerViewTapped)];
        [label addGestureRecognizer:tapGesture];
        
        UIButton *containerViewBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        containerViewBtn.backgroundColor = [UIColor blueColor];
        [containerViewBtn setTitle:@"测试点击btn" forState:UIControlStateNormal];
        [containerViewBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [containerViewBtn addTarget:self action:@selector(containerViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [label addSubview:containerViewBtn];
        [containerViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@100);
            make.height.equalTo(@60);
            make.centerX.equalTo(label.mas_centerX);
            make.centerY.equalTo(label.mas_centerY);
        }];
        adInfo.containerView = label;
    }
    
    adInfo.window = showWindow;
    adInfo.showViewController = inViewController;
    adInfo.extra = mutableDict;
    [adInfo showAd];
}

- (void)multipleLoadMoreAd {
    self.currentSubMenuKey = @"add";
    for (int i = 0; i < SDMMultipleDemoSynLoadCountKey; i++) {
        [self multipleLoad];
    }
}

- (void)destroyAd {
    SDMSplashAd *adInfo = nil;
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
    __weak typeof(self) weakSelf = self;
    [_selectSubMenuIndexArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[NSString class]] || [obj isEqualToString:@"add"]) {
            return;
        }
        __strong typeof(weakSelf) strongSelf = weakSelf;
        SDMSplashAd *adInfo = strongSelf.selectSubMenuInfo[obj];
        if ([adInfo isKindOfClass:[SDMSplashAd class]]) {
            [adInfo load];
        }
    }];
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

#pragma mark - SDMPublicLoadingDelegate

/// Callback when the successful loading of the ad
- (void)onAdLoaded:(SDMBaseAd *)item {
    BOOL ready = [item isReady];
    
    SDMAd *ad = [item getSDMAd];
    double ecpm = [ad.ecpmInfo currentEcpm:SDMAdCurrencyTypeCNY];
    double ecpmUSD = [ad.ecpmInfo currentEcpm:SDMAdCurrencyTypeUSD];
    
    if (ecpmUSD < kSDMDemoBidPrice) {
        [self showLog:[NSString stringWithFormat:@"finish时获取价格低于底价，当前广告ecpm=%f USD", ecpmUSD]];
        [self sendLoss:item reason:SDMLossToAuctionFloor];
    } else {
        [self showLog:[NSString stringWithFormat:@"didFinishLoadingADWithPlacementID:%@--isReady:%@ \n  ", item.placementId, ready ? @"YES":@"NO" ]];
    }
}

/// Callback of ad loading failure
- (void)onAdLoadFail:(SDMBaseAd *)item
               error:(NSError*)error {
    [self showLog:[NSString stringWithFormat:@"didFailToLoadADXWithPlacementID:%@ errorCode:%ld error=%@ \n  ", item.placementId, (long)error.code, error.domain ]];
}

/// @param isTimeout whether timeout
- (void)onAdLoaded:(SDMSplashAd *)item isTimeout:(BOOL)isTimeout {
    NSLog(@"开屏成功:%@----是否超时:%d", item.placementId, isTimeout);
    NSLog(@"开屏didFinishLoadingSplashADWithPlacementID:");
    [self showLog:[NSString stringWithFormat:@"didFinishLoadingSplashADWithPlacementID:%@----是否超时:%d", item.placementId, isTimeout]];
}

/// Splash ad loading timeout callback
- (void)onAdLoadTimeout:(SDMSplashAd *)item {
    NSLog(@"开屏超时:%@", item.placementId);
    NSLog(@"开屏didTimeoutLoadingSplashADWithPlacementID:");
    [self showLog:[NSString stringWithFormat:@"didTimeoutLoadingSplashADWithPlacementID:%@", item.placementId]];
}


#pragma mark -  SDMPubSplashDelegate

/// Splash ad displayed successfully
- (void)onAdShow:(SDMSplashAd *)item {
    SDMAd *ad = [item getSDMAd];
    double ecpm = [ad.ecpmInfo currentEcpm:SDMAdCurrencyTypeCNY];
    double reven = [ad.ecpmInfo currentRevenueEcpm:SDMAdCurrencyTypeCNY];
    double ecpmUSD = [ad.ecpmInfo currentEcpm:SDMAdCurrencyTypeUSD];
    double revenUSD = [ad.ecpmInfo currentRevenueEcpm:SDMAdCurrencyTypeUSD];
    double rate = [[ad.ecpmInfo valueForKey:@"rateDecimal"] doubleValue];
    [self showLog:[NSString stringWithFormat:@"CNY reven ecpm:%f reven=%f, rate=%f", ecpm, reven, rate]];
    [self showLog:[NSString stringWithFormat:@"USD reven ecpm:%f reven=%f, rate=%f", ecpmUSD, revenUSD, rate]];
    [self showLog:[NSString stringWithFormat:@"splashDidShowForPlacementID:%@ ad:%p extra:%@ \n  ", item.placementId, item, @""]];
}

/// Splash ad click
- (void)onAdClick:(SDMSplashAd *)item extra:(nullable NSDictionary *)extra {
    [self showLog:[NSString stringWithFormat:@"splashDidClickForPlacementID:%@ ad:%p extra:%@ \n  ", item.placementId, item, @""]];
}

/// Splash ad closed
- (void)onAdClose:(SDMSplashAd *)item extra:(nullable NSDictionary *)extra {
    [self showLog:[NSString stringWithFormat:@"splashDidCloseForPlacementID:%@ ad:%p extra:%@ \n  ", item.placementId, item, @""]];
}

/// Splash ad will closed
- (void)splashWillClose:(SDMSplashAd *)item {
    [self showLog:[NSString stringWithFormat:@"splashWillCloseForPlacementID:%@ ad:%p extra:%@ \n  ", item.placementId, item, @"" ]];
}


///  Whether the click jump of Splash ad is in the form of Deeplink
- (void)onDeeplinkCallback:(SDMSplashAd *)item
                    result:(BOOL)success {
    [self showLog:[NSString stringWithFormat:@"splashDeepLinkOrJumpForPlacementID:placementID:%@ with ad:%p extra: %@, success:%@ \n  ", item.placementId,item.adSourceExtra, @"", success ? @"YES" : @"NO" ]];
}

///  Splash ad closes details page
- (void)splashDetailDidClosed:(SDMSplashAd *)item {
    [self showLog:[NSString stringWithFormat:@"splashDetailDidClosedForPlacementID:%@ ad:%p extra:%@ \n  ", item.placementId, item, @"" ]];
}

///  Splash ad closes details show
- (void)splashDetailWillShow:(SDMSplashAd *)item {
    [self showLog:[NSString stringWithFormat:@"splashDetailWillShowForPlacementID:%@ ad:%p extra:%@ \n  ", item.placementId, item, @"" ]];
}

/// This callback is triggered when the skip button is customized.
- (void)splashCountdownTime:(SDMSplashAd *)item
                  countdown:(NSInteger)countdown {
    [self showLog:[NSString stringWithFormat:@"splashCountdownTime:%ld forPlacementID:%@ ad:%p \n  ", countdown, item.placementId,item]];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *title = [NSString stringWithFormat:@"%lds",countdown/1000];
        if (countdown/1000) {
            [self.skipButton setTitle:title forState:UIControlStateNormal];
        }
    });
}

- (void)onAdShowFail:(SDMSplashAd *)item
               error:(NSError *)error {
    [self showLog:[NSString stringWithFormat:@"splashDidShowFailedForPlacementID:%@ ad:%p error:%@ extra:%@ \n  ", item.placementId, item, error, @"" ]];
}

#pragma mark - SDMPubSplashLoadingDelegate
/// Callback when the splash ad is loaded successfully
/// @param isTimeout whether timeout
- (void)splashDidFinishLoadingSplashAd:(SDMSplashAd *)item
                             isTimeout:(BOOL)isTimeout {
    [self showLog:[NSString stringWithFormat:@"didFinishLoadingSplashADWithPlacementID:%@----是否超时:%d ad:%p \n  ", item.placementId, isTimeout, item]];
}

/// Splash ad loading timeout callback
- (void)splashDidTimeoutLoadingSplashAd:(SDMSplashAd *)item {
    [self showLog:[NSString stringWithFormat:@"didTimeoutLoadingSplashADWithPlacementID:%@ ad:%p \n  ", item.placementId, item]];
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

- (double)getGapDate:(NSDate *)loadDate {
    double date1 = [loadDate timeIntervalSince1970] * 1000;
    double date2 = [[NSDate date] timeIntervalSince1970] * 1000;
    double date = date2 - date1;
    return date * 0.001;
}

- (void)containerViewTapped {
    NSLog(@"点击了containerView");
}

- (void)containerViewBtnClick:(UIButton *)btn {
    NSLog(@"点击了containerView 中的button");
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
    NSLog(@"SDMSplashViewController -- 发起竞胜");
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
    NSLog(@"splash -- 发起竞败");
    [ad notifyLoss:lossInfo];
}

- (void)sendLoss:(SDMBaseAd *)ad {
    if (!SDMMultipleDemoSendLoss) {
        return;
    }
    [self sendLoss:ad reason:SDMLossToExpire];
}

#pragma mark - lazy
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
        [self updateButtonUI:_isReadyBtn title:@"is Ready"];
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

@end
