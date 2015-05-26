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
#import "Stop.h"

@implementation RouteParser

- (NSArray *)routeFromJSONData:(NSData *)jsonData {
    id json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
    NSMutableArray *routes = [NSMutableArray new];
    
    for (NSDictionary *routeDict in json[@"routes"]) {
        Route *route = [Route new];
        route.transportType = [route assignTransportationTypeFromString:routeDict[@"type"]];
        route.provider = routeDict[@"provider"];
        route.properties = routeDict[@"properties"];
        route.price = routeDict[@"price"];
        
        NSMutableArray *segmentsArray = [NSMutableArray new];
        for (NSDictionary *segmentsDict in routeDict[@"segments"]) {
            Segment *segment = [[Segment alloc] initWithDictionary:segmentsDict];
            
            NSMutableArray *stopsArray = [NSMutableArray new];
            for (NSDictionary *stopsDict in segmentsDict[@"stops"]) {
                NSString *name = stopsDict[@"name"];
                NSString *date = stopsDict[@"datetime"];
                
                NSNumber* lat = stopsDict[@"lat"];
                NSNumber* lng = stopsDict[@"lng"];
                CLLocationCoordinate2D coordinate;
                coordinate.latitude = lat.doubleValue;
                coordinate.longitude = lng.doubleValue;
                
                Stop *stop = [[Stop alloc] initWithName:name dateTime:date coordinate:coordinate];
                
                stop.properties = stopsDict[@"properties"];
                stop.route = route;
                
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
