//
//  TKGeocoder.m
//  LocateDemo
//
//  Created by Kevin Wu on 11/14/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "TKGeocoder.h"

@implementation TKGeocoder

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];

    [_request removeObserverAndCancel];
    _location = nil;
    _result = nil;
    _parsing = NO;
}


- (void)reverseGeocodeLocation:(CLLocation *)location
                    parameters:(NSDictionary *)parameters
             completionHandler:(TKGeocodeCompletionHandler)completionHandler
{
    if ( location ) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];

        NSMutableDictionary *context = [[NSMutableDictionary alloc] init];

        [context setObject:location forKey:@"location"];

        if ( TKMNonempty(parameters) ) {
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


- (NSString *)address
{
    return [_result objectOrNilForKey:@"display_name"];
}


- (NSString *)country
{
    NSDictionary *map = [_result objectOrNilForKey:@"address"];
    return [map objectOrNilForKey:@"country"];
}

- (NSString *)state
{
    NSDictionary *map = [_result objectOrNilForKey:@"address"];
    return [map objectOrNilForKey:@"state"];
}

- (NSString *)city
{
    NSDictionary *map = [_result objectOrNilForKey:@"address"];
    return [map objectOrNilForKey:@"state_district"];
}

- (NSString *)district
{
    NSDictionary *map = [_result objectOrNilForKey:@"address"];
    return [map objectOrNilForKey:@"suburb"];
}

- (NSString *)road
{
    NSDictionary *map = [_result objectOrNilForKey:@"address"];
    return [map objectOrNilForKey:@"road"];
}


- (void)parseLocationWithContext:(NSDictionary *)context
{
    CLLocation *location = [context objectForKey:@"location"];
    NSDictionary *parameters = [context objectForKey:@"parameters"];
    TKGeocodeCompletionHandler completionHandler = [context objectForKey:@"completionHandler"];


    NSMutableDictionary *map = [[NSMutableDictionary alloc] init];

    [map setObject:@"json" forKey:@"format"];
    [map setObject:@"zh-CN" forKey:@"accept-language"];
    [map setObject:@"18" forKey:@"zoom"];
    [map setObject:@"1" forKey:@"addressdetails"];

    for ( NSString *key in [parameters keyEnumerator] ) {
        NSString *value = [parameters objectForKey:key];
        [map setObject:value forKey:key];
    }

    [map setObject:[NSString stringWithFormat:@"%f", location.coordinate.latitude] forKey:@"lat"];
    [map setObject:[NSString stringWithFormat:@"%f", location.coordinate.longitude] forKey:@"lon"];


    NSString *address = @"http://nominatim.openstreetmap.org/reverse";


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

@end
