//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "InputWeexUrlViewController.h"
#import "WeexShowCaseViewController.h"
#import "WCAlertTool.h"

#import "MyCustomWeexModule.h"

// @see https://stackoverflow.com/a/33525373
#define KeyValuePair(key, value)    @[((key) ?: [NSNull null]), ((value) ?: [NSNull null])]
#define KeyValuePairType            NSArray *
#define KeyValuePairValidate(pair)  ([(pair) isKindOfClass:[NSArray class]] && [(pair) count] == 2)
#define KeyOfPair(pair)             (KeyValuePairValidate(pair) ? ([pair firstObject] ==  [NSNull null] ? nil : [pair firstObject]) : nil)
#define ValueOfPair(pair)           (KeyValuePairValidate(pair) ? ([pair lastObject] ==  [NSNull null] ? nil : [pair lastObject]) : nil)


@interface InputWeexUrlViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UILabel *labelTip;
@property (nonatomic, strong) UITextField *textFieldUrl;
@property (nonatomic, strong) UITextField *textFieldWeexModuleName;
@property (nonatomic, strong) UITextField *textFieldWeexModuleClass;
@property (nonatomic, strong) UIButton *buttonShowWeex;
@property (nonatomic, strong) UIButton *buttonPaste;
@property (nonatomic, strong) UIButton *buttonSelectWeexModule;
@property (nonatomic, strong) NSArray<KeyValuePairType> *weexModules;
@end

@implementation InputWeexUrlViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _weexModules = @[
                         KeyValuePair(@"Cancel", nil),
                         KeyValuePair(@"event", @"MyCustomWeexModule"),
                         ];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.labelTip];
    [self.view addSubview:self.textFieldUrl];
    [self.view addSubview:self.buttonShowWeex];
    [self.view addSubview:self.buttonPaste];
    [self.view addSubview:self.buttonSelectWeexModule];
}

#pragma mark - Getters

#define TextField_Padding_H 10

- (UILabel *)labelTip {
    if (!_labelTip) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 64 + 10, screenSize.width, 20)];
        label.text = @"Input Weex Url here";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        
        _labelTip = label;
    }
    
    return _labelTip;
}

- (UITextField *)textFieldUrl {
    if (!_textFieldUrl) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(TextField_Padding_H, CGRectGetMaxY(self.labelTip.frame) + 10, screenSize.width - 2 * TextField_Padding_H, 30)];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        textField.delegate = self;
        textField.placeholder = @"192.168.199.157:8081/helloweex.js";
        
        _textFieldUrl = textField;
    }
    
    return _textFieldUrl;
}

- (UIButton *)buttonShowWeex {
    if (!_buttonShowWeex) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:@"Open url" forState:UIControlStateNormal];
        [button sizeToFit];
        button.center = CGPointMake(screenSize.width / 2.0, CGRectGetMaxY(self.textFieldUrl.frame) + CGRectGetHeight(button.bounds) / 2.0 + 10);
        [button addTarget:self action:@selector(buttonShowWeexClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _buttonShowWeex = button;
    }
    
    return _buttonShowWeex;
}

- (UIButton *)buttonPaste {
    if (!_buttonPaste) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:@"Paste url" forState:UIControlStateNormal];
        [button sizeToFit];
        button.center = CGPointMake(screenSize.width / 2.0, CGRectGetMaxY(self.buttonShowWeex.frame) + CGRectGetHeight(button.bounds) / 2.0 + 10);
        [button addTarget:self action:@selector(buttonPasteClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _buttonPaste = button;
    }
    
    return _buttonPaste;
}

- (UIButton *)buttonSelectWeexModule {
    if (!_buttonSelectWeexModule) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:@"Select weex module" forState:UIControlStateNormal];
        [button sizeToFit];
        button.center = CGPointMake(screenSize.width / 2.0, CGRectGetMaxY(self.buttonPaste.frame) + CGRectGetHeight(button.bounds) / 2.0 + 10);
        [button addTarget:self action:@selector(buttonSelectWeexModuleClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _buttonSelectWeexModule = button;
    }
    
    return _buttonSelectWeexModule;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.textFieldUrl) {
        [self.textFieldUrl resignFirstResponder];
    }
    return YES;
}

#pragma mark - Actions

- (void)buttonShowWeexClicked:(id)sender {
    NSString *url;
    if ([self.textFieldUrl.text hasPrefix:@"http://"] ||
        [self.textFieldUrl.text hasPrefix:@"https://"]) {
        url = self.textFieldUrl.text;
    }
    else {
        url = [NSString stringWithFormat:@"http://%@", self.textFieldUrl.text];
    }
    
    WeexShowCaseViewController *vc = [[WeexShowCaseViewController alloc] initWithWeexUrl:url];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)buttonPasteClicked:(id)sender {
    self.textFieldUrl.text = [UIPasteboard generalPasteboard].string;
}

- (void)buttonSelectWeexModuleClicked:(id)sender {
    NSMutableArray *titles = [NSMutableArray array];
    NSMutableArray *blocks = [NSMutableArray array];
    
    for (KeyValuePairType pair in self.weexModules) {
        NSString *key = KeyOfPair(pair);
        NSString *value = ValueOfPair(pair);
        
        if (key) {
            [titles addObject:key];
            
            if (value) {
                void (^aBlock)(void) = ^{
                    if (NSClassFromString(value)) {
                        [WXSDKEngine registerModule:key withClass:NSClassFromString(value)];
                    }
                };
                [blocks addObject:aBlock];
            }
            else {
                [blocks addObject:^{}];
            }
        }
    }

    [WCAlertTool presentActionSheetWithTitle:@"Register Weex Module" message:@"Select a module" buttonTitles:titles buttonDidClickBlocks:blocks];
}

@end
