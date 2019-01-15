//
//  MyCustomWeexModule.m
//  HelloWeex
//
//  Created by wesley_chen on 2019/1/15.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "MyCustomWeexModule.h"

@implementation MyCustomWeexModule

WX_EXPORT_METHOD(@selector(showParam:callback:))
- (void)showParam:(NSString *)param callback:(WXModuleKeepAliveCallback)callback {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    NSLog(@"%@ (%@): %@", self, NSStringFromSelector(_cmd), param);
    NSString *string = [NSString stringWithFormat:@"iOS on %@", [formatter stringFromDate:[NSDate date]]];
    callback(string, YES);
}

@end
