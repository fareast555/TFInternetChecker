//
//  InternetNSURLCheckSingleton.h
//  Internet check
//
//  Created by Michael Critchley on 5/28/15.
//  Copyright (c) 2015 Michael Critchley. All rights reserved.
//

#import <Foundation/Foundation.h>

// Typedefs returned to the calling class in the completion handler
typedef NS_ENUM(NSInteger, TFInternetStatus) {
    TFInternetStatusSearching = 0,
    TFInternetStatusNoInternet,
    TFInternetStatusFullyConnected,
    TFInternetStatus100percentLoss
};

//Completion handler typedef
typedef void (^InternetCheckCompletionHandler)
(TFInternetStatus status);

@interface TFInternetNSURLCheckSingleton : NSObject


+ (instancetype) sharedInternetNSURLCheck;

//Public method called to check Internet
- (void) checkConnectionStatusWithTimeout: (float) seconds
                           AndCompletion: (InternetCheckCompletionHandler) InternetStatus;

@end
