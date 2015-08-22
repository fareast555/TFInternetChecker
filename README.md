# TFInternetChecker
Checks if connected Internet, and distinguishes between no connection, and a 100% package loss scenario. Free to use and share with no restriction. If you use it in an app, I’d love to see it at work, so please let me know! 

HOW TO USE (Objective-C: Swift to follow in a few months)

Drag TFInternetNSURLCheckSingleton.h / TFInternetNSURLCheckSingleton.m into your project folder and drag them into your xCode project.

Make sure to declare the singleton within the class that will be checking for Internet connectivity

Send a message to the singleton, which is actually a block that returns a typeDef. It takes one argument, which is the amount of time you want the singleton to keep checking before it times out: [[TFInternetNSURLCheckSingleton sharedInternetNSURLCheck] checkConnectionStatusWithTimeout:11.0f AndCompletion: ^(TFInternetStatus status) { //Code sample to put in this completion handler shown below in number 4. }];

The singleton uses the same logic as other Internet checker solutions: It tries to download a data file from the Internet. TFInternetNSURLCheckSingleton will attempt to download up to two files stored online. If the app finds the first file, it's all good. Otherwise, it will check for the next file (a backup in case the first site is down for some reason). If that is also offline, we are, indeed, offline. Where TFInternetNSURLCheckSingleton is different is in the case where the user's device is connected to a router, but the router is not connected to the Internet. This causes 100% packet loss, which hangs Reachability and other solutions until their blocks time out, which seems like an app hang from the user's perspective. 

TFInternetNSURLCheckSingleton returns one of 3 typedefs: TFInternetStatusNoInternet, TFInternetStatusFullyConnected, TFInternetStatus100percentLoss

Check for these in the completion block as indicated in (3) above.

if (status == TFInternetStatusFullyConnected) { You're connected. Do something!} if (status == TFInternetStatusNoInternet) { The user has no connection. Alert them to this } if (status == TFInternetStatus100percentLoss) { The user may see a connection, but they are not actually reaching the Internet }

Install the Network Link Conditioner developer tool to simulate 100% package loss to test everything out. 

Hope you find it useful!
