//
//  AppDelegate.m
//  iOSDemo
//
//  Created by ltz on 2025/1/5.
//

#import "AppDelegate.h"

#import <SmartdigimktSDK/SmartdigimktSDK.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

#import "BaseNavigationController.h"
#import "PPVC.h"
 

@interface AppDelegate ()

@end

@implementation AppDelegate
 
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //开启Demo日志打印
    DemoLogAccess(1);
 
    //布局demoUI,无需接入
    [self setupDemoUI];
    
    //Demo首次启动展示隐私政策弹窗，可选实际是否需要根据您的产品需求来决定是否显示，不必接入这个方法
    [PPVC showSDKManagementWithAgreementCallback:^{
 
        // 日志开关
        [SDMAPI setLogEnabled:YES];
        
        //开启日志开关后，设置测试模式IDFA，填入你的测试设备IDFA即可开启
//        [[SDMSDKGlobalSetting sharedManager] setHeaderBiddingTestModeDeviceID:@"xxx"];
        
        //初始化SDK，必须接入
        NSError * initError = nil;
        [[SDMAPI sharedInstance] startWithAppID:kAppID appKey:kAppKey error:&initError];
        if (initError) {
            //初始化失败
            NSLog(@"init failed : %@",initError);
        }
        
        // SDK各种配置，可选接入
    //    // 关闭摇一摇
    //    [[SDMSDKGlobalSetting sharedManager] setDenySensor:NO];
    //    // 屏蔽SDK收集数据的方式
    //    [SDMDeviceInfoList sharedInstance].os_vc = @"";
    //    [SDMDeviceInfoList sharedInstance].os_vn = @"";
    //    ...其他不一一列举，前往SDMDeviceInfoList.h即可查看
        
    //    // GDPR
    //    [[SDMAPI sharedInstance] setAdDataConsentSet:SDMDataConsentSetPersonalized];
    //    // 个性化
    //    [[SDMAPI sharedInstance] setPersonalizedAdState:SDMPersonalizedAdStateType];
    //
    //    //微信配置，可选介入
    //    [[SDMSDKGlobalSetting sharedManager] setWeChatAppID:@"wxf871eb7257796a42" universalLink:@"https://test-dsp.rayjump.com/sdkSample/"];
         
    }];
      
    return YES;
}

#pragma mark - lifecycle
- (void)applicationDidBecomeActive:(UIApplication *)application {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 14, *)) {
            //申请ATT权限
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            }];
        } else {
            // Fallback on earlier versions
        }
    });
}
  
#pragma mark - Demo UI 可忽略
- (void)setupDemoUI {
    self.window = [UIWindow new];
    self.window.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]; // kHexColor(0xffffff)
    if (@available(iOS 13.0, *)) {
       self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
 
    BaseNavigationController * nav = [[BaseNavigationController alloc] initWithRootViewController:[HomeViewController new]];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}

@end
