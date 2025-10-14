//
//  SDMDemoUIHeader.h
//  SmartdigimktSDKDemo
//
//  Created by xuejingwei on 2025/8/18.
//

#ifndef SDMDemoUIHeader_h
#define SDMDemoUIHeader_h

// 刘海屏判断
#define IsiPhoneX ({ \
    BOOL iPhoneX = NO; \
    if (@available(iOS 11.0, *)) { \
        if ([UIApplication sharedApplication].windows[0].safeAreaInsets.bottom > 0) { \
            iPhoneX = YES; \
        } \
    } \
    iPhoneX; \
})
// 状态栏高度
#define kStatusBarHeight [[UIApplication sharedApplication]statusBarFrame].size.height
// 导航栏高度
//#define kNavigationBarHeight ([[UIApplication sharedApplication]statusBarFrame].size.height + 44)
#define kNavigationBarHeight ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown ? ([[UIApplication sharedApplication]statusBarFrame].size.height + 44) : ([[UIApplication sharedApplication]statusBarFrame].size.height - 4))
// 屏幕高度
//#define kScreenH UIScreen.mainScreen.bounds.size.height
#define kScreenH ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown ? UIScreen.mainScreen.bounds.size.height : UIScreen.mainScreen.bounds.size.width)
// 屏幕宽度度
//#define kScreenW UIScreen.mainScreen.bounds.size.width
#define kScreenW ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown ? UIScreen.mainScreen.bounds.size.width : UIScreen.mainScreen.bounds.size.height)
// 适配宽度
//#define kScaleW(x) UIScreen.mainScreen.bounds.size.width / 750 * x
#define kScaleW(x) (([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown) ? (UIScreen.mainScreen.bounds.size.width / 750 * x) : (UIScreen.mainScreen.bounds.size.height / 750 * x))
// rbg颜色
#define kRGB(r, g, b) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
// 判断横竖屏
#define IsPortrait ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown)
// 底部安全区域
#define kButtonSafeHeight (IsiPhoneX ? 34.0f : .0f)

#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]

#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#endif /* SDMDemoUIHeader_h */
