//
//  CustomWeexModuleViewController.m
//  HelloWeexModule
//
//  Created by wesley_chen on 2019/1/15.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "CustomWeexModuleViewController.h"
#import "MyCustomWeexModule.h"

@interface CustomWeexModuleViewController ()
@end

@implementation CustomWeexModuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [WXSDKEngine registerModule:@"event" withClass:[MyCustomWeexModule class]];
}

@end
