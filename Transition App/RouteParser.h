//
//  RouteParser.h
//  Transition App
//
//  Created by Richard Szczerba on 22/05/15.
//  Copyright (c) 2015 Richard Szczerba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Route.h"
#import "Segment.h"
#import "Stop.h"

@interface RouteParser : NSObject

- (NSArray *)routeFromJSONData:(NSData *)JSONData;

@end
