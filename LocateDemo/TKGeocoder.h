//
//  TKGeocoder.h
//  LocateDemo
//
//  Created by Kevin Wu on 7/24/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^TKGeocodeCompletionHandler)(id result, NSError *error);

@interface TKGeocoder : NSObject {
  NSDictionary *_parameters;
  
  TKHTTPRequest *_request;
  CLLocation *_location;
  NSDictionary *_result;
  BOOL _parsing;
}

@property (nonatomic, strong) NSDictionary *parameters;

@property (nonatomic, strong, readonly) TKHTTPRequest *request;
@property (nonatomic, strong, readonly) CLLocation *location;
@property (nonatomic, strong, readonly) NSDictionary *result;
@property (nonatomic, readonly) BOOL parsing;

- (void)reverseGeocodeLocation:(CLLocation *)location
             completionHandler:(TKGeocodeCompletionHandler)completionHandler;

- (void)cancelAndClear;


- (NSDictionary *)addressDictionary;
- (NSString *)formattedAddress;

- (NSString *)country;
- (NSString *)administrativeArea;
- (NSString *)subAdministrativeArea;
- (NSString *)locality;
- (NSString *)subLocality;
- (NSString *)thoroughfare;
- (NSString *)subThoroughfare;
- (NSString *)postalCode;

@end
