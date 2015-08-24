//
//  ViewController.m
//  TFInternetChecker
//
//  Created by Michael Critchley on 8/22/15.
//  Copyright (c) 2015 Michael Critchley. All rights reserved.
//

#import "ViewController.h"
#import "TFInternetNSURLCheckSingleton.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)checkInternet:(id)sender
{
    //1. Disable button
    self.checkerButton.enabled = NO;
    
    //2. Show indicator
    [self.activitySpinner startAnimating];
    
    
    //3. Send a message to the singleton. I have set the timeout to 11 seconds
    
    [[TFInternetNSURLCheckSingleton sharedInternetNSURLCheck] checkConnectionStatusWithTimeout:11.0f AndCompletion: ^(TFInternetStatus status) {
        
        //4. Handle the typedef returned by the completion block
        
        if (status == TFInternetStatusFullyConnected) {
            NSLog(@"IsThereInternet --- internet is connected!");
            NSString *connected = @"You are fully connected to the Internet. Congrats!";
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:connected delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        } else if (status == TFInternetStatusNoInternet)  {
            NSString *oops = @"Oops!";
            NSString *noInternet = @"You are not connected to the Internet.";
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:oops message:noInternet delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        } else if (status == TFInternetStatus100percentLoss) {
            NSString *oops = @"Oops!";
            NSString *packageLoss = @"You are connected to your router, but it is not currently connected to the Internet. Time to find a new provider!";
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:oops message:packageLoss delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
        //5. Reset UI
        [self.activitySpinner stopAnimating];
        self.checkerButton.enabled = YES;
    }];
    
}
@end
