//
//  TKViewController.m
//  LocateDemo
//
//  Created by Kevin on 5/26/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "TKViewController.h"
#import "TKLocator.h"

@implementation TKViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(didStartUpdatingLocation:)
                                               name:TKLocatorDidStartUpdatingLocationNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(didUpdateLocation:)
                                               name:TKLocatorDidUpdateLocationNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(didStopUpdatingLocation:)
                                               name:TKLocatorDidStopUpdatingLocationNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(didUpdateAddress:)
                                               name:TKLocatorDidUpdateAddressNotification
                                             object:nil];
  
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didStartUpdatingLocation:(NSNotification *)noti
{
  TKLocator *locator = [noti object];
  NSLog(@"Did Start Updating Location: %@", locator);
}

- (void)didUpdateLocation:(NSNotification *)noti
{
  TKLocator *locator = [noti object];
  NSLog(@"Did Update Location: %@", locator.location);
}

- (void)didStopUpdatingLocation:(NSNotification *)noti
{
  TKLocator *locator = [noti object];
  NSLog(@"Did Stop Updating Location: %@", locator);
}


- (void)didUpdateAddress:(NSNotification *)noti
{
  TKLocator *locator = [noti object];
  NSLog(@"Did Update Address: %@", [locator.geocoder formattedAddress]);
}

@end
