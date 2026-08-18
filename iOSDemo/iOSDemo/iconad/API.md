# Icon Ad

原生自渲染包装成 Icon。广告位用 **原生自渲染 placement**。日志 tag：`sdm_c_ads`。

接入拷 `iconad/IconAd/` 即可调 `IconAd`。同目录的 `IconAdVC` 只是本 demo 的示例页，不必一起拷。

原生没有独立的 show 接口，曝光是在 `registerAdView` 时上报的。所以 Icon 只在 `show` 里 register；每次 show 都会拉一条新的 native 广告，才会有新的曝光。没有 hide，用完 `destroy`。

---

## 接入步骤

**1. 准备广告位**

后台开一个原生自渲染广告位，拿到 `placementId`。SDK 已初始化。

**2. 加载**

```objc
[IconAd load:self placementId:placementId callback:callback];
```

`callback` 实现 `IconAdLoadCallback`：`onLoaded` / `onFailed`，只会走一个。

**3. 监听 + 展示**

默认是页面右下角浮动 Icon（可拖）：

```objc
[ad setListener:listener];
[ad show:self];
```

固定在某个容器里：

```objc
[ad show:self container:container];
```

再调一次 `show` 会丢掉当前这条、重新 load 再 register，计一次新曝光。

**4. 页面退出时释放**

```objc
[ad onResume];    // viewDidAppear
[ad onPause];     // viewWillDisappear
[ad destroy];     // dealloc / 点关闭也会 destroy
```

到这里就能跑。下面是可选配置。

### 可选：形状 / 展示方式

```objc
IconAdConfig *config = [[[[[IconAdConfig builder]
    displayMode:IconAdDisplayModeFLOAT]   // 或 IconAdDisplayModeANCHOR
    shape:IconAdShapeROUND]               // 或 IconAdShapeROUNDED_SQUARE
    size:64]
    build];
[ad show:self config:config];
[ad show:self container:container config:config];   // 传了 container 会按 ANCHOR 处理
```

---

## API 速查

### IconAd

| | |
| --- | --- |
| `load:placementId:callback:` | 预加载一条 native 自渲染 |
| `show:` | 浮动展示；内部 `registerAdView` |
| `show:container:` | 锚定到容器 |
| `show:config:` / `show:container:config:` | 带配置展示 |
| `isReady` | 有未展示的 fill |
| `setListener:` | show 前设置 |
| `onResume` / `onPause` | 转给底层 native 视频 |
| `destroy` | 释放 view + native；点关闭也会走到这里 |
| `SCENARIO` | `@"icon"` |

Load 时会往 native `extra` 写入 `extra_scenario` / `scenario` = `IconAd.SCENARIO`（`@"icon"`）。

### IconAdLoadCallback

`onLoaded` / `onFailed`，只会走一个。失败回调里是 `NSError`。

### IconAdListener

| | |
| --- | --- |
| `onExpose` | 曝光（`registerAdView` 之后 native `onAdShow`） |
| `onClick` | 点击图标 |
| `onClose` | 关闭。此时已经 `destroy` |
| `onShowFailed:` | 没有展示出来 |

### IconAdConfig

不传则 `FLOAT` + `ROUND` + 64。`FLOAT` 可拖，`ANCHOR` 放进容器。`ROUND` / `ROUNDED_SQUARE`。`size` 夹在 40–120。

关闭按钮在 SDK `registerAdView` 的 container 外面，避免被原生点击区域吃掉。
