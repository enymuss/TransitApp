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
    if ((self = [super init])) {
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

-(MKMapItem *)mapItem {
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:self.coordinate addressDictionary:nil];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.title;
    
    return mapItem;
}

@end
