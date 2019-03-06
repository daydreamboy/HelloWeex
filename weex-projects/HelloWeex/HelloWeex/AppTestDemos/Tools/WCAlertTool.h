//
//  WCAlertTool.h
//  HelloWeex
//
//  Created by wesley_chen on 2019/2/25.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCAlertTool : NSObject

@end

@interface WCAlertTool ()
/**
 Show action sheet

 @param title the title
 @param message the message
 @param buttonTitles the array of button titles
 @param buttonDidClickBlocks the array of button click blocks
 - the signature of block is void (^block)(void).
 */
+ (void)presentActionSheetWithTitle:(NSString *)title message:(nullable NSString *)message buttonTitles:(NSArray<NSString *> *)buttonTitles buttonDidClickBlocks:(NSArray *)buttonDidClickBlocks;

+ (void)presentAlertWithTitle:(NSString *)title message:(nullable NSString *)message buttonTitles:(NSArray<NSString *> *)buttonTitles buttonDidClickBlocks:(NSArray *)buttonDidClickBlocks;

@end

@interface WCBlockTool : NSObject

@end

@interface WCBlockTool ()
/**
 Check an object if a block

 @param object the object to check
 @return YES if the object is a block
 @see https://gist.github.com/steipete/6ee378bd7d87f276f6e0
 @discussion Don't convert object to block, before use this method to check
 @code
 
    // A wrong example,
    id object = [NSNull null];
    void (^block)(void) = object;
    [WCBlockTool isBlock:block]; // Crash caused by _Block_copy
 
    // A good example
    id object = [NSNull null];
    if ([WCBlockTool isBlock:object]) { // OK
        void (^block)(void) = object;
        if (block) {
            block();
        }
    }
 
 @endcode
 */
+ (BOOL)isBlock:(id _Nullable)object;
@end

NS_ASSUME_NONNULL_END
