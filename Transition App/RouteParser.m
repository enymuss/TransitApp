//
//  RouteParser.m
//  Transition App
//
//  Created by Richard Szczerba on 22/05/15.
//  Copyright (c) 2015 Richard Szczerba. All rights reserved.
//

#import "RouteParser.h"

@implementation RouteParser

- (NSArray *)routeFromJSONData:(NSData *)JSONData {
    //convert JSON data into objects with properties
    id JSON = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:nil];
    
    NSMutableArray *routes = [NSMutableArray new];
    
    for (NSDictionary *routeDictionary in JSON[@"routes"]) {
        Route *route = [Route new];
        route.transportType = [route assignTransportationTypeFromString:routeDictionary[@"type"]];
        route.provider = routeDictionary[@"provider"];
        route.properties = routeDictionary[@"properties"];
        route.price = routeDictionary[@"price"];
        
        NSMutableArray *segmentsArray = [NSMutableArray new];
        for (NSDictionary *segmentsDictionary in routeDictionary[@"segments"]) {
            Segment *segment = [[Segment alloc] initWithDictionary:segmentsDictionary];
            
            NSMutableArray *stopsArray = [NSMutableArray new];
            for (NSDictionary *stopsDictionary in segmentsDictionary[@"stops"]) {
                NSString *name = stopsDictionary[@"name"];
                NSString *date = stopsDictionary[@"datetime"];
                
                CLLocationCoordinate2D coordinate;
                NSNumber *lat = stopsDictionary[@"lat"];
                NSNumber *lng = stopsDictionary[@"lng"];
                coordinate.latitude = lat.doubleValue;
                coordinate.longitude = lng.doubleValue;
                
                Stop *stop = [[Stop alloc] initWithName:name dateTime:date coordinate:coordinate];
                
                stop.properties = stopsDictionary[@"properties"];
                
                [stopsArray addObject:stop];
            }
            segment.stops = stopsArray;
            [segmentsArray addObject:segment];
        }
        route.segments = segmentsArray;
        [routes addObject:route];
    }
    
    return routes;
}

@end
