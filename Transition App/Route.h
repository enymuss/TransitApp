//
//  Route.h
//  Transition App
//
//  Created by Richard Szczerba on 22/05/15.
//  Copyright (c) 2015 Richard Szczerba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Route : NSObject

@property (nonatomic) NSString* type;
@property (nonatomic) NSString* provider;
@property (nonatomic) NSMutableArray* segments;
@property (nonatomic) NSDictionary* properties;
@property (nonatomic) NSDictionary* price;


@end
