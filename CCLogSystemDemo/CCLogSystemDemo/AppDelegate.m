//
//  AppDelegate.m
//  CCLogSystemDemo
//
//  Created by Chun Ye on 10/31/14.
//  Copyright (c) 2014 Chun Tips. All rights reserved.
//

#import "AppDelegate.h"
#import "CCLogSystem.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

typedef void (^TestBlock)();

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [CCLogSystem setupDefaultLogConfigure];
    
    CC_LOG(@"%@", application);
    
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
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
