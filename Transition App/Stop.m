//
//  Stops.m
//  Transition App
//
//  Created by Richard Szczerba on 22/05/15.
//  Copyright (c) 2015 Richard Szczerba. All rights reserved.
//

#import "Stop.h"

@implementation Stop

-(id)initWithName:(NSString *)name dateTime:(NSString *)date coordinate:(CLLocationCoordinate2D)coordinate {
    self = [super init];
    if (self) {
        if ([name isKindOfClass:[NSString class]]) {
            self.name = name;
        } else {
            self.name = @"Unknown";
        }
        self.coordinate = coordinate;
        self.dateTime = date;
    }
    return self;
}

-(NSString *)title {
    return _name;
}

-(NSString *)subtitle {
    return nil;
}

-(CLLocationCoordinate2D)coordinate {
    return _coordinate;
}

@end
