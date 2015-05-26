//
//  Route.h
//  Transition App
//
//  Created by Richard Szczerba on 22/05/15.
//  Copyright (c) 2015 Richard Szczerba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Route : NSObject

typedef NS_ENUM(NSUInteger, TrsansportationType) {
    NONE,
    PUBLIC_TRANSPORT,
    CAR_SHARING,
    PRIVATE_BIKE,
    BIKE_SHARING,
    TAXI
};

@property (nonatomic) TrsansportationType transportType;
@property (nonatomic) NSString* provider;
@property (nonatomic) NSMutableArray* segments;
@property (nonatomic) NSDictionary* properties;
@property (nonatomic) NSDictionary* price;

-(TrsansportationType) assignTransportationTypeFromString:(NSString *)string;

@end
