//
//  RouteParser.h
//  Transition App
//
//  Created by Richard Szczerba on 22/05/15.
//  Copyright (c) 2015 Richard Szczerba. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Route;

@interface RouteParser : NSObject

- (Route *)routeFromJSONData:(NSData *)jsonData;

@end
