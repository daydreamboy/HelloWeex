//
//  WCAlertTool.m
//  HelloWeex
//
//  Created by wesley_chen on 2019/2/25.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCAlertTool.h"

@implementation WCAlertTool

+ (void)presentActionSheetWithTitle:(NSString *)title message:(nullable NSString *)message buttonTitles:(NSArray<NSString *> *)buttonTitles buttonDidClickBlocks:(NSArray *)buttonDidClickBlocks {
    return [self presentAlertWithStyle:UIAlertControllerStyleActionSheet title:title message:message buttonTitles:buttonTitles buttonDidClickBlocks:buttonDidClickBlocks
            ];
}

+ (void)presentAlertWithTitle:(NSString *)title message:(nullable NSString *)message buttonTitles:(NSArray<NSString *> *)buttonTitles buttonDidClickBlocks:(NSArray *)buttonDidClickBlocks {
    return [self presentAlertWithStyle:UIAlertControllerStyleAlert title:title message:message buttonTitles:buttonTitles buttonDidClickBlocks:buttonDidClickBlocks
            ];
}

#pragma mark > Both

+ (void)presentAlertWithStyle:(UIAlertControllerStyle)style title:(NSString *)title message:(nullable NSString *)message buttonTitles:(NSArray<NSString *> *)buttonTitles buttonDidClickBlocks:(NSArray *)buttonDidClickBlocks {
    if (![buttonTitles isKindOfClass:[NSArray class]] || ![buttonDidClickBlocks isKindOfClass:[NSArray class]]) {
        return;
    }
    
    if (buttonTitles.count != buttonDidClickBlocks.count) {
        return;
    }
    
    if (style != UIAlertControllerStyleActionSheet && style != UIAlertControllerStyleAlert) {
        return;
    }
    
    if ([UIAlertController class]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
        
        NSString *buttonTitle = [buttonTitles firstObject];
        id block = [buttonDidClickBlocks firstObject];
        
        if ([buttonTitle isKindOfClass:[NSString class]] && [WCBlockTool isBlock:block]) {
            void (^callback)(void) = block;
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                if (callback) {
                    callback();
                }
            }];
            [alert addAction:cancelAction];
        }
        
        for (NSInteger i = 1; i < buttonTitles.count; i++) {
            buttonTitle = buttonTitles[i];
            block = buttonDidClickBlocks[i];
            
            if ([buttonTitle isKindOfClass:[NSString class]] && [WCBlockTool isBlock:block]) {
                void (^callback)(void) = block;
                
                UIAlertAction *action = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    if (callback) {
                        callback();
                    }
                }];
                [alert addAction:action];
            }
        }
        
        UIViewController *topViewController = [WCAlertTool topViewControllerOnWindow:[UIApplication sharedApplication].keyWindow];
        [topViewController presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - Utility

#pragma mark > WCViewControllerTool

+ (nullable UIViewController *)topViewControllerOnWindow:(UIWindow *)window {
    if (![window isKindOfClass:[UIWindow class]]) {
        return nil;
    }
    
    return [self topViewControllerWithRootViewController:window.rootViewController];
}

#pragma mark ::

+ (UIViewController *)topViewControllerWithRootViewController:(UIViewController *)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    }
    else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        // Note: visibleViewController is the view controller at the top of the navigation stack or a view controller that was presented modally on top of the navigation controller itself.
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    }
    else if (rootViewController.presentedViewController) {
        UIViewController *presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    }
    else {
        return rootViewController;
    }
}

@end

@implementation WCBlockTool

+ (BOOL)isBlock:(id _Nullable)object {
    static Class blockClass;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        blockClass = [^{} class];
        while ([blockClass superclass] != [NSObject class]) {
            blockClass = [blockClass superclass];
        }
    });
    
    return [object isKindOfClass:blockClass];
}

@end
