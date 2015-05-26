//
//  Route.m
//  Transition App
//
//  Created by Richard Szczerba on 22/05/15.
//  Copyright (c) 2015 Richard Szczerba. All rights reserved.
//

#import "Route.h"

@implementation Route

-(TrsansportationType)assignTransportationTypeFromString:(NSString *)string{
    TrsansportationType type;
    if ([string isEqualToString:@"public_transport"]) {
        type = PUBLIC_TRANSPORT;
    } else if ([string isEqualToString:@"car_sharing"]){
        type = CAR_SHARING;
    } else if ([string isEqualToString:@"private_bike"]){
        type = PRIVATE_BIKE;
    } else if ([string isEqualToString:@"bike_sharing"]){
        type = BIKE_SHARING;
    } else if ([string isEqualToString:@"taxi"]){
        type = TAXI;
    } else {
        type = ALL;
    }
    return type;
}

@end
