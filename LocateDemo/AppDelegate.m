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
  fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
  fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
  [DDLog addLogger:fileLogger];
  
  
  _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  _window.rootViewController = [[TKViewController alloc] init];
  
  _window.backgroundColor = [UIColor whiteColor];
  [_window makeKeyAndVisible];
  return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  DDLogInfo(@"[Locator] Did Become Active");
  [[TKLocator sharedObject] launchLocationServiceIfNeeded];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  DDLogInfo(@"[Locator] Will Resign Active");
  [[TKLocator sharedObject] shutdownLocationServiceIfNeeded];
}

@end
