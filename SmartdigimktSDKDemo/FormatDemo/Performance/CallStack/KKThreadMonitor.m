//
//  KKThreadMonitor.m
//  KKMagicHook
//
//  Created by 吴凯凯 on 2020/4/11.
//  Copyright © 2020 吴凯凯. All rights reserved.
//

#import "KKThreadMonitor.h"
#import "KKCallStack.h"
#include <pthread/introspection.h>

#ifndef kk_dispatch_main_async_safe
#define kk_dispatch_main_async_safe(block)\
if (dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label(dispatch_get_main_queue())) {\
    block();\
} else {\
    dispatch_async(dispatch_get_main_queue(), block);\
}
#endif

static pthread_introspection_hook_t old_pthread_introspection_hook_t = NULL;
static int threadCount = 0;
#define KK_THRESHOLD 20
static const int threadIncreaseThreshold = 10;

//线程数量超过40，就会弹窗警告，并且控制台打印所有线程的堆栈；之后阈值每增加5条(45、50、55...)同样警告+打印堆栈；如果线程数量再次少于40条，阈值恢复到40
static int maxThreadCountThreshold = KK_THRESHOLD;
static dispatch_semaphore_t global_semaphore;
static int threadCountIncrease = 0;
static bool isMonitor = false;

@implementation KKThreadMonitor

+ (void)startMonitor
{
    global_semaphore = dispatch_semaphore_create(1);
    dispatch_semaphore_wait(global_semaphore, DISPATCH_TIME_FOREVER);
    mach_msg_type_number_t count;
    thread_act_array_t threads;
    task_threads(mach_task_self(), &threads, &count);
    threadCount = count; //加解锁之间，保证线程的数量不变
    old_pthread_introspection_hook_t = pthread_introspection_hook_install(kk_pthread_introspection_hook_t);
    dispatch_semaphore_signal(global_semaphore);
    
    isMonitor = true;
    kk_dispatch_main_async_safe(^{
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(clearThreadCountIncrease) userInfo:nil repeats:YES];
    });
}
+ (void)clearThreadCountIncrease
{
    threadCountIncrease = 0;
}

void kk_pthread_introspection_hook_t(unsigned int event,
pthread_t thread, void *addr, size_t size)
{
    if (old_pthread_introspection_hook_t) {
        old_pthread_introspection_hook_t(event, thread, addr, size);
    }
    if (event == PTHREAD_INTROSPECTION_THREAD_CREATE) {
        threadCount = threadCount + 1;
        if (isMonitor && (threadCount > maxThreadCountThreshold)) {
            maxThreadCountThreshold += 5;
            kk_Alert_Log_CallStack(false, 0);
        }
        threadCountIncrease = threadCountIncrease + 1;
        if (isMonitor && (threadCountIncrease > threadIncreaseThreshold)) {
            kk_Alert_Log_CallStack(true, threadCountIncrease);
        }
    }
    else if (event == PTHREAD_INTROSPECTION_THREAD_DESTROY){
        threadCount = threadCount - 1;
        if (threadCount < KK_THRESHOLD) {
            maxThreadCountThreshold = KK_THRESHOLD;
        }
        if (threadCountIncrease > 0) {
            threadCountIncrease = threadCountIncrease - 1;
        }
    }
}

void kk_Alert_Log_CallStack(bool isIncreaseLog, int num)
{
    dispatch_semaphore_wait(global_semaphore, DISPATCH_TIME_FOREVER);
    if (isIncreaseLog) {
        printf("\n💥💥💥💥💥一秒钟开启 %d 条线程！💥💥💥💥💥\n", num);
    }
    [KKCallStack callStackWithType:KKCallStackTypeAll];
    dispatch_semaphore_signal(global_semaphore);
}

@end
