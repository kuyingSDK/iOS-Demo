//
//  SDMDemoLocalInfo.m
//  SmartdigimktSDKDemo
//
//  Created by xuejingwei on 2025/8/26.
//

#import "SDMDemoLocalInfo.h"

@implementation SDMDemoLocalInfo

+ (instancetype)sharedInstance {
    static SDMDemoLocalInfo *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SDMDemoLocalInfo alloc] init];
        sharedInstance.idfa = @"";
    });
    return sharedInstance;
}

@end
