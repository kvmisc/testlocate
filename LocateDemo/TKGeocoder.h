//
//  TKGeocoder.h
//  LocateDemo
//
//  Created by Kevin Wu on 11/14/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^TKGeocodeCompletionHandler)(id result, NSError *error);

@interface TKGeocoder : NSObject {
    TKHTTPRequest *_request;
    CLLocation *_location;
    NSDictionary *_result;
    BOOL _parsing;
}

@property (nonatomic, strong) TKHTTPRequest *request;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSDictionary *result;
@property (nonatomic, assign) BOOL parsing;

- (void)reverseGeocodeLocation:(CLLocation *)location
                    parameters:(NSDictionary *)parameters
             completionHandler:(TKGeocodeCompletionHandler)completionHandler;

- (void)cancelAndClear;


- (NSString *)address;

- (NSString *)country;
- (NSString *)state;
- (NSString *)city;
- (NSString *)district;
- (NSString *)road;

@end
