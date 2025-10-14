//
//  SDMPerformanceViewController+Timer.m
//  AnyThinkSDKDemo
//
//  Created by GUO PENG on 2022/4/24.
//  Copyright © 2022 AnyThink. All rights reserved.
//

#import "SDMPerformanceViewController+Timer.h"
#import "SDMPerformanceViewController+LoadShowRemove.h"

@class SDMOfferBaseViewController, SDMOfferFullScreenPictureViewController, SDMOfferHalfScreenPictureViewController, SDMOfferHalfScreenVideoViewController, SDMOfferSplashViewController, SDMOfferVideoViewController, SDMRewardedVideoRenderViewController;


@implementation SDMPerformanceViewController (Timer)

#pragma mark - Timer
- (void)launchTimer{
    self.checkLoadStatusTimer = [ZYGCDTimer timerWithTimeInterval:10 target:self selector:@selector(checkLoadStatus) userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()];
}

- (void)checkLoadStatus {
    
    [self loadSplashIfNeeded];
    [self loadInterIfNeeded];
    [self loadRewardIfNeeded];
    [self loadBannerIfNeeded];
    [self loadNativeIfNeeded];
    
    
    if (self.flag == NSIntegerMax - 1) {
        self.flag = 0;
    }
    self.flag++;
    NSInteger type = self.flag % 3;
    switch (type)  {
        case 0:
//            [self showRewardIfNeeded];
            break;
        case 1:
//            [self showInterAdIfNeeded];
            break;
        case 2:
            [self showSplashIfNeeded];
            break;
        default:
            [self showSplashIfNeeded];
            break;
    }
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        UIViewController *vc = [[self class] currentViewController];
//        if (self.isNormalFullFormatShow && [self isAdxVC:vc]) {
//            [[self class] safePopViewController:vc];
////            [vc.navigationController popViewControllerAnimated:NO];
//            self.isNormalFullFormatShow = NO;
//        }
//    });
}

- (void)loadSplashIfNeeded {
    BOOL splashReady = [self.splashAd isReady];
    if (!splashReady) {
        [self loadAllSplashAd];
    }
}

- (void)loadRewardIfNeeded {
    BOOL rewardReady = [self.rewardAd isReady];
    if (!rewardReady) {
        [self loadAllRewardVideoAd];
    }
}

- (void)loadInterIfNeeded {
    BOOL interReady = [self.interAd isReady];
    if (!interReady) {
        [self loadAllInterstitialAd];
    }
}

- (void)loadNativeIfNeeded {
    BOOL nativeReady = [self.nativeAd isReady];
    if (!nativeReady) {
        [self loadAllNativeAd];
    }
}

- (void)loadBannerIfNeeded {
    BOOL bannerReady =  [self.bannerAd isAdReady];
    if (!bannerReady) {
        [self loadAllBannerAd];
    }
}

- (void)showBannerAdIfNeeded {
    BOOL bannerReady =  [self.bannerAd isAdReady];
    if (bannerReady) {
        [self removeBanner];
        [self showBannerAd];
    }
}

- (void)showNativeAdIfNeeded {
    BOOL nativeReady = [self.nativeAd isReady];
    if (nativeReady) {
        if (self.isNormalFullFormatShow) {
            return;
        }
        [self removeNative];
        [self showNativeAd];
    }
}

- (void)showRewardIfNeeded {
    BOOL rewardReady = [self.rewardAd isReady];
    if (rewardReady) {
        if (self.isNormalFullFormatShow) {
            return;
        }
        [self showRewardAd];
    }
}

- (void)showInterAdIfNeeded {
    BOOL interReady = [self.interAd isReady];
    if (interReady) {
        if (self.isNormalFullFormatShow) {
            return;
        }
        [self showInterAd];
    }
}

- (void)showSplashIfNeeded {
    BOOL splashReady = [self.splashAd isReady];
    if (splashReady) {
        if (self.isNormalFullFormatShow) {
            return;
        }
        [self showSplahAd];
    }
}

+ (UIViewController *)currentViewController {
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self findTopViewController:rootVC];
}

+ (UIViewController *)findTopViewController:(UIViewController *)vc {
    if (vc.presentedViewController) {
        return [self findTopViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)vc;
        if (nav.viewControllers.count > 0) {
            return [self findTopViewController:nav.topViewController];
        }
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *)vc;
        if (tab.viewControllers.count > 0) {
            return [self findTopViewController:tab.selectedViewController];
        }
    }
    return vc;
}


- (BOOL)isAdxVC:(UIViewController *)vc {
    Class vc1 = NSClassFromString(@"SDMOfferBaseViewController");
    Class vc2 = NSClassFromString(@"SDMOfferFullScreenPictureViewController");
    Class vc3 = NSClassFromString(@"SDMOfferHalfScreenPictureViewController");
    Class vc4 = NSClassFromString(@"SDMOfferHalfScreenVideoViewController");
    Class vc5 = NSClassFromString(@"SDMOfferSplashViewController");
    Class vc6 = NSClassFromString(@"SDMOfferVideoViewController");
    Class vc7 = NSClassFromString(@"SDMRewardedVideoRenderViewController");
    
    if ([vc isKindOfClass:vc1] ||
        [vc isKindOfClass:vc2] ||
        [vc isKindOfClass:vc3] ||
        [vc isKindOfClass:vc4] ||
        [vc isKindOfClass:vc5] ||
        [vc isKindOfClass:vc6] ||
        [vc isKindOfClass:vc7]) {
        return YES;
    }
    return NO;
}

+ (void)safePopViewController:(UIViewController *)vc {
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self safePopViewController:vc];
        });
        return;
    }
    
    if (vc.navigationController) {
        // 导航栈中有多个VC时才允许弹出
        if (vc.navigationController.viewControllers.count > 1) {
            [vc.navigationController popViewControllerAnimated:YES];
        } else {
            NSLog(@"⚠️ 根视图控制器不可弹出");
        }
    } else if (vc.presentingViewController) {
        // 处理模态呈现的VC
        [vc dismissViewControllerAnimated:YES completion:nil];
    } else {
        NSLog(@"⚠️ 无法退出非导航栈/非模态呈现的视图控制器: %@", vc);
    }
}

+ (void)forceExitCurrentViewController {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *topVC = [self currentViewController];
        
        if ([topVC isBeingPresented] || [topVC isMovingToParentViewController]) {
            NSLog(@"⚠️ 正在呈现过程中，延迟退出");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),
                           dispatch_get_main_queue(), ^{
                [self forceExitCurrentViewController];
            });
            return;
        }
        
        if (topVC.navigationController) {
            // 处理嵌套导航栈
            if (topVC.navigationController.viewControllers.count > 1) {
                [topVC.navigationController popViewControllerAnimated:YES];
            } else if (topVC.presentingViewController) {
                [topVC dismissViewControllerAnimated:YES completion:nil];
            }
        } else if (topVC.presentingViewController) {
            [topVC dismissViewControllerAnimated:YES completion:nil];
        }
    });
}

@end
