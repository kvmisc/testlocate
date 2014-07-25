//
//  AppDelegate.m
//  LocateDemo
//
//  Created by Kevin Wu on 7/25/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "AppDelegate.h"
#import "TKViewController.h"
#import "TKLocator.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [DDLog addLogger:[DDTTYLogger sharedInstance]];
  
  DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
  fileLogger.rollingFrequency = 60 * 60 * 24;
  fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
  [DDLog addLogger:fileLogger];
  
  
  DDLogInfo(@"[Locator] Application launched: launch");
  [[TKLocator sharedObject] launchLocationServiceIfNeeded];
  
  
  _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  _window.rootViewController = [[TKViewController alloc] init];
  
  _window.backgroundColor = [UIColor whiteColor];
  [_window makeKeyAndVisible];
  return YES;
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
  DDLogInfo(@"[Locator] Will Enter Foreground: launch");
  [[TKLocator sharedObject] launchLocationServiceIfNeeded];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  DDLogInfo(@"[Locator] Did Enter Background: shutdown");
  [[TKLocator sharedObject] shutdownLocationServiceIfNeeded];
}

@end
