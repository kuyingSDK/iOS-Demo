//
//  ViewController.m
//  SmartdigimktSDKDemo
//
//  Created by xuejingwei on 2025/7/30.
//

#import "ViewController.h"
#import "SDMDemoDebugHeader.h"
#import <SmartdigimktSDK/SDMAPI.h>
#import <SmartdigimktSDK/SDMRewardedVideoAd.h>
#import <Masonry/Masonry.h>
#import "SDMDemoUIHeader.h"
#import "SDMHomeTableViewCell.h"
#import <AppTrackingTransparency/ATTrackingManager.h>
#import <AdSupport/AdSupport.h>
#import <SmartdigimktSDK/SDMSDKGlobalSetting.h>
#import <SmartdigimktSDK/SDMDebuggerConfig.h>
#import <SmartdigimktSDK/SDMAdLogger.h>
#import <SmartdigimktSDK/SDMSDKGlobalSetting.h>
#import "SDMDemoLocalInfo.h"
#import "SDMDemoDebugHeader.h"
#import <SmartdigimktSDK/SDMDeviceInfoList.h>

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startDemo];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (void)startDemo {
    NSError *error = nil;
    [[SDMAPI sharedInstance] startWithAppID:kTopOnAppID appKey:kTopOnAppKey error:&error];
    NSLog(@"🔥--appstart-----error:%@", error);
    [SDMAdLogger sharedManager].logCacheEnabled = YES;
//    // GDPR
//    [[SDMAPI sharedInstance] setAdDataConsentSet:SDMDataConsentSetPersonalized];
//    // 个性化
//    [[SDMAPI sharedInstance] setPersonalizedAdState:SDMPersonalizedAdStateType];
    
    [self setupData];
    [self setupUI];
    [[SDMSDKGlobalSetting sharedManager] setLocationLongitude:125.0 dimension:555.0];
//    // 关闭摇一摇
//    [[SDMSDKGlobalSetting sharedManager] setDenySensor:NO];
//    // 屏蔽参数
//    [SDMDeviceInfoList sharedInstance].os_vc = @"";
//    [SDMDeviceInfoList sharedInstance].os_vn = @"";
//    
}

- (void)setupData {
    self.dataSource = @[
        @{
            @"image":@"rewarded video",
            @"title":@"Reward Video",
            @"class":@"SDMRewardVideoViewController",
            @"des":@"Users can engage with a video ad in exchange for in-app rewards.",
        },
        @{
            @"image":@"interstitial",
            @"title":@"Interstitial",
            @"class":@"SDMInterstitialViewController",
            @"des":@"Include Interstitial and FullScreen.Appears at natural breaks or transition points.",
        },
        @{
            @"image":@"splash",
            @"title":@"Splash",
            @"class":@"SDMSplashViewController",
            @"des":@"Displayed immediately after the application is launched.",
        },
        @{
            @"image":@"banner",
            @"title":@"Banner",
            @"class":@"SDMBannerViewController",
            @"des":@"Flexible formats which could appear at the top, middle or bottom of your app.",
        },
        @{
            @"image":@"native",
            @"title":@"Native",
            @"class":@"SDMNativeMainViewController",
            @"des":@"Include Native,Vertical Draw Video and Pre-roll Ads.Most compatible with your native app code for video ads and graphic ads.",
        },
        @{
            @"image":@"rewarded video",
            @"title":@"性能测试",
            @"class":@"SDMPerformanceViewController",
            @"des":@"Performance scene",
        }
    ];
}

- (void)setupUI {
    [self setupNav];
    
    [self.view addSubview:self.tableView];
//    self.tableView.tableFooterView = [[ATHomeFootView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScaleW(150))];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)setupNav {
    UIView * navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
   
    UIImageView * logoIV = [[ UIImageView alloc]initWithImage:[UIImage imageNamed:@"topon_logo"]];
    logoIV.frame = CGRectMake(0, 0, 40, 40);
    [navView addSubview:logoIV];

    UILabel * title = [[UILabel alloc]initWithFrame:CGRectZero];
    title.frame = CGRectMake(44+5, 0, 150, 40);
    title.font = [UIFont boldSystemFontOfSize:17];
    title.text = @"SmartdigimktSDK Demo";
    [navView addSubview:title];
    self.navigationItem.titleView = navView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat hhh = kScaleW(238 + 10);
    return hhh;
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SDMHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SDMHomeTableViewCell idString]];
    cell.backgroundColor = kRGB(245, 245, 245);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = self.dataSource[indexPath.row];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", dic[@"title"]];
    cell.subTitleLabel.text = [NSString stringWithFormat:@"%@", dic[@"des"]];
    cell.logoImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", dic[@"image"]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataSource[indexPath.row];
    NSString *classString = [NSString stringWithFormat:@"%@", dic[@"class"]];
    Class class = NSClassFromString(classString);
    UIViewController *con = [class new];
    [self.navigationController pushViewController:con animated:YES];
}

#pragma mark - lazy
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        [_tableView registerClass:[SDMHomeTableViewCell class] forCellReuseIdentifier:[SDMHomeTableViewCell idString]];
    }
    return _tableView;
}

@end
