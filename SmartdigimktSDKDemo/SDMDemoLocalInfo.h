//
//  SDMDemoLocalInfo.h
//  SmartdigimktSDKDemo
//
//  Created by xuejingwei on 2025/8/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDMDemoLocalInfo : NSObject

@property (nonatomic, copy) NSString *idfa;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
