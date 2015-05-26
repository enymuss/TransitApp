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

@implementation ViewController{
    CLPlacemark *thePlacemark;
    MKRoute *routeDetails;
}

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
    _transportTypeSelected = CAR_SHARING;
    [self updateMapView];
}

- (IBAction)allClicked:(id)sender {
    _transportTypeSelected = ALL;
    [self updateMapView];
}

- (IBAction)currentLoctationClicked:(id)sender {
    if (self.locationManager == nil) {
        

        self.locationManager = [CLLocationManager new];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        [self.locationManager requestWhenInUseAuthorization];

    }
    
    _mapView.showsUserLocation = !_mapView.showsUserLocation;
    if (_mapView.showsUserLocation) {
        [_mapView setCenterCoordinate:_mapView.userLocation.coordinate animated:YES];
    }
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSLog(@"%f", userLocation.coordinate.latitude);
}

-(void) updateMapView {
    [self plotPostions:self.routesArray];
}

- (void)viewWillAppear:(BOOL)animated {
    
    CLLocationCoordinate2D zoomlocation;
    zoomlocation.latitude = 52.519978;
    zoomlocation.longitude = 13.401341;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomlocation, 5*METERS_PER_MILE, 5*METERS_PER_MILE);
    
    [self.locationManager startUpdatingLocation];
    
    [self.mapView setRegion:viewRegion animated:YES];
    NSString *URLString = @"https://gist.githubusercontent.com/sdoward/d1fc5662b6497a04a3c3/raw/484128fab9d10ab2b9ec320f7aece2f2fb099052/Allryder%20Response";
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString: URLString]];
    self.routesArray = [[RouteParser new] routeFromJSONData:data];
    [self plotPostions:self.routesArray];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
}

- (void)plotPostions:(NSArray *) routesArray {
    for (id<MKAnnotation> annotation in _mapView.annotations) {
        [_mapView removeAnnotation: annotation];
    }
    
    for (Route* route in routesArray) {
        if (route.transportType == _transportTypeSelected || _transportTypeSelected == ALL) {
            for (Segment* segment in route.segments) {
                for (Stop* stop in segment.stops) {
                    [_mapView addAnnotation:stop];
                }
            }
        }
    }
}

- (void)addressSearch:(MKAnnotationView *)sender {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:sender.annotation.coordinate.latitude
                                                      longitude:sender.annotation.coordinate.longitude];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            thePlacemark = [placemarks lastObject];
            [self routeButtonPressed];
        }
    }];
    
}

- (IBAction)routeButtonPressed {
        [_mapView removeOverlays:_mapView.overlays];
    MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:thePlacemark];
    [directionsRequest setSource:[MKMapItem mapItemForCurrentLocation]];
    [directionsRequest setDestination:[[MKMapItem alloc] initWithPlacemark:placemark]];
    directionsRequest.transportType = MKDirectionsTransportTypeWalking;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error %@", error.description);
        } else {
            routeDetails = response.routes.lastObject;
            [self.mapView addOverlay:routeDetails.polyline];
        }
    }];
    
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    MKPolylineRenderer  * routeLineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:routeDetails.polyline];
    routeLineRenderer.strokeColor = [UIColor redColor];
    routeLineRenderer.lineWidth = 5;
    return routeLineRenderer;
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *identifier = @"Stop";
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    if ([annotation isKindOfClass:[Stop class]]) {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            
        } else {
            annotationView.annotation = annotation;
        }
        return annotationView;
    }
    return nil;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    [self addressSearch:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
