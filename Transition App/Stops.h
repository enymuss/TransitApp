//
//  Stops.h
//  Transition App
//
//  Created by Richard Szczerba on 22/05/15.
//  Copyright (c) 2015 Richard Szczerba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stops : NSObject

@property (nonatomic) NSNumber* lat;
@property (nonatomic) NSNumber* lng;
@property (nonatomic) NSString* dateTime;
@property (nonatomic) NSString* name;
@property (nonatomic) id properties;

@end
