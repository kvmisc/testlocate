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
  _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  _window.rootViewController = [[TKViewController alloc] init];
  
  _window.backgroundColor = [UIColor whiteColor];
  [_window makeKeyAndVisible];
  return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  [[TKLocator sharedObject] shutdownLocationServiceIfNeeded];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  [[TKLocator sharedObject] launchLocationServiceIfNeeded];
}

@end
