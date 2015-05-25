//
//  ViewController.m
//  Transition App
//
//  Created by Richard Szczerba on 22/05/15.
//  Copyright (c) 2015 Richard Szczerba. All rights reserved.
//

#import "ViewController.h"
#import "RouteParser.h"
#import "Route.h"
#import "Locations.h"
#import "Segment.h"
#import "Stops.h"

#define METERS_PER_MILE 1609.344

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    
    CLLocationCoordinate2D zoomlocation;
    zoomlocation.latitude = 52;
    zoomlocation.longitude = 15;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomlocation, METERS_PER_MILE, METERS_PER_MILE);
    
    [self.mapView setRegion:viewRegion animated:YES];
    NSString *URLString = @"https://gist.githubusercontent.com/sdoward/d1fc5662b6497a04a3c3/raw/484128fab9d10ab2b9ec320f7aece2f2fb099052/Allryder%20Response";
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString: URLString]];
    NSArray* routesArray = [[RouteParser new] routeFromJSONData:data];
    [self plotPostions:routesArray];
    
}

- (void)plotPostions:(NSArray *) routesArray {
    for (id<MKAnnotation> annotation in _mapView.annotations) {
        [_mapView removeAnnotation: annotation];
    }
    
    for (Route* route in routesArray) {
        for (Segment* segment in route.segments) {
            for (Stops* stop in segment.stops) {
                CLLocationCoordinate2D coordinate;
                coordinate.latitude = stop.lat.doubleValue;
                coordinate.longitude = stop.lng.doubleValue;
                
                Locations *annotation = [[Locations alloc] initWithName:stop.name address:nil coordinate:coordinate];
                
                [_mapView addAnnotation:annotation];
            }
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
