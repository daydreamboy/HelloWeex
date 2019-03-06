//
//  MyCustomWeexModule.m
//  HelloWeex
//
//  Created by wesley_chen on 2019/1/15.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "MyCustomWeexModule.h"
#import "WCAlertTool.h"

@implementation MyCustomWeexModule

@synthesize weexInstance;

WX_EXPORT_METHOD(@selector(showParam:callback:))
- (void)showParam:(NSString *)param callback:(WXModuleKeepAliveCallback)callback {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    NSLog(@"%@ (%@): %@", self, NSStringFromSelector(_cmd), param);
    NSString *string = [NSString stringWithFormat:@"iOS on %@", [formatter stringFromDate:[NSDate date]]];
    if (callback) {
        callback(string, YES);
    }
}

WX_EXPORT_METHOD(@selector(onLoad:callback:))
- (void)onLoad:(NSDictionary *)param callback:(WXModuleKeepAliveCallback)callback {
    self.weexInstance.viewController.title = param[@"navTitle"];
}

WX_EXPORT_METHOD(@selector(alert:message:callback:))
- (void)alert:(NSString *)title message:(NSString *)message callback:(WXModuleKeepAliveCallback)callback {
    
    NSArray *buttonTitles = @[
                              @"Cancel"
                              ];
    
    NSMutableArray *blocks = [NSMutableArray array];
    [blocks addObject:^{
        NSLog(@"Cancel clicked");
    }];
    
    [WCAlertTool presentAlertWithTitle:title message:message buttonTitles:buttonTitles buttonDidClickBlocks:blocks];
    
    if (callback) {
        callback(@"OK", YES);
    }
}


WX_EXPORT_METHOD(@selector(openURL:))
- (void)openURL:(NSString *)URL {
    NSLog(@"URL");
}

- (void)openURL2:(NSString *)URL param:(NSString *)param {
    NSLog(@"URL2");
}

@end
