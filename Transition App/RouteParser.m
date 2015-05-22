//
//  RouteParser.m
//  Transition App
//
//  Created by Richard Szczerba on 22/05/15.
//  Copyright (c) 2015 Richard Szczerba. All rights reserved.
//

#import "RouteParser.h"
#import "Route.h"
#import "Segment.h"
#import "Stops.h"

@implementation RouteParser

- (Route *)routeFromJSONData:(NSData *)jsonData {
    id json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
    NSMutableArray *routes = [NSMutableArray new];
    
    for (NSDictionary *routeDict in json[@"routes"]) {
        Route *route = [Route new];
        route.type = routeDict[@"type"];
        route.provider = routeDict[@"provider"];
        route.properties = routeDict[@"properties"];
        route.price = routeDict[@"price"];
        
        NSMutableArray *segmentsArray = [NSMutableArray new];
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
            
            NSMutableArray *stopsArray = [NSMutableArray new];
            for (NSDictionary *stopsDict in segmentsDict[@"stops"]) {
                Stops *stop = [Stops new];
                
                stop.lat = stopsDict[@"lat"];
                stop.lng = stopsDict[@"lng"];
                stop.dateTime = stopsDict[@"datetime"];
                stop.name = stopsDict[@"name"];
                stop.properties = stopsDict[@"properties"];
                
                [stopsArray addObject:stop];
            }
            segment.stops = stopsArray;
            [segmentsArray addObject:segment];
        }
        route.segments = segmentsArray;
        [routes addObject:route];
    }
    
    return routes[0];
}

@end
