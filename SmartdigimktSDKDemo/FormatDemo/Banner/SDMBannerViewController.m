//
//  SDMBannerViewController.m
//  AnyThingSDKDemo
//
//  Created by mac on 2021/12/6.
//

#import "SDMBannerViewController.h"
#import <Masonry/Masonry.h>
#import <SmartdigimktSDK/SDMBannerView.h>
#import "SDMDemoUIHeader.h"
#import <SmartdigimktSDK/SDMBaseAd.h>
#import <SmartdigimktSDK/SDMAPI.h>
#import "SDMTestMutilDefine.h"
#import "SDMMenuView.h"
#import "SDMModelButton.h"
#import <SmartdigimktSDK/SDMAdRequest.h>

@interface SDMBannerViewController () <SDMBannerViewDelegate>

@property (nonatomic, strong) UIView *modelBackView;
@property (nonatomic, strong) UIView *adView;
@property (nonatomic, strong) SDMModelButton *modelButton;
@property (nonatomic, strong) UIView *containerView; // bannerContainerView
@property (nonatomic, strong) UIScrollView *adScrollView;
@property (nonatomic, strong) UIViewController *showViewController;
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
@property (nonatomic, assign) CGSize adSize;
@property (nonatomic, strong) SDMMenuView *menuView;

@end

@implementation SDMBannerViewController
#pragma mark - 生命周期
- (void)dealloc {
//    [self destroyBannerAd];
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:UIApplicationWillResignActiveNotification
//                                                  object:nil];
    NSLog(@"🔥----SDMBannerViewController销毁%@", NSStringFromSelector(_cmd));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectSubMenuInfo = [NSMutableDictionary dictionary];
    _selectSubMenuIndexArr = [NSMutableArray array];
    NSString *key = @"add";
    _selectSubMenuInfo[key] = @"new object";
    [_selectSubMenuIndexArr addObject:key];
    _currentSubMenuKey = key;
    
    [self configurationSDK];
    [self setupUI];
    [self actionUICallback];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - 初始化
- (void)configurationSDK {
    _adSize = CGSizeMake(CGRectGetWidth(self.view.bounds), 250);
}

#pragma mark - 广告位
- (NSString *)getPlacementID {
    return @"b5fa24ff8a7446";
}

#pragma mark - UI Layout
- (void)setupUI {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = kRGB(245, 245, 245);
    self.title = @"Banner";
    
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
        make.top.equalTo(self.menuView.mas_bottom).offset(kScaleW(258));
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(kScaleW(76));
        make.left.equalTo(self.view.mas_left).offset(kScaleW(26));
    }];
    [self.removeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loadBtn.mas_top);
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
    
    CGFloat smallWidth = (kScreenW - kScaleW(26) * 4) / 3;
    
    [self.destroyBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.showBtn.mas_bottom).offset(kScaleW(20));
        make.width.mas_equalTo(smallWidth);
        make.height.mas_equalTo(kScaleW(76));
        make.left.equalTo(self.view.mas_left).offset(kScaleW(26));
    }];
    [self.allLoadBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.showBtn.mas_bottom).offset(kScaleW(20));
        make.width.mas_equalTo(smallWidth);
        make.height.mas_equalTo(kScaleW(76));
        make.left.equalTo(self.destroyBtn.mas_right).offset(kScaleW(26));
    }];
    [self.multipleLoadMoreBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.showBtn.mas_bottom).offset(kScaleW(20));
        make.width.mas_equalTo(smallWidth);
        make.height.mas_equalTo(kScaleW(76));
        make.left.equalTo(self.allLoadBtn.mas_right).offset(kScaleW(26));
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
- (void)removeAdAction {
    if (self.adView && self.adView.superview) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"移除类型" message:@"是否移除并销毁广告" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"仅移除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self.adView removeFromSuperview];
            [self.adScrollView removeFromSuperview];
            [self.containerView removeFromSuperview];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"销毁广告" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self destroyBannerAd];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)destroyBannerAd {
    if (_selectSubMenuIndexArr.count > 1 && ![self.currentSubMenuKey isEqualToString:@"add"]) {
        SDMBannerView *adInfo = self.selectSubMenuInfo[self.currentSubMenuKey];
        [adInfo destroy];
    }
    [self.containerView removeFromSuperview];
    self.containerView = nil;
    [self.adScrollView removeFromSuperview];
    
    [self.adView removeFromSuperview];
    self.adView = nil;
}

- (void)hidenAd {
    if (self.containerView) {
        self.containerView.hidden = !self.containerView.hidden;
    }
}

- (void)reShowAd {
    if (self.adView && !self.adView.superview) {
        [self.adView addSubview:self.containerView];
        [self.view insertSubview:self.adScrollView belowSubview:self.loadBtn];
        [self.adScrollView addSubview:self.adView];
        [self.adView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(_adSize.height));
            make.width.equalTo(@(_adSize.width));
            make.top.equalTo(self.adScrollView).offset(0);
        }];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.adView);
        }];
    }
}

- (void)multipleLoad {
//    SDMFloorPrice *floorPrice = [[SDMFloorPrice alloc] init];
//    floorPrice.value = @"1";
//    floorPrice.type = SDMFloorPriceTypeC;
        
    NSMutableDictionary *extraDic = [@{
        @"banner_ad_size" :[NSValue valueWithCGSize:self.adSize],
//        kATAdLoadingExtraBannerSizeAdjustKey:@NO,
//        kATAdLoadingExtraMediaExtraKey:@"PPPPPP_banner",
        @"adLoad" : @"TopOn--1",
        @"adGap" : @"TopOn--2",
        @"pageId" : @"TopOn--3",
        @"sectionId" : @"TopOn--4",
        @"custom" : @"TopOn--5",
    }  mutableCopy];
    
    SDMBannerView *adInfo = nil;
    if ([self.currentSubMenuKey isEqualToString:@"add"]) {
        adInfo = [[SDMBannerView alloc] initWithFrame:CGRectMake(0, 0, _adSize.width, _adSize.height)];
        adInfo.placementId = [self getPlacementID];
        NSString *key = [NSString stringWithFormat:@"%p", adInfo];
        _selectSubMenuInfo[key] = adInfo;
        [_selectSubMenuIndexArr addObject:key];
    } else {
        adInfo = self.selectSubMenuInfo[self.currentSubMenuKey];
    }
    
//    adInfo.extra = extraDic;
    adInfo.delegate = self;
//    adInfo.floorPrice = floorPrice;
    
    SDMAdRequest *adRequest = [[SDMAdRequest alloc] init];
    adRequest.adWidth = 320;
    adRequest.adHeight = 250;
    adRequest.bannerRefresh = kSDMDemoBannerAutoRefreshSwitch;
    [adInfo loadWithAdRequest:adRequest];
    
    [self resetSubMenuList];
}

- (void)mutilCheckAd {
    NSMutableString *logString = [NSMutableString stringWithString:@"ADX广告状态:\n"];
    for (NSString *key in self.selectSubMenuIndexArr) {
        if ([key isEqualToString:@"add"]) {
            continue;
        }
        SDMBannerView *adInfo = self.selectSubMenuInfo[key];
        if ([adInfo isKindOfClass:[SDMBannerView class]]) {
            BOOL isADXReady = [adInfo isAdReady];
            [logString appendFormat:@"key:%@ → %@\n", key, isADXReady ? @"Ready" : @"Not Ready"];
            if (!isADXReady) {
                [self sendLoss:adInfo];
            }
        }
    }
    [self showLog:logString];
}

- (void)mutilShowAd {
//    [self destroyBannerAd];
    if (_selectSubMenuIndexArr.count <= 1) {
        [self showLog:@"广告列表为空，请先加载广告"];
        return;
    }
    if ([self.currentSubMenuKey isEqualToString:@"add"]) {
        [self showLog:@"先在菜单处选择广告对象"];
        return;
    }
    
    SDMBannerView *adInfo = self.selectSubMenuInfo[self.currentSubMenuKey];
    if (!adInfo) {
        [self showLog:@"查询异常，退出"];
        return;
    }
    if (SDMMultipleDemoSendWin) {
        [self sendWin:adInfo];
    }
    [self showLog:[NSString stringWithFormat:@"bannerContainerView = %p", self.containerView]];
    UIView *bannerView = adInfo;
    [self showLog:[NSString stringWithFormat:@"bannerView = %p", bannerView]];
    if (bannerView != nil) {
        self.containerView = bannerView;
        self.adView = [[UIView alloc] init];
        self.adView.backgroundColor =  randomColor;
        [self reShowAd];
    } else {
        
    }
}

- (void)destroyAd {
    SDMBannerView *adInfo = nil;
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
        SDMBannerView *adInfo = strongSelf.selectSubMenuInfo[obj];
        if ([adInfo isKindOfClass:[SDMBannerView class]]) {
            [adInfo load];
        }
    }];
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

- (void)sendWin:(SDMBannerView *)ad {
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
    NSLog(@"SDMBannerViewController -- 发起竞胜");
    [ad notifyWin:winInfo];
}

- (void)sendLoss:(SDMBannerView *)ad {
    if (!SDMMultipleDemoSendLoss) {
        return;
    }
    [self sendLoss:ad reason:SDMLossToExpire];
}

- (void)sendLoss:(SDMBannerView *)ad reason:(SDMLossReason)reason {
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
    NSLog(@"banner -- 发起竞败");
    [ad notifyLoss:lossInfo];
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
//        [_multipleLoadMoreBtn addTarget:self action:@selector(multipleLoadMoreAd) forControlEvents:UIControlEventTouchUpInside];
    }
    return _multipleLoadMoreBtn;
}

- (UIView *)modelBackView {
    if (!_modelBackView) {
        _modelBackView = [[UIView alloc] init];
        _modelBackView.backgroundColor = [UIColor whiteColor];
        _modelBackView.layer.masksToBounds = YES;
        _modelBackView.layer.cornerRadius = 5;
    }
    return _modelBackView;
}

- (SDMModelButton *)modelButton {
    if (!_modelButton) {
        _modelButton = [[SDMModelButton alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScaleW(532))];
        _modelButton.backgroundColor = [UIColor whiteColor];
        _modelButton.modelLabel.text = @"Banner";
        _modelButton.image.image = [UIImage imageNamed:@"banner"];
    }
    return _modelButton;
}

- (UIScrollView *)adScrollView {
    if (!_adScrollView) {
        _adScrollView = [[UIScrollView alloc]init];
        _adScrollView.frame = CGRectMake(0, kNavigationBarHeight + kScaleW(20), _adSize.width, _adSize.height);
        _adScrollView.contentSize = CGSizeMake(_adSize.width, _adSize.height * 2);
    }
    return _adScrollView;
}

- (UIButton *)removeBtn {
    if (!_removeBtn) {
        _removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self updateButtonUI:_removeBtn title:@"remove ad"];
        [_removeBtn addTarget:self action:@selector(removeAdAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _removeBtn;
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

#pragma mark - SDMBannerViewDelegate

- (void)onAdLoaded:(SDMBannerView *)bannerView {
    BOOL ready = [bannerView isAdReady];
    SDMAd *ad = [bannerView getSDMAd];
    double ecpm = [ad.ecpmInfo currentEcpm:SDMAdCurrencyTypeCNY];
    double ecpmUSD = [ad.ecpmInfo currentEcpm:SDMAdCurrencyTypeUSD];
    if (ecpmUSD < kSDMDemoBidPrice) {
        [self showLog:[NSString stringWithFormat:@"finish时获取价格低于底价，当前广告ecpm=%f USD", ecpmUSD]];
        [self sendLoss:bannerView reason:SDMLossToAuctionFloor];
    } else {
        [self showLog:[NSString stringWithFormat:@"didFinishLoadingADWithPlacementID:%@--isReady:%@ \n", bannerView.placementId, ready ? @"YES":@"NO"]];
    }
}

- (void)onAdLoadFail:(SDMBannerView *)bannerView error:(NSError*)error {
    [self showLog:[NSString stringWithFormat:@"didFailToLoadADXWithPlacementID:%@ errorCode:%ld error=%@ \n", bannerView.placementId, (long)error.code, error.domain]];
}

- (void)onAdShow:(SDMBannerView *)bannerView {
    SDMAd *ad = [bannerView getSDMAd];
    double ecpm = [ad.ecpmInfo currentEcpm:SDMAdCurrencyTypeCNY];
    double reven = [ad.ecpmInfo currentRevenueEcpm:SDMAdCurrencyTypeCNY];
    double ecpmUSD = [ad.ecpmInfo currentEcpm:SDMAdCurrencyTypeUSD];
    double revenUSD = [ad.ecpmInfo currentRevenueEcpm:SDMAdCurrencyTypeUSD];
    double rate = [[ad.ecpmInfo valueForKey:@"rateDecimal"] doubleValue];
    [self showLog:[NSString stringWithFormat:@"CNY reven ecpm:%f reven=%f, rate=%f", ecpm, reven, rate]];
    [self showLog:[NSString stringWithFormat:@"USD reven ecpm:%f reven=%f, rate=%f", ecpmUSD, revenUSD, rate]];
    [self showLog:[NSString stringWithFormat:@"bannerView:didShowAdWithPlacementID:%@ ad:%p \n", bannerView.placementId, bannerView]];
}

- (void)onAdClick:(SDMBannerView *)bannerView extra:(nullable NSDictionary *)extra {
    [self showLog:[NSString stringWithFormat:@"bannerView:didClickWithPlacementID:%@ ad:%p \n", bannerView.placementId, bannerView]];
}

- (void)onAdClose:(SDMBannerView *)bannerView extra:(nullable NSDictionary *)extra {
    [self showLog:[NSString stringWithFormat:@"bannerView:didTapCloseButtonWithPlacementID:%@ ad:%p \n", bannerView.placementId, bannerView]];
    if (bannerView) {
        [bannerView removeFromSuperview];
        [bannerView destroy];
    }
    [self.containerView removeFromSuperview];
    self.containerView = nil;
    [self.adScrollView removeFromSuperview];
}

- (void)onDeeplinkCallback:(SDMBannerView *)bannerView result:(BOOL)success {
    NSLog(@"ATBannerViewController:: didDeepLinkOrJumpForPlacementID:placementID:%@ success:%@", bannerView.placementId, success ? @"YES" : @"NO");
    [self showLog:[NSString stringWithFormat:@"didDeepLinkOrJumpForPlacementID:%@, success:%d", bannerView.placementId, success]];
}

@end
