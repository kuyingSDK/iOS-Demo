//
//  SDMMenuView.h
//  AnyThingSDKDemo
//
//  Created by mac on 2021/12/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDMMenuView : UIView

@property (nonatomic) BOOL multiple;

@property (nonatomic, copy) void(^selectMenu)(NSString *selectMenu);
@property (nonatomic, copy) void(^selectMenus)(NSArray<NSString *> *selectMenus);

@property (nonatomic, copy) void(^selectSubMenu)(NSString *selectSubMenu);
@property (nonatomic, copy) void(^turnOnAuto)(BOOL isOn);

- (instancetype)initWithMenuList:(NSArray *)menuList subMenuList:(NSArray * __nullable)subMenuList;
- (void)resetMenuList:(NSArray *)menuList;
- (void)resetSubMenuList:(NSArray *)subMenuList;
- (void)resetSubMenuList:(NSArray *)subMenuList index:(NSUInteger)index;
- (void)resetMenuList:(NSArray *)menuList subMenuList:(NSArray *)subMenuList;
- (void)hiddenSubMenu;
- (void)showSubMenu;

@property(nonatomic,assign)BOOL turnAuto;

@end

NS_ASSUME_NONNULL_END
