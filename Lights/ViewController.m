//
//  ViewController.m
//  Lights
//
//  Created by Pieter Janssens on 14/12/13.
//  Copyright (c) 2013 Pieter Janssens. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

#define ARDUINO_IP @"192.168.1.177"

@interface ViewController () {
    NSArray *buttons;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self drawViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self drawViews];
}

- (void) drawViews {
    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
            [view removeFromSuperview];
    }
    
    buttons = [[NSUserDefaults standardUserDefaults] objectForKey:@"buttons"];
    if (!buttons) {
        buttons = @[@[@{@"switch":@"1", @"label": @"Switch 1"}], @[@{@"switch":@"2", @"label": @"Switch 2"}], @[@{@"switch":@"3",@"label": @"Switch 3"}], @[@{@"switch":@"4",@"label":@"Switch 4"}]];
    }
    
    NSInteger numberOfButtonRows = 0;
    for (NSArray *array in buttons) {
        if (array.count > 0) {
            numberOfButtonRows++;
        }
    }
    
    numberOfButtonRows ++; //Extra row for all on/off
    float topHeight = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    float buttonHeight = ((self.view.frame.size.height-topHeight-20)/numberOfButtonRows)-20;
    float buttonWidth = ((self.view.frame.size.width - 20)/2)-20;
    for (int i=0; i<numberOfButtonRows; i++) {
        NSString *label;
        if (i==numberOfButtonRows-1) {
            label = @"All";
        }
        else {
            NSArray *fromGroupSwitches = [NSArray arrayWithArray:[buttons objectAtIndex:i]];
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[fromGroupSwitches objectAtIndex:0]];
            label = [dic valueForKey:@"label"];
        }
        
        for (int j=0; j<2; j++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.tag = i;
            if (j==0) {
                [button addTarget:self action:@selector(switchOn:) forControlEvents:UIControlEventTouchDown];
                [button setTitle:[NSString stringWithFormat:@"%@ On", label] forState:UIControlStateNormal];
            }
            else {
                [button addTarget:self action:@selector(switchOff:) forControlEvents:UIControlEventTouchDown];
                [button setTitle:[NSString stringWithFormat:@"%@ Off", label] forState:UIControlStateNormal];
            }
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.backgroundColor = [[[[UIApplication sharedApplication] delegate] window] tintColor];
            button.layer.cornerRadius = 4.0;
            button.frame = CGRectMake(20.0 + j*buttonWidth + j*20, topHeight + 20.0 + i * buttonHeight + i * 20, buttonWidth, buttonHeight);
            [self.view addSubview:button];
        }
    }
}

- (void) switchOn: (UIButton *)sender {
    if (sender.tag == buttons.count) {
        [self sendCommand:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/A1B1C1D1",ARDUINO_IP]]];
    }
    else {
        NSArray *groupSwitches = [NSArray arrayWithArray:[buttons objectAtIndex:sender.tag]];
        NSMutableString *URL = [NSMutableString stringWithFormat:@"http://%@/",ARDUINO_IP];
        for (NSDictionary *dic in groupSwitches) {
            switch ([[dic valueForKey:@"switch"] integerValue]) {
                case 1:
                    [URL appendString:@"A1"];
                    break;
                case 2:
                    [URL appendString:@"B1"];
                    break;
                case 3:
                    [URL appendString:@"C1"];
                    break;
                case 4:
                    [URL appendString:@"D1"];
                    break;
                default:
                    break;
            }
        }
        [self sendCommand:[NSURL URLWithString:URL]];
    }
}

- (void) switchOff: (UIButton *)sender {
    if (sender.tag == buttons.count) {
        [self sendCommand:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/A0B0C0D0",ARDUINO_IP]]];
    }
    else {
        NSArray *groupSwitches = [NSArray arrayWithArray:[buttons objectAtIndex:sender.tag]];
        NSMutableString *URL = [NSMutableString stringWithFormat:@"http://%@/",ARDUINO_IP];
        for (NSDictionary *dic in groupSwitches) {
            switch ([[dic valueForKey:@"switch"] integerValue]) {
                case 1:
                    [URL appendString:@"A0"];
                    break;
                case 2:
                    [URL appendString:@"B0"];
                    break;
                case 3:
                    [URL appendString:@"C0"];
                    break;
                case 4:
                    [URL appendString:@"D0"];
                    break;
                default:
                    break;
            }
        }
        [self sendCommand:[NSURL URLWithString:URL]];
    }
}

- (void) sendCommand: (NSURL *)url {
    // Send a synchronous request
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:nil
                                                      error:nil];
}

@end
