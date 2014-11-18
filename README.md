###CCLogSystem
***

CCLogSystem provide an iOS Log System. We can use to replace *NSLog* in our project.And it also provide recording logs to the local file and review or email logs in our app.

中文版本请戳: [Chun Tips](http://chun.tips/blog/2014/10/31/fen-xiang-ge-ren-xiang-mu-zhong-de-logxi-tong-cclogsystem/)

####Main Features

* Very simplay API to use
* Use *CC_LOG* to print that get more info. The output info is include "TIMESTAMP" + "THREAD" + "FILE" + "LINE" + "FUNCTION" + origin print info.
* Use *CC_LOG_VALUE* to print any value directly. Like: CC_LOG_VALUE(self.window) or CC_LOG_VALUE(self.window.frame)
* Record crash issue
* Record the logs to the local file
* Provide the Developer UI to review and email the logs in the App

####Installation
CCLogSytem is available as a [CocoaPod](http://cocoapods.org/?q=CCLogSystem).
	
	pod 'CCLogSystem'

You can also simply copy all the source files located inside CCLogSystem/CCLogSystem/* into your iOS project.

####Example

###### How to setup CCLogSystem

	- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:	(NSDictionary *)launchOptions
	{
    	[CCLogSystem setupDefaultLogConfigure];
	}
	
##### Use CC_LOG macro to print log

	- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
	{
    	[CCLogSystem setupDefaultLogConfigure];
    
    	CC_LOG(@"%@", application);
    	// print: 2014-10-31 15:28:41.038 . <NSThread: 0x174063880>{number = 1, name = main} AppDelegate.m at 24 (-[AppDelegate application:willFinishLaunchingWithOptions:]): <UIApplication: 0x146e01cb0>
    }
    
##### Use CC_LOG_VALUE macro to print any value

	CC_LOG_VALUE(application);
    
    id applicationTemp = application;
    CC_LOG_VALUE(applicationTemp);
    
    CC_LOG_VALUE(self.window);
    
    CC_LOG_VALUE(self.window.frame);
    
    CC_LOG_VALUE(self.window.transform);
    
    Class applicationClass = NSClassFromString(@"UIApplication");
    CC_LOG_VALUE(applicationClass);
    
    SEL selector = @selector(application:continueUserActivity:restorationHandler:);
    CC_LOG_VALUE(selector);
    
    NSInteger test = 100;
    CC_LOG_VALUE(test);
    
    float test2 = 100.000001;
    CC_LOG_VALUE(test2);
    
    char test3 = 'a';
    CC_LOG_VALUE(test3);
    
    TestBlock testBlock = ^{
    };
    CC_LOG_VALUE(testBlock);

##### Review the logs in our app

	    [CCLogSystem activeDeveloperUI];

<img src="http://106.186.113.24:8888/other/IMG_0045.PNG" width="320">

<img src="http://106.186.113.24:8888/other/IMG_0046.PNG" width="320">

#### Authors and License

* All source code is licensed under the MIT License.
* Copyright (c) 2014-2015, [@Chun Ye](http://chun.tips)


