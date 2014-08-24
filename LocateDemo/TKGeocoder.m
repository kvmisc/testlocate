//
//  TKGeocoder.m
//  LocateDemo
//
//  Created by Kevin Wu on 7/24/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "TKGeocoder.h"

@implementation TKGeocoder

- (void)reverseGeocodeLocation:(CLLocation *)location
                    parameters:(NSDictionary *)parameters
             completionHandler:(TKGeocodeCompletionHandler)completionHandler
{
  if ( location ) {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    NSMutableDictionary *context = [[NSMutableDictionary alloc] init];
    
    [context setObject:location forKey:@"location"];
    
    if ( parameters ) {
      [context setObject:parameters forKey:@"parameters"];
    }
    
    if ( completionHandler ) {
      [context setObject:[completionHandler copy] forKey:@"completionHandler"];
    }
    
    [self performSelector:@selector(parseLocationWithContext:)
               withObject:context
               afterDelay:1.0];
  }
}

- (void)cancelAndClear
{
  [NSObject cancelPreviousPerformRequestsWithTarget:self];
  
  [_request removeObserverAndCancel];
  _location = nil;
  _result = nil;
  _parsing = NO;
  
}



- (NSDictionary *)addressDictionary
{
  NSArray *results = [_result objectForKey:@"results"];
  for ( NSDictionary *addressDictionary in results ) {
    NSArray *types = [addressDictionary objectForKey:@"types"];
    if ( [types hasObjectEqualTo:@"route"] ) {
      return addressDictionary;
    }
  }
  
  return nil;
}

- (NSString *)formattedAddress
{
  NSDictionary *addressDictionary = [self addressDictionary];
  return [addressDictionary objectForKey:@"formatted_address"];
}


- (NSString *)country
{
  NSDictionary *addressDictionary = [self addressDictionary];
  
  NSArray *addressComponents = [addressDictionary objectForKey:@"address_components"];
  for ( NSDictionary *component in addressComponents ) {
    NSArray *types = [component objectForKey:@"types"];
    if ( [types hasObjectEqualTo:@"country"] ) {
      return [component objectForKey:@"long_name"];
    }
  }
  
  return nil;
}

- (NSString *)administrativeArea
{
  NSDictionary *addressDictionary = [self addressDictionary];
  
  NSArray *addressComponents = [addressDictionary objectForKey:@"address_components"];
  for ( NSDictionary *component in addressComponents ) {
    NSArray *types = [component objectForKey:@"types"];
    if ( [types hasObjectEqualTo:@"administrative_area_level_1"] ) {
      return [component objectForKey:@"long_name"];
    }
  }
  
  return nil;
}

- (NSString *)subAdministrativeArea
{
  NSDictionary *addressDictionary = [self addressDictionary];
  
  NSArray *addressComponents = [addressDictionary objectForKey:@"address_components"];
  for ( NSDictionary *component in addressComponents ) {
    NSArray *types = [component objectForKey:@"types"];
    if ( [types hasObjectEqualTo:@"administrative_area_level_2"] ) {
      return [component objectForKey:@"long_name"];
    }
  }
  
  return nil;
}

- (NSString *)locality
{
  NSDictionary *addressDictionary = [self addressDictionary];
  
  NSArray *addressComponents = [addressDictionary objectForKey:@"address_components"];
  for ( NSDictionary *component in addressComponents ) {
    NSArray *types = [component objectForKey:@"types"];
    if ( [types hasObjectEqualTo:@"locality"] ) {
      return [component objectForKey:@"long_name"];
    }
  }
  
  return nil;
}

- (NSString *)subLocality
{
  NSDictionary *addressDictionary = [self addressDictionary];
  
  NSArray *addressComponents = [addressDictionary objectForKey:@"address_components"];
  for ( NSDictionary *component in addressComponents ) {
    NSArray *types = [component objectForKey:@"types"];
    if ( [types hasObjectEqualTo:@"sublocality"] ) {
      return [component objectForKey:@"long_name"];
    }
  }
  
  return nil;
}

- (NSString *)thoroughfare
{
  NSDictionary *addressDictionary = [self addressDictionary];
  
  NSArray *addressComponents = [addressDictionary objectForKey:@"address_components"];
  for ( NSDictionary *component in addressComponents ) {
    NSArray *types = [component objectForKey:@"types"];
    if ( [types hasObjectEqualTo:@"route"] ) {
      return [component objectForKey:@"long_name"];
    }
  }
  
  return nil;
}

- (NSString *)subThoroughfare
{
  NSDictionary *addressDictionary = [self addressDictionary];
  
  NSArray *addressComponents = [addressDictionary objectForKey:@"address_components"];
  for ( NSDictionary *component in addressComponents ) {
    NSArray *types = [component objectForKey:@"types"];
    if ( [types hasObjectEqualTo:@"street_number"] ) {
      return [component objectForKey:@"long_name"];
    }
  }
  
  return nil;
}

- (NSString *)postalCode
{
  NSDictionary *addressDictionary = [self addressDictionary];
  
  NSArray *addressComponents = [addressDictionary objectForKey:@"address_components"];
  for ( NSDictionary *component in addressComponents ) {
    NSArray *types = [component objectForKey:@"types"];
    if ( [types hasObjectEqualTo:@"postal_code"] ) {
      return [component objectForKey:@"long_name"];
    }
  }
  
  return nil;
}




- (void)parseLocationWithContext:(NSDictionary *)context
{
  CLLocation *location = [context objectForKey:@"location"];
  NSDictionary *parameters = [context objectForKey:@"parameters"];
  TKGeocodeCompletionHandler completionHandler = [context objectForKey:@"completionHandler"];
  
  
  NSMutableDictionary *map = [[NSMutableDictionary alloc] init];
  
  [map setObject:@"true" forKey:@"sensor"];
  
  [map setObject:@"zh-CN" forKey:@"language"];
  
  for ( NSString *key in [parameters keyEnumerator] ) {
    NSString *value = [parameters objectForKey:key];
    [map setObject:value forKey:key];
  }
  
  NSString *latlng = [NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude];
  [map setObject:latlng forKey:@"latlng"];
  
  
  NSString *address = @"http://maps.googleapis.com/maps/api/geocode/json";
  
  
  [_request removeObserverAndCancel];
  
  _request = [[TKHTTPRequest alloc] initWithAddress:[address stringByAppendingQueryDictionary:map]];
  
  @weakify(self);
  
  _request.didStartBlock = ^(id object) {
    @strongify(self);
    //[self setLocation:nil];
    //[self setResult:nil];
    [self setParsing:YES];
  };
  
  _request.didFailBlock = ^(id object) {
    @strongify(self);
    //[self setLocation:nil];
    //[self setResult:nil];
    [self setParsing:NO];
    if ( completionHandler ) {
      NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:nil];
      completionHandler(nil, error);
    }
  };
  
  _request.didFinishBlock = ^(id object) {
    @strongify(self);
    id result = [NSJSONSerialization JSONObjectWithData:[object responseData]
                                                options:0
                                                  error:NULL];
    [self setLocation:location];
    [self setResult:result];
    [self setParsing:NO];
    if ( completionHandler ) {
      completionHandler(result, nil);
    }
  };
  
  [_request startAsynchronous];
}


- (void)dealloc
{
  [NSObject cancelPreviousPerformRequestsWithTarget:self];
  
  [_request removeObserverAndCancel];
  _location = nil;
  _result = nil;
  _parsing = NO;
}



- (CLLocation *)location
{ return _location; }

- (void)setLocation:(CLLocation *)location
{ _location = location; }


- (NSDictionary *)result
{ return _result; }

- (void)setResult:(NSDictionary *)result
{ _result = result; }


- (BOOL)parsing
{ return _parsing; }

- (void)setParsing:(BOOL)parsing
{ _parsing = parsing; }

@end
