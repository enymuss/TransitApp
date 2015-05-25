//
//  Segment.m
//  Transition App
//
//  Created by Richard Szczerba on 22/05/15.
//  Copyright (c) 2015 Richard Szczerba. All rights reserved.
//

#import "Segment.h"
#import "Route.h"

@implementation Segment

-(NSArray *)segmentsFromRoute:(Route *)route {
    NSMutableArray *segmentsArray = [NSMutableArray new];
    
    for (NSDictionary *segmentsDict in route.segments) {
        Segment *segment = [Segment new];
        
        segment.name = segmentsDict[@"name"];
        segment.numberStops = segmentsDict[@"num_stops"];
        segment.stops = segmentsDict[@"stops"];
        segment.travelMode = segmentsDict[@"travel_mode"];
        segment.segmentDescription = segmentsDict[@"description"];
        segment.color = segmentsDict[@"color"];
        segment.iconURL = segmentsDict[@"icon_url"];
        segment.polyline = segmentsDict[@"polyline"];
        
        [segmentsArray addObject:segment];
    }
    
    return segmentsArray;
}

@end
