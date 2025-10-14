//
//  AppDelegate.m
//  SmartdigimktSDKDemo
//
//  Created by xuejingwei on 2025/7/30.
//

#import "AppDelegate.h"
#import <SmartdigimktSDK/SDMAPI.h>
#import <SmartdigimktSDK/SDMRewardedVideoAd.h>
#import <Bugly/Bugly.h>
#import <SmartdigimktSDK/SDMSDKGlobalSetting.h>

@interface AppDelegate ()

@property (nonatomic, strong) id ad;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Bugly startWithAppId:@"837588b78a"];
    BuglyConfig *config = [[BuglyConfig alloc] init];
    config.blockMonitorEnable = YES;
    [Bugly startWithAppId:@"837588b78a" config:config];
    
    [[SDMSDKGlobalSetting sharedManager] setWeChatAppID:@"wxf871eb7257796a42" universalLink:@"https://test-dsp.rayjump.com/sdkSample/"];
    
    [SDMAPI setLogEnabled:YES];
    return YES;
}

#pragma mark - UISceneSession lifecycle

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
