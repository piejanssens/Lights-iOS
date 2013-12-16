//
//  SwitchDetailViewController.h
//  Lights
//
//  Created by Pieter Janssens on 15/12/13.
//  Copyright (c) 2013 Pieter Janssens. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *switchLabelTextField;
@property (nonatomic, retain) NSString *label;
@end
