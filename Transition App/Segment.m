//
//  Segment.m
//  Transition App
//
//  Created by Richard Szczerba on 22/05/15.
//  Copyright (c) 2015 Richard Szczerba. All rights reserved.
//

#import "Segment.h"

@implementation Segment

-(id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.name = dict[@"name"];
        self.numberStops = dict[@"num_stops"];
        self.stops = dict[@"stops"];
        self.travelMode = dict[@"travel_mode"];
        self.segmentDescription = dict[@"description"];
        self.color = dict[@"color"];
        self.iconURL = dict[@"icon_url"];
        self.polyline = dict[@"polyline"];
    }
    return  self;
}

@end
