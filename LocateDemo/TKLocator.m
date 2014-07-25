//
//  TKLocator.m
//  LocateDemo
//
//  Created by Kevin Wu on 7/24/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "TKLocator.h"
#import <AddressBookUI/AddressBookUI.h>

@implementation TKLocator

+ (TKLocator *)sharedObject
{
  static TKLocator *Locator = nil;
  static dispatch_once_t Token;
  dispatch_once(&Token, ^{
    Locator = [[self alloc] init];
  });
  return Locator;
}


- (void)launchLocationServiceIfNeeded
{
  CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
  if ( status==kCLAuthorizationStatusAuthorized ) {
    TKPRINT(@"Authorized，启动服务。");
    [self startLocationService];
  } else if ( status==kCLAuthorizationStatusDenied ) {
    TKPRINT(@"Denied，不启动服务。");
    
  } else if ( status==kCLAuthorizationStatusNotDetermined ) {
    TKPRINT(@"Not Determined，启动服务, 让系统弹窗口。");
    [self startLocationService];
  } else if ( status==kCLAuthorizationStatusRestricted ) {
    TKPRINT(@"Restricted，不启动服务。");
  }
}

- (void)shutdownLocationServiceIfNeeded
{
  CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
  if ( status==kCLAuthorizationStatusAuthorized ) {
    TKPRINT(@"Authorized, 授权了, 可能开启了服务, 应该关闭。");
    [self stopLocationService];
  } else if ( status==kCLAuthorizationStatusDenied ) {
    TKPRINT(@"Denied, 未授权, 未开启服务, 不需要关闭。");
  } else if ( status==kCLAuthorizationStatusNotDetermined ) {
    TKPRINT(@"Not Determined, 未决定, 未开启服务, 不需要关闭。");
  } else if ( status==kCLAuthorizationStatusRestricted ) {
    TKPRINT(@"Restricted, 不需要关闭。");
  }
}


- (void)updateAddressIfPossible
{
  if ( !_geocoder ) {
    _geocoder = [[TKGeocoder alloc] init];
  }
  
  @weakify(self);
  [_geocoder reverseGeocodeLocation:_location
                         parameters:nil
                  completionHandler:^(id result, NSError *error) {
                    @strongify(self);
                    [self notifyDidUpdateAddress];
                  }];
}




- (void)dealloc
{
  _locationManager.delegate = nil;
  [_locationManager stopUpdatingLocation];
  
  [_geocoder cancelAndClear];
}


- (void)startLocationService
{
  CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
  if ( status==kCLAuthorizationStatusAuthorized ) {
    TKPRINT(@"Authorized, 授权了, 需要通知。");
    [self notifyDidStartUpdatingLocationIfNeeded];
  } else if ( status==kCLAuthorizationStatusDenied ) {
    TKPRINT(@"Denied, 未授权, 根本不会执行到这里。");
  } else if ( status==kCLAuthorizationStatusNotDetermined ) {
    TKPRINT(@"Not Determined, 未决定, 不需要通知。");
  } else if ( status==kCLAuthorizationStatusRestricted ) {
    TKPRINT(@"Restricted, 根本不会执行到这里。");
  }
  
  
  if ( !_locationManager ) {
    _locationManager = [[CLLocationManager alloc] init];
  }
  
  _locationManager.distanceFilter = 10;
  _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
  _locationManager.delegate = self;
  
  [_locationManager startUpdatingLocation];
}

- (void)stopLocationService
{
  _locationManager.delegate = nil;
  [_locationManager stopUpdatingLocation];
  //_locationManager = nil;
  
  [self notifyDidStopUpdatingLocationIfNeeded];
}



- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
  if ( status==kCLAuthorizationStatusAuthorized ) {
    TKPRINT(@"Authorized");
    [self notifyDidStartUpdatingLocationIfNeeded];
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
  } else if ( status==kCLAuthorizationStatusDenied ) {
    TKPRINT(@"Denied");
    _locationManager.delegate = nil;
    [_locationManager stopUpdatingLocation];
    [self notifyDidStopUpdatingLocationIfNeeded];
  } else if ( status==kCLAuthorizationStatusNotDetermined ) {
    TKPRINT(@"Not Determined");
    // Do nothing here
  } else if ( status==kCLAuthorizationStatusRestricted ) {
    TKPRINT(@"Restricted");
    _locationManager.delegate = nil;
    [_locationManager stopUpdatingLocation];
    [self notifyDidStopUpdatingLocationIfNeeded];
  }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
  TKPRINTMETHOD();
  _location = [locations lastObject];
  [self notifyDidUpdateLocation];
  
  [self updateAddressIfPossible];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
  TKPRINTMETHOD();
  _location = nil;
  [self notifyDidUpdateLocation];
  
  [_geocoder cancelAndClear];
  [self notifyDidUpdateAddress];
}



- (void)notifyDidStartUpdatingLocationIfNeeded
{
  if ( !_updating ) {
    _updating = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:TKLocatorDidStartUpdatingLocationNotification
                                                        object:self];
  }
}

- (void)notifyDidUpdateLocation
{
  [[NSNotificationCenter defaultCenter] postNotificationName:TKLocatorDidUpdateLocationNotification
                                                      object:self];
}

- (void)notifyDidStopUpdatingLocationIfNeeded
{
  if ( _updating ) {
    _updating = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:TKLocatorDidStopUpdatingLocationNotification
                                                        object:self];
  }
}

- (void)notifyDidUpdateAddress
{
  [[NSNotificationCenter defaultCenter] postNotificationName:TKLocatorDidUpdateAddressNotification
                                                      object:self];
}

@end
