//
//  Stops.h
//  Transition App
//
//  Created by Richard Szczerba on 22/05/15.
//  Copyright (c) 2015 Richard Szczerba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Stop : MKPinAnnotationView <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) NSString *dateTime;
@property (nonatomic) NSString *name;
@property (nonatomic) id properties;


- (id)initWithName:(NSString *)name dateTime:(NSString *)date coordinate:(CLLocationCoordinate2D)coordinate;

@end
