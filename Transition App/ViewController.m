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
#import "Segment.h"
#import "Stop.h"

#define METERS_PER_MILE 1609.344

@interface ViewController ()
@property (nonatomic) TrsansportationType transportTypeSelected;
@property (nonatomic) NSArray* routesArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(IBAction)publicTransportClicked:(UIBarButtonItem *)sender {
    _transportTypeSelected = PUBLIC_TRANSPORT;
    [self updateMapView];
}

- (IBAction)bikeSharingClicked:(UIBarButtonItem *)sender {
    _transportTypeSelected = BIKE_SHARING;
    [self updateMapView];
}

- (IBAction)privateBikeClicked:(UIBarButtonItem *)sender {
    _transportTypeSelected = PRIVATE_BIKE;
    [self updateMapView];
}

- (IBAction)taxiClicked:(UIBarButtonItem *)sender {
    _transportTypeSelected = TAXI;
    [self updateMapView];
}

- (IBAction)carSharingClicked:(id)sender {
}

- (IBAction)carShringClicked:(id)sender {
}

-(void) updateMapView {
    [self plotPostions:self.routesArray];
}

- (void)viewWillAppear:(BOOL)animated {
    
    CLLocationCoordinate2D zoomlocation;
    zoomlocation.latitude = 52.519978;
    zoomlocation.longitude = 13.401341;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomlocation, 5*METERS_PER_MILE, 5*METERS_PER_MILE);
    
    [self.mapView setRegion:viewRegion animated:YES];
    NSString *URLString = @"https://gist.githubusercontent.com/sdoward/d1fc5662b6497a04a3c3/raw/484128fab9d10ab2b9ec320f7aece2f2fb099052/Allryder%20Response";
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString: URLString]];
    self.routesArray = [[RouteParser new] routeFromJSONData:data];
    [self plotPostions:self.routesArray];
}



- (void)plotPostions:(NSArray *) routesArray {
    for (id<MKAnnotation> annotation in _mapView.annotations) {
        [_mapView removeAnnotation: annotation];
    }
    
    for (Route* route in routesArray) {
        if (route.transportType == _transportTypeSelected || _transportTypeSelected == NONE) {
            for (Segment* segment in route.segments) {
                for (Stop* stop in segment.stops) {
                    [_mapView addAnnotation:stop];
                }
            }
        }
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *identifier = @"Stop";
    if ([annotation isKindOfClass:[Stop class]]) {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
        } else {
            annotationView.annotation = annotation;
        }
        return annotationView;
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
