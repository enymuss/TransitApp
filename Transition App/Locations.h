//
//  Locations.h
//  Transition App
//
//  Created by Richard Szczerba on 25/05/15.
//  Copyright (c) 2015 Richard Szczerba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Locations : MKPinAnnotationView <MKAnnotation>

- (id)initWithName:(NSString *)name address:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate;
- (MKMapItem *)mapItem;

@end
