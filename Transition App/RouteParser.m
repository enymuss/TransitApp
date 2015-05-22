//
//  RouteParser.m
//  Transition App
//
//  Created by Richard Szczerba on 22/05/15.
//  Copyright (c) 2015 Richard Szczerba. All rights reserved.
//

#import "RouteParser.h"
#import "Route.h"

@implementation RouteParser

- (Route *)routeFromJSONData:(NSData *)jsonData {
    id json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
//    NSLog(@"%@", json);
    
    
    NSMutableArray *routes = [NSMutableArray new];
    
    for (NSDictionary *routeDict in json[@"routes"]) {
        Route *route = [Route new];
        route.type = routeDict[@"type"];
        route.provider = routeDict[@"provider"];
        route.properties = routeDict[@"properties"];
        route.price = routeDict[@"price"];
        
        NSMutableArray *multiSegments = [NSMutableArray new];
        for (NSDictionary *segmentsDict in routeDict[@"segments"]) {
            Segment *segment = [Segment new];
            
            segment.name = segmentsDict[@"name"];
            segment.numberStops = segmentsDict[@"num_stops"];
            segment.stops = segmentsDict[@"stops"];
            segment.travelMode = segmentsDict[@"travel_mode"];
            segment.segmentDescription = segmentsDict[@"description"];
            segment.color = segmentsDict[@"color"];
            segment.iconURL = segmentsDict[@"icon_url"];
            segment.polyline = segmentsDict[@"polyline"];
            
            
            [multiSegments addObject:segment];
        }
        route.segments = multiSegments;
        [routes addObject:route];
    }
    NSLog(@"%@", [[[[routes firstObject] segments] firstObject] travelMode]);
    
    return routes[0];
}

@end
