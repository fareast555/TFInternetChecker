//
//  ViewController.h
//  TFInternetChecker
//
//  Created by Michael Critchley on 8/22/15.
//  Copyright (c) 2015 Michael Critchley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

- (IBAction)checkInternet:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *checkerButton;


@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activitySpinner;


@end

