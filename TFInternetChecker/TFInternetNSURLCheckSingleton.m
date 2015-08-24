//
//  InternetNSURLCheckSingleton.m
//  Internet check
//
//  Created by Michael Critchley on 5/28/15.
//  Copyright (c) 2015 Michael Critchley. All rights reserved.
//

#import "TFInternetNSURLCheckSingleton.h"

@implementation TFInternetNSURLCheckSingleton
{
    InternetCheckCompletionHandler _statusHandler;
    TFInternetStatus _currentStatus;
    NSTimer *_InternetCheckTimer;
    NSTimer *_timeoutTimer;

}

// Return the singleton instance
+ (instancetype) sharedInternetNSURLCheck
{
    static id retval;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        retval = [[TFInternetNSURLCheckSingleton alloc]init];
    });
    
    return  retval;
}


- (void) checkConnectionStatusWithTimeout:(float)seconds
                            AndCompletion:(InternetCheckCompletionHandler)InternetStatus

{
   //1. Make a copy of the handler
    _statusHandler = [InternetStatus copy];
    
    //2. Set the current status as SEARCHING.
    _currentStatus = TFInternetStatusSearching;
    
    //3. Get two timers set
       //Timer 1 calls a kill switch if we reach the timeout you have set
    _timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(endCheckAs100percentPackageLoss) userInfo:nil repeats:NO];
    
    //Timer 2 keeps pinging every 0.2s to see if the _current status has changed
    _InternetCheckTimer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(testConnectionStatus) userInfo:nil repeats:YES];
    
    [_InternetCheckTimer fire];
    
    //4. START the check
    /*
     Async is used to account for when user is connected to a router, but the router is not connected to the network. Using asynch prevents freezes in the main thread that happen while the system waits for it's very long time out. Instead, we can leave the check when our own time out is reached.
     */
   
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self isThereInternet];
        
    });
    
}

- (void) isThereInternet
{
    //5. Set a NSURL to a mega small file and put it in a data file.
    /* !!! This data must be something you are SURE will not disappear from the internet in the life of the app. */
    NSURL *scriptUrl = [NSURL URLWithString:@"http://www.flashlearningapp.com/uploads/5/1/0/3/51037765/839780.jpg"];
    
    NSURL *backupScriptURL = [NSURL URLWithString:@"https://asiatravelbugdotnet.files.wordpress.com/2015/06/whiteimage.png"];
    
    NSData *data = [NSData dataWithContentsOfURL:scriptUrl];
    
    NSData *backupData = [NSData dataWithContentsOfURL:backupScriptURL];
  
    //Some debug checks if you want to use them
   // NSLog(@"data URL is %lu bytes", (unsigned long)data.length);
   // NSLog(@"Backup data is %lu bytes", (unsigned long)backupData.length);
    
    //6. Call to change the TFInternetStatus status accordingly
    if (data || backupData) {
        NSLog(@"Device is connected to the internet");
        [self setAsConnected];
        
    } else {
        NSLog(@"Device is not connected to the internet");
        [self setAsNOTConnected];
    }
    
}


- (void) setAsConnected
{
    _currentStatus = TFInternetStatusFullyConnected;
    
    //For debugging purposes
    [self displayCurrentStatus];
    
}


- (void) setAsNOTConnected
{
    _currentStatus = TFInternetStatusNoInternet;
    
    //For debugging purposes
    [self displayCurrentStatus];
}

/* This method is called every 0.2 seconds. If we do not have a yes/no about connectivity, this method will handle the time out */
- (void) testConnectionStatus
{
    
   //1. Is status unclear? If so, keep searching until we time out.
    if (_currentStatus == TFInternetStatusSearching) {
        
        return;
        
    //2. OK, we have a clear answer of YES or NO
    } else if ((_currentStatus == TFInternetStatusFullyConnected) ||
               (_currentStatus == TFInternetStatusNoInternet)) {
      
        
    //3. Kill the timers
        [self invalidateTimers];
        
    //4. Fullfill and nil completion. The current status is returned to the calling method
        _statusHandler (_currentStatus);
        _statusHandler = nil;
        
        
    }
}

/* This method deals with the edge case (not so unusual in Asia) of mobile wifi users (and others) who have a personal hotspot, but are in a sex dungeon somewhere and the router is not connected. If this method is called, it is because the timeout was reached and we can assume that a reliable internet connection was not found. */

- (void) endCheckAs100percentPackageLoss
{
    NSLog(@"endCheck called. Returning 100 percent loss typedef");
    // Set status as 100% package loss (Connected to a router -- pocket WIFI etc -- but that router is not connected to a host server)
    _currentStatus = TFInternetStatus100percentLoss;
    
    // Kill the timers
    [self invalidateTimers];
    
    // Fullfill completion
    _statusHandler (_currentStatus);
    _statusHandler = nil;
    
}

- (void) invalidateTimers
{
    [_timeoutTimer invalidate];
    [_InternetCheckTimer invalidate];
    _timeoutTimer = nil;
    _InternetCheckTimer = nil;
}


//DEBUG method. Just logs what is happening. Not essential code
- (void) displayCurrentStatus
{
    if (_currentStatus == TFInternetStatusFullyConnected) {
        NSLog(@"Display current status: CONNECTED");
    } else if (_currentStatus == TFInternetStatusNoInternet) {
        NSLog(@"Display current status: NOT CONNECTED");
    }
}

@end

