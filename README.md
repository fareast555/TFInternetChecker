# TFInternetChecker
Checks if connected Internet, and distinguishes between no connection, and a 100% package loss scenario. Free to use and share with no restriction. If you use it in an app, I’d love to see it at work, so please let me know! 

HOW TO USE (Objective-C: Swift to follow in a few months)

Drag TFInternetNSURLCheckSingleton.h / .m into your project folder and then into xCode.

Import the singleton within the class that will be checking for Internet connectivity

The singleton is called with a completion block that returns a typeDef. The method takes one argument, which is the amount of time you want the singleton to keep checking before it times out: 

[[TFInternetNSURLCheckSingleton sharedInternetNSURLCheck] checkConnectionStatusWithTimeout:11.0f AndCompletion: ^(TFInternetStatus status) { 

  //Code to check which connection status typedef is returned 
   }];

The singleton uses the same logic as other Internet checker solutions: It tries to download a data file from the Internet. But TFInternetNSURLCheckSingleton is different in that it also prevents system freezes in situations of 100% packet loss (when the user's device is connected to a router, but the router is not connected to the Internet).  

TFInternetNSURLCheckSingleton returns one of 3 typedefs: 
     TFInternetStatusNoInternet, 
     TFInternetStatusFullyConnected, 
     TFInternetStatus100percentLoss

Check for these in the completion block as indicated above.

if (status == TFInternetStatusFullyConnected) { You're connected. Do something!} 

if (status == TFInternetStatusNoInternet) { The user has no connection. Alert! } 

if (status == TFInternetStatus100percentLoss) { The user may see a connection, but they are not actually reaching the Internet }

Install the Network Link Conditioner developer tool to simulate 100% package loss to test everything out. 

Hope you find it useful!
