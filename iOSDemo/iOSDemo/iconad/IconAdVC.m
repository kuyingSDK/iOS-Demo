//
//  IconAdVC.m
//  iOSDemo — Icon Ad sample page
//

#import "IconAdVC.h"
#import "IconAd.h"

@interface IconAdVC () <IconAdLoadCallback, IconAdListener>
@property (nonatomic, strong) UILabel *placementLabel;
@property (nonatomic, strong) UISegmentedControl *modeGroup;
@property (nonatomic, strong) UISegmentedControl *shapeGroup;
@property (nonatomic, strong) UIView *slotView;
@property (nonatomic, strong) UITextView *logView;
@property (nonatomic, strong) IconAd *iconAd;
@property (nonatomic, assign) BOOL loading;
@property (nonatomic, assign) BOOL showAfterLoad;
@end

@implementation IconAdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.placementLabel.text = [NSString stringWithFormat:@"placement: %@", NativeSelfRenderPlacementID];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.iconAd onResume];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.iconAd onPause];
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    [self destroyAd];
}

#pragma mark - UI

- (void)setupUI {
    UILabel *placement = [[UILabel alloc] init];
    placement.font = [UIFont systemFontOfSize:12];
    placement.textColor = [UIColor colorWithWhite:0.4 alpha:1];
    placement.numberOfLines = 2;
    self.placementLabel = placement;
    [self.view addSubview:placement];

    self.modeGroup = [[UISegmentedControl alloc] initWithItems:@[
        kLocalizeStr(@"浮动可拖拽"),
        kLocalizeStr(@"固定在容器")
    ]];
    self.modeGroup.selectedSegmentIndex = 0;
    [self.view addSubview:self.modeGroup];

    self.shapeGroup = [[UISegmentedControl alloc] initWithItems:@[
        kLocalizeStr(@"圆形"),
        kLocalizeStr(@"圆角方")
    ]];
    self.shapeGroup.selectedSegmentIndex = 0;
    [self.view addSubview:self.shapeGroup];

    self.slotView = [[UIView alloc] init];
    self.slotView.backgroundColor = [UIColor whiteColor];
    self.slotView.layer.cornerRadius = 8;
    UILabel *slotHint = [[UILabel alloc] init];
    slotHint.text = kLocalizeStr(@"容器（固定模式）");
    slotHint.textColor = [UIColor colorWithWhite:0.66 alpha:1];
    slotHint.font = [UIFont systemFontOfSize:12];
    slotHint.textAlignment = NSTextAlignmentCenter;
    [self.slotView addSubview:slotHint];
    [self.view addSubview:self.slotView];

    self.logView = [[UITextView alloc] init];
    self.logView.editable = NO;
    self.logView.backgroundColor = [UIColor whiteColor];
    self.logView.layer.cornerRadius = 8;
    self.logView.font = [UIFont systemFontOfSize:13];
    self.logView.textColor = kHexColor(0x1E2231);
    [self.view addSubview:self.logView];

    UIButton *loadBtn = [self makeButton:kLocalizeStr(@"加载广告") action:@selector(onLoad)];
    UIButton *readyBtn = [self makeButton:kLocalizeStr(@"Is Ready") action:@selector(onReady)];
    UIButton *showBtn = [self makeButton:kLocalizeStr(@"展示广告") action:@selector(onShow)];
    UIButton *destroyBtn = [self makeButton:kLocalizeStr(@"Destroy") action:@selector(onDestroyTap)];

    [self.view addSubview:loadBtn];
    [self.view addSubview:readyBtn];
    [self.view addSubview:showBtn];
    [self.view addSubview:destroyBtn];

    [placement mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nbar.mas_bottom).offset(12);
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
    }];
    [self.modeGroup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(placement.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
        make.height.mas_equalTo(32);
    }];
    [self.shapeGroup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.modeGroup.mas_bottom).offset(8);
        make.left.right.height.equalTo(self.modeGroup);
    }];
    [self.slotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shapeGroup.mas_bottom).offset(8);
        make.left.right.equalTo(self.modeGroup);
        make.height.mas_equalTo(96);
    }];
    [slotHint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.slotView);
    }];
    [destroyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.modeGroup);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(self.view).offset(-(12 + BottomSafeAreaHeight));
    }];
    [showBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(destroyBtn);
        make.bottom.equalTo(destroyBtn.mas_top).offset(-8);
    }];
    [readyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(destroyBtn);
        make.bottom.equalTo(showBtn.mas_top).offset(-8);
    }];
    [loadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(destroyBtn);
        make.bottom.equalTo(readyBtn.mas_top).offset(-8);
    }];
    [self.logView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.slotView.mas_bottom).offset(8);
        make.left.right.equalTo(self.modeGroup);
        make.bottom.equalTo(loadBtn.mas_top).offset(-8);
    }];
}

- (UIButton *)makeButton:(NSString *)title action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5;
    btn.layer.borderColor = kRGB(73, 109, 255).CGColor;
    btn.layer.borderWidth = 1.5;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:kRGB(73, 109, 255) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    btn.backgroundColor = [UIColor whiteColor];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark - actions

- (void)onLoad {
    [self loadAd:NO];
}

- (void)onReady {
    [self printLog:[NSString stringWithFormat:@"isReady=%d", self.iconAd != nil && [self.iconAd isReady]]];
}

- (void)onShow {
    if (self.iconAd == nil) {
        [self loadAd:YES];
        return;
    }
    [self applyShow:self.iconAd];
}

- (void)onDestroyTap {
    [self destroyAd];
    [self printLog:@"destroy"];
}

- (void)loadAd:(BOOL)showWhenReady {
    self.showAfterLoad = showWhenReady || self.showAfterLoad;
    if (self.loading) {
        return;
    }
    [self destroyAd];
    self.loading = YES;
    [self printLog:@"loading..."];
    [IconAd load:self placementId:NativeSelfRenderPlacementID callback:self];
}

- (void)applyShow:(IconAd *)ad {
    BOOL anchor = self.modeGroup.selectedSegmentIndex == 1;
    BOOL square = self.shapeGroup.selectedSegmentIndex == 1;
    IconAdConfig *config = [[[[[IconAdConfig builder]
                               displayMode:anchor ? IconAdDisplayModeANCHOR : IconAdDisplayModeFLOAT]
                              shape:square ? IconAdShapeROUNDED_SQUARE : IconAdShapeROUND]
                             size:64]
                            build];
    if (anchor) {
        [ad show:self container:self.slotView config:config];
    } else {
        [ad show:self config:config];
    }
}

- (void)destroyAd {
    self.loading = NO;
    self.showAfterLoad = NO;
    [self.iconAd destroy];
    self.iconAd = nil;
}

- (void)printLog:(NSString *)msg {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"HH:mm:ss";
    NSString *line = [NSString stringWithFormat:@"[%@] %@", [fmt stringFromDate:[NSDate date]], msg];
    if (self.logView.text.length == 0) {
        self.logView.text = line;
    } else {
        self.logView.text = [NSString stringWithFormat:@"%@\n%@", self.logView.text, line];
    }
    [self.logView scrollRangeToVisible:NSMakeRange(self.logView.text.length, 1)];
    ATDemoLog(@"%@", line);
}

#pragma mark - IconAdLoadCallback

- (void)onLoaded:(IconAd *)ad {
    self.loading = NO;
    self.iconAd = ad;
    [ad setListener:self];
    [self printLog:@"onLoaded"];
    if (self.showAfterLoad) {
        self.showAfterLoad = NO;
        [self applyShow:ad];
    }
}

- (void)onFailed:(NSError *)error {
    self.loading = NO;
    self.showAfterLoad = NO;
    [self printLog:[NSString stringWithFormat:@"onFailed %@", error.localizedDescription ?: @""]];
}

#pragma mark - IconAdListener

- (void)onExpose {
    [self printLog:@"onExpose"];
}

- (void)onClick {
    [self printLog:@"onClick"];
}

- (void)onClose {
    [self printLog:@"onClose"];
    self.iconAd = nil;
}

- (void)onShowFailed:(NSError *)error {
    [self printLog:[NSString stringWithFormat:@"onShowFailed %@", error.localizedDescription ?: @""]];
}

@end
