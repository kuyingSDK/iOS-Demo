//
//  SDMTestMutilDefine.h
//  AnyThinkSDKDemo
//
//  Created by xuejingwei on 2025/6/16.
//  Copyright © 2025 AnyThink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SDMTestMutilDefine <NSObject>
/// 多次加载数量 《multiple load more ad》按钮触发load次数
#define SDMMultipleDemoSynLoadCountKey 3
/// 是否使用新api发送loss/win
#define SDMMultipleDemoNormalUseObjectSendKey YES
/// 原生样式api合并开关，控制原生样式获取素材和展示视图顺序
#define SDMMultipleDemoNativeApiOperateKey YES

#define SDMMultipleDemoSendWin YES

#define SDMMultipleDemoSendLoss YES

#define SDMSplashShowContainer NO

/// 开屏超时回调时长
#define KSDMDemoSplashTimeOut 1

// 开屏自定义按钮开关
#define kSDMDemoSplashSkipBtnSwitch NO

/// banner自动刷新强制开启
#define kSDMDemoBannerAutoRefreshSwitch YES;

#define kSDMDemoBidPrice 0

@end

NS_ASSUME_NONNULL_END
