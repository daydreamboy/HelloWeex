//
//  WeexShowCaseViewController.m
//  HelloWeex
//
//  Created by wesley_chen on 18/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "WeexShowCaseViewController.h"
#import <WeexSDK/WeexSDK.h>

@interface WeexShowCaseViewController ()
@property (nonatomic, strong) WXSDKInstance *weexInstance;
@property (nonatomic, strong) NSString *weexUrl;
@end

@implementation WeexShowCaseViewController

- (instancetype)initWithWeexUrl:(NSString *)weexUrl {
    self = [super init];
    if (self) {
        _weexUrl = weexUrl;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.weexInstance.viewController = self;
    self.weexInstance.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64);
    
    [self.weexInstance renderWithURL:[NSURL URLWithString:self.weexUrl]];
    
    __weak typeof(self) weakSelf = self;
    self.weexInstance.onCreate = ^(UIView *view) {
        NSLog(@"weexSDK onCreate");
        [weakSelf.view addSubview:view];
    };
    
    self.weexInstance.renderFinish = ^(UIView *view) {
        NSLog(@"weexSDK renderFinish");
    };
    
    self.weexInstance.onFailed = ^(NSError *error) {
        NSLog(@"weexSDK onFailed : %@\n", error);
    };
}

- (void)dealloc {
    [_weexInstance destroyInstance];
}

#pragma mark - Getters

- (WXSDKInstance *)weexInstance {
    if (!_weexInstance) {
        _weexInstance = [WXSDKInstance new];
    }
    return _weexInstance;
}

@end
