//
//  Segment.h
//  Transition App
//
//  Created by Richard Szczerba on 22/05/15.
//  Copyright (c) 2015 Richard Szczerba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Segment : NSObject

@property (nonatomic) NSString* name;
@property (nonatomic) NSNumber* numberStops;
@property (nonatomic) NSDictionary* stops;
@property (nonatomic) NSString* travelMode;
@property (nonatomic) NSString* segmentDescription;
@property (nonatomic) NSString* color;
@property (nonatomic) NSString* iconURL;
@property (nonatomic) NSString* polyline;


@end