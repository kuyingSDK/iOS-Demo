//
//  SDMDemoBaseViewController.m
//  SmartdigimktSDKDemo
//
//  Created by xuejingwei on 2025/8/18.
//

#import "SDMDemoBaseViewController.h"
#import <AppTrackingTransparency/ATTrackingManager.h>
#import <AdSupport/AdSupport.h>
#import <SmartdigimktSDK/SDMSDKGlobalSetting.h>
#import <SmartdigimktSDK/SDMDebuggerConfig.h>
#import "SDMDemoLocalInfo.h"
#import "SDMDemoDebugHeader.h"

@implementation SDMDemoBaseViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *idfa = [SDMDemoLocalInfo sharedInstance].idfa;
        if (!idfa || idfa.length == 0) {
            if (@available(iOS 14, *)) {
                [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                    switch (status) {
                        case ATTrackingManagerAuthorizationStatusAuthorized: {
                            NSString *idfa = [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString;
                            if (kSDMOpenSDKDebugInfoConfig) {
//                                [[SDMSDKGlobalSetting sharedManager] setDebuggerConfig:^(SDMDebuggerConfig * _Nullable debuggerConfig) {
//                                    debuggerConfig.deviceIdfaStr = idfa;
//                                    debuggerConfig.netWorkType = SDMAdNetWorkAdxType;
//                                }];
                                [SDMDemoLocalInfo sharedInstance].idfa = idfa;
                                [[SDMSDKGlobalSetting sharedManager] setHeaderBiddingTestModeDeviceID:idfa];
                            }
                            
                        }
                            break;
                        default:
                            break;
                    }
                }];
            }
        }
    }
    return self;
}

- (UIViewController *)getCurrentViewControllerWithWindow:(UIWindow *)window {
    UIViewController *rootViewController = window.rootViewController;
    if (rootViewController == nil) {
        rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    
    UIViewController *topViewController = rootViewController;
    while (1) {
        if (topViewController.presentedViewController) {
            topViewController = topViewController.presentedViewController;
        } else if([topViewController isKindOfClass:[UITabBarController class]]) {
            topViewController = ((UITabBarController *)topViewController).selectedViewController;
        } else if([topViewController isKindOfClass:[UINavigationController class]]) {
            topViewController = ((UINavigationController *)topViewController).visibleViewController;
        } else {
            break;
        }
    }
    
    if (!topViewController) {
        topViewController = rootViewController;
    }
    
    return topViewController;
}

@end
