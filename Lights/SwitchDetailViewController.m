//
//  SwitchDetailViewController.m
//  Lights
//
//  Created by Pieter Janssens on 15/12/13.
//  Copyright (c) 2013 Pieter Janssens. All rights reserved.
//

#import "SwitchDetailViewController.h"
#import "TableViewController.h"

@interface SwitchDetailViewController ()

@end

@implementation SwitchDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    UINavigationController *nav = (UINavigationController *)self.parentViewController;
    TableViewController *vc = (TableViewController *)[nav.viewControllers objectAtIndex:1];
    vc.label = self.switchLabelTextField.text;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view.
    self.switchLabelTextField.text = self.label;
    [self.switchLabelTextField becomeFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    TableViewController *vc = segue.destinationViewController;
    vc.label = self.label;
}

@end
