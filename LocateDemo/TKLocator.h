//
//  TKLocator.h
//  LocateDemo
//
//  Created by Kevin Wu on 7/24/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "TKGeocoder.h"

#define TKLocatorDidStartUpdatingLocationNotification @"TKLocatorDidStartUpdatingLocationNotification"
#define TKLocatorDidUpdateLocationNotification @"TKLocatorDidUpdateLocationNotification"
#define TKLocatorDidStopUpdatingLocationNotification @"TKLocatorDidStopUpdatingLocationNotification"

#define TKLocatorDidUpdateAddressNotification @"TKLocatorDidUpdateAddressNotification"


@interface TKLocator : NSObject<CLLocationManagerDelegate> {
  CLLocationManager *_locationManager;
  CLLocation *_location;
  BOOL _updating;
  
  TKGeocoder *_geocoder;
}

@property(nonatomic, strong, readonly) CLLocationManager *locationManager;
@property(nonatomic, strong, readonly) CLLocation *location;
@property(nonatomic, readonly) BOOL updating;

@property(nonatomic, strong, readonly) TKGeocoder *geocoder;

+ (TKLocator *)sharedObject;

- (void)launchLocationServiceIfNeeded;
- (void)shutdownLocationServiceIfNeeded;

- (void)updateAddressIfPossible;

@end
