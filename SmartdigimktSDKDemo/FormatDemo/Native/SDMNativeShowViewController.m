//
//  SDMNativeShowViewController.m
//  AnyThingSDKDemo
//
//  Created by mac on 2021/12/7.
//

#import "SDMNativeShowViewController.h"
#import <Masonry/Masonry.h>
#import <SmartdigimktSDK/SDMNativeAd.h>
#import "SDMDemoUIHeader.h"
#import "SDMTestMutilDefine.h"

@interface SDMNativeShowViewController ()

@property (nonatomic, strong) UIView *adView;

@property (nonatomic, strong) UIButton *voiceChange;

@property (nonatomic, strong) UIButton *voiceProgress;

@property (nonatomic, strong) UIButton *voicePause;

@property (nonatomic, strong) UIButton *voicePlay;

@property (nonatomic, strong) UIButton *testHiddenPlay;

@property(nonatomic, assign) BOOL mute;

@property(nonatomic, strong) SDMNativeAd *nativeAd;

@end

@implementation SDMNativeShowViewController

- (instancetype)initWithAdView:(UIView *)adView nativeAd:(SDMNativeAd *)nativeAd {
    if (self = [super init]) {
        _nativeAd = nativeAd;
        _adView = adView;
    }
    return self;
}

- (void)dealloc {
    if (self.adView && self.adView.superview) {
        [self.adView removeFromSuperview];
    }
//    [self.adView destroyNative];
    self.adView = nil;
    [self.nativeAd destroy];
    NSLog(@"%s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationWillResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLayoutSubviews {
//    UIView *shakeView = [self.adView viewWithTag:999999];
//    
//    [self.adView bringSubviewToFront:shakeView];
//    shakeView.center = CGPointMake(kScreenW * 0.5, 350 * 0.5);
//
//    
//    UIView *silderView = [self.adView viewWithTag:12345678];
//    [self.adView bringSubviewToFront:silderView];
//    silderView.center = CGPointMake(kScreenW * 0.5, 300);
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)handleApplicationDidBecomeActiveNotification:(NSNotification*)notification {
//    [self.adView videoPlay];
}

- (void)handleApplicationWillResignActiveNotification:(NSNotification*)notification {
//    [self.adView videoPause];
}

- (void)setupUI {
    [self.view addSubview:self.voiceChange];
    [self.view addSubview:self.voiceProgress];
    [self.view addSubview:self.voicePause];
    [self.view addSubview:self.voicePlay];
    [self.view addSubview:self.adView];
    [self.view addSubview:self.testHiddenPlay];
    
    [self.voicePlay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((kScreenW - kScaleW(26) * 4) / 3);
        make.height.mas_equalTo((kScreenW - kScaleW(26) * 4) / 6);
        make.left.equalTo(self.view.mas_left).offset(kScaleW(26));
        make.bottom.equalTo(self.view.mas_bottom).offset(-kScaleW(26));
    }];
    
    [self.voiceChange mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((kScreenW - kScaleW(26) * 4) / 3);
        make.height.mas_equalTo((kScreenW - kScaleW(26) * 4) / 6);
        make.left.equalTo(self.view.mas_left).offset(kScaleW(26));
        make.bottom.equalTo(self.voicePlay.mas_top).offset(-kScaleW(26));
    }];
    
    [self.voiceProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((kScreenW - kScaleW(26) * 4) / 3);
        make.height.mas_equalTo((kScreenW - kScaleW(26) * 4) / 6);
        make.left.equalTo(self.voiceChange.mas_right).offset(kScaleW(26));
        make.bottom.equalTo(self.voiceChange.mas_bottom);
    }];
    
    [self.voicePause mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((kScreenW - kScaleW(26) * 4) / 3);
        make.height.mas_equalTo((kScreenW - kScaleW(26) * 4) / 6);
        make.left.equalTo(self.voiceProgress.mas_right).offset(kScaleW(26));
        make.bottom.equalTo(self.voiceChange.mas_bottom);
    }];
    
    [self.testHiddenPlay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((kScreenW - kScaleW(26) * 4) / 3);
        make.height.mas_equalTo((kScreenW - kScaleW(26) * 4) / 6);
        make.left.equalTo(self.voicePlay.mas_right).offset(kScaleW(26));
        make.bottom.equalTo(self.voicePlay.mas_bottom);
    }];
    
}


#pragma mark - Action
- (void)clickChange {
//    NSLog(@"ATNativeViewController:getNativeAdType:%ld,getCurrentNativeAdRenderType:%ld",[self.adView getNativeAdType],[self.adView getCurrentNativeAdRenderType]);
    [self.nativeAd muteEnable:self.mute];
    self.mute = !self.mute;
}

- (void)clickProgress {
//    NSLog(@"ATNativeViewController:videoDuration:%f,videoPlayTime:%f",[self.adView videoDuration],[self.adView videoPlayTime]);
}

- (void)clickPause {
//    [self.adView videoPause];
    [self.nativeAd pauseVideo];
}

- (void)clickPlay {
    [self.nativeAd resumeVideo];
}

- (void)hiddenPlayer {
    UIViewController *sss = [[UIViewController alloc]init];
    sss.view.backgroundColor = [UIColor redColor];
    sss.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:sss animated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [sss dismissViewControllerAnimated:YES completion:^{
        }];
    });
}

#pragma mark - lazy
- (UIButton *)voiceChange {
    if (!_voiceChange) {
        _voiceChange = [[UIButton alloc] init];
        _voiceChange.layer.borderColor = kRGB(73, 109, 255).CGColor;
        _voiceChange.layer.borderWidth = kScaleW(3);
        [_voiceChange setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_voiceChange setTitleColor:kRGB(73, 109, 255) forState:UIControlStateNormal];
        [_voiceChange setBackgroundImage:[self imageWithColor:kRGB(73, 109, 255)] forState:UIControlStateHighlighted];
        [_voiceChange setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        _voiceChange.layer.masksToBounds = YES;
        _voiceChange.layer.cornerRadius = 5;
        [_voiceChange setTitle:@"Voice Change" forState:UIControlStateNormal];
        _voiceChange.titleLabel.font = [UIFont systemFontOfSize:14];
        [_voiceChange addTarget:self action:@selector(clickChange) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceChange;
}

- (UIButton *)voiceProgress {
    if (!_voiceProgress) {
        _voiceProgress = [[UIButton alloc] init];
        _voiceProgress.layer.borderColor = kRGB(73, 109, 255).CGColor;
        _voiceProgress.layer.borderWidth = kScaleW(3);
        [_voiceProgress setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_voiceProgress setTitleColor:kRGB(73, 109, 255) forState:UIControlStateNormal];
        [_voiceProgress setBackgroundImage:[self imageWithColor:kRGB(73, 109, 255)] forState:UIControlStateHighlighted];
        [_voiceProgress setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        _voiceProgress.layer.masksToBounds = YES;
        _voiceProgress.layer.cornerRadius = 5;
        [_voiceProgress setTitle:@"(no action)" forState:UIControlStateNormal];
        _voiceProgress.titleLabel.font = [UIFont systemFontOfSize:14];
        [_voiceProgress addTarget:self action:@selector(clickProgress) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceProgress;
}

- (UIButton *)voicePause {
    if (!_voicePause) {
        _voicePause = [[UIButton alloc] init];
        _voicePause.layer.borderColor = kRGB(73, 109, 255).CGColor;
        _voicePause.layer.borderWidth = kScaleW(3);
        [_voicePause setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_voicePause setTitleColor:kRGB(73, 109, 255) forState:UIControlStateNormal];
        [_voicePause setBackgroundImage:[self imageWithColor:kRGB(73, 109, 255)] forState:UIControlStateHighlighted];
        [_voicePause setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        _voicePause.layer.masksToBounds = YES;
        _voicePause.layer.cornerRadius = 5;
        [_voicePause setTitle:@"Voice Pause" forState:UIControlStateNormal];
        _voicePause.titleLabel.font = [UIFont systemFontOfSize:14];
        [_voicePause addTarget:self action:@selector(clickPause) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voicePause;
}

- (UIButton *)voicePlay {
    if (!_voicePlay) {
        _voicePlay = [[UIButton alloc] init];
        _voicePlay.layer.borderColor = kRGB(73, 109, 255).CGColor;
        _voicePlay.layer.borderWidth = kScaleW(3);
        [_voicePlay setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_voicePlay setTitleColor:kRGB(73, 109, 255) forState:UIControlStateNormal];
        [_voicePlay setBackgroundImage:[self imageWithColor:kRGB(73, 109, 255)] forState:UIControlStateHighlighted];
        [_voicePlay setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        _voicePlay.layer.masksToBounds = YES;
        _voicePlay.layer.cornerRadius = 5;
        [_voicePlay setTitle:@"Voice Play" forState:UIControlStateNormal];
        _voicePlay.titleLabel.font = [UIFont systemFontOfSize:14];
        [_voicePlay addTarget:self action:@selector(clickPlay) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voicePlay;
}

- (UIButton *)testHiddenPlay {
    if (!_testHiddenPlay) {
        _testHiddenPlay = [[UIButton alloc] init];
        _testHiddenPlay.layer.borderColor = kRGB(73, 109, 255).CGColor;
        _testHiddenPlay.layer.borderWidth = kScaleW(3);
        [_testHiddenPlay setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_testHiddenPlay setTitleColor:kRGB(73, 109, 255) forState:UIControlStateNormal];
        [_testHiddenPlay setBackgroundImage:[self imageWithColor:kRGB(73, 109, 255)] forState:UIControlStateHighlighted];
        [_testHiddenPlay setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        _testHiddenPlay.layer.masksToBounds = YES;
        _testHiddenPlay.layer.cornerRadius = 5;
        [_testHiddenPlay setTitle:@"Hidden Player" forState:UIControlStateNormal];
        _testHiddenPlay.titleLabel.font = [UIFont systemFontOfSize:14];
        [_testHiddenPlay addTarget:self action:@selector(hiddenPlayer) forControlEvents:UIControlEventTouchUpInside];
    }
    return _testHiddenPlay;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}
@end
