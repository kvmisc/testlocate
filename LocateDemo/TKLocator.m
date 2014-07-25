//
//  TKLocator.m
//  LocateDemo
//
//  Created by Kevin Wu on 7/24/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "TKLocator.h"

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
    DDLogInfo(@"[Locator] Launch Service: Authorized，启动服务。");
    [self startLocationService];
  } else if ( status==kCLAuthorizationStatusDenied ) {
    DDLogInfo(@"[Locator] Launch Service: Denied，不启动服务。");
    
  } else if ( status==kCLAuthorizationStatusNotDetermined ) {
    DDLogInfo(@"[Locator] Launch Service: Not Determined，启动服务, 让系统弹窗口。");
    [self startLocationService];
  } else if ( status==kCLAuthorizationStatusRestricted ) {
    DDLogInfo(@"[Locator] Launch Service: Restricted，不启动服务。");
  }
}

- (void)shutdownLocationServiceIfNeeded
{
  CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
  if ( status==kCLAuthorizationStatusAuthorized ) {
    DDLogInfo(@"[Locator] Shutdown Service: Authorized, 授权了, 可能开启了服务, 应该关闭。");
    [self stopLocationService];
  } else if ( status==kCLAuthorizationStatusDenied ) {
    DDLogInfo(@"[Locator] Shutdown Service: Denied, 未授权, 未开启服务, 不需要关闭。");
  } else if ( status==kCLAuthorizationStatusNotDetermined ) {
    DDLogInfo(@"[Locator] Shutdown Service: Not Determined, 未决定, 未开启服务, 不需要关闭。");
  } else if ( status==kCLAuthorizationStatusRestricted ) {
    DDLogInfo(@"[Locator] Shutdown Service: Restricted, 不需要关闭。");
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
                    DDLogInfo(@"[Locator] Update Address: %@", self.geocoder.result);
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
    DDLogInfo(@"[Locator] Start: Authorized, 授权了, 需要通知。");
    [self notifyDidStartUpdatingLocationIfNeeded];
  } else if ( status==kCLAuthorizationStatusDenied ) {
    DDLogInfo(@"[Locator] Start: Denied, 未授权, 根本不会执行到这里。");
  } else if ( status==kCLAuthorizationStatusNotDetermined ) {
    DDLogInfo(@"[Locator] Start: Not Determined, 未决定, 不需要通知。");
  } else if ( status==kCLAuthorizationStatusRestricted ) {
    DDLogInfo(@"[Locator] Start: Restricted, 根本不会执行到这里。");
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
    DDLogInfo(@"[Locator] Change Authorization Status: Authorized");
    [self notifyDidStartUpdatingLocationIfNeeded];
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
  } else if ( status==kCLAuthorizationStatusDenied ) {
    DDLogInfo(@"[Locator] Change Authorization Status: Denied");
    _locationManager.delegate = nil;
    [_locationManager stopUpdatingLocation];
    [self notifyDidStopUpdatingLocationIfNeeded];
  } else if ( status==kCLAuthorizationStatusNotDetermined ) {
    DDLogInfo(@"[Locator] Change Authorization Status: Not Determined");
    // Do nothing here
  } else if ( status==kCLAuthorizationStatusRestricted ) {
    DDLogInfo(@"[Locator] Change Authorization Status: Restricted");
    _locationManager.delegate = nil;
    [_locationManager stopUpdatingLocation];
    [self notifyDidStopUpdatingLocationIfNeeded];
  }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
  DDLogInfo(@"[Locator] Update Location: %@", [locations lastObject]);
  _location = [locations lastObject];
  [self notifyDidUpdateLocation];
  
  [self updateAddressIfPossible];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
  DDLogInfo(@"[Locator] Failed With Error");
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
