//
//  ViewController.m
//  Transition App
//
//  Created by Richard Szczerba on 22/05/15.
//  Copyright (c) 2015 Richard Szczerba. All rights reserved.
//

#import "ViewController.h"
#import "RouteParser.h"

#define VIEW_REGION 5000

@interface ViewController ()

@property (nonatomic) TrsansportationType transportTypeSelected;
@property (nonatomic) NSArray *routesArray;
@property (nonatomic) CLPlacemark *thePlacemark;
@property (nonatomic) MKRoute *routeDetails;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    
    CLLocationCoordinate2D zoomlocation;
    zoomlocation.latitude = 52.519978;
    zoomlocation.longitude = 13.401341;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomlocation, VIEW_REGION, VIEW_REGION);
    
    [self.locationManager startUpdatingLocation];
    
    [self.mapView setRegion:viewRegion animated:YES];
    
    NSString *JSONURLString = @"https://gist.githubusercontent.com/sdoward/d1fc5662b6497a04a3c3/raw/484128fab9d10ab2b9ec320f7aece2f2fb099052/Allryder%20Response";
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString: JSONURLString]];
    _routesArray = [[RouteParser new] routeFromJSONData:data];
    [self plotStops:_routesArray];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateMapView {
    [self plotStops:_routesArray];
}

- (void)plotStops:(NSArray *)routesArray {
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        [self.mapView removeAnnotation: annotation];
    }
    
    for (Route *route in routesArray) {
        if (_transportTypeSelected == route.transportType||
            _transportTypeSelected == ALL) {
            for (Segment *segment in route.segments) {
                for (Stop *stop in segment.stops) {
                    [self.mapView addAnnotation:stop];
                }
            }
        }
    }
}

- (void)annotationButtonTapped {
    //remove previous routes
    [self.mapView removeOverlays:self.mapView.overlays];
    
    MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:_thePlacemark];
    [directionsRequest setSource:[MKMapItem mapItemForCurrentLocation]];
    [directionsRequest setDestination:[[MKMapItem alloc] initWithPlacemark:placemark]];
    directionsRequest.transportType = MKDirectionsTransportTypeWalking;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error %@", error.description);
        } else {
            _routeDetails = response.routes.lastObject;
            [self.mapView addOverlay:_routeDetails.polyline];
        }
    }];
    
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *identifier = @"Stop";
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    if ([annotation isKindOfClass:[Stop class]]) {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
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


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    if (self.mapView.showsUserLocation) {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:view.annotation.coordinate.latitude
                                                          longitude:view.annotation.coordinate.longitude];
        
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error) {
                NSLog(@"%@", error);
            } else {
                _thePlacemark = [placemarks lastObject];
                [self annotationButtonTapped];
            }
        }];
    } else {
        UIAlertView *noUserLocationAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Error" message:@"Your current location is needed for this task" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"Get Location", nil];
        [noUserLocationAlert show];
    }
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"Get Location"]) {
        [self requestUserLocation];
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    MKPolylineRenderer  *routeLineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:_routeDetails.polyline];
    routeLineRenderer.strokeColor = [UIColor redColor];
    routeLineRenderer.lineWidth = 5;
    return routeLineRenderer;
}

#pragma mark - IBActions

- (IBAction)publicTransportTapped:(UIBarButtonItem *)sender {
    _transportTypeSelected = PUBLIC_TRANSPORT;
    [self updateMapView];
}

- (IBAction)bikeSharingTapped:(UIBarButtonItem *)sender {
    _transportTypeSelected = BIKE_SHARING;
    [self updateMapView];
}

- (IBAction)privateBikeTapped:(UIBarButtonItem *)sender {
    _transportTypeSelected = PRIVATE_BIKE;
    [self updateMapView];
}

- (IBAction)taxiTapped:(UIBarButtonItem *)sender {
    _transportTypeSelected = TAXI;
    [self updateMapView];
}

- (IBAction)carSharingTapped:(id)sender {
    _transportTypeSelected = CAR_SHARING;
    [self updateMapView];
}

- (IBAction)allTapped:(id)sender {
    _transportTypeSelected = ALL;
    [self updateMapView];
}

- (IBAction)currentLoctationTapped:(id)sender {
    // request user location once they tap button
    if (self.locationManager == nil) {
        [self requestUserLocation];
    }
    
    self.mapView.showsUserLocation = !self.mapView.showsUserLocation;
    if (self.mapView.showsUserLocation) {
        [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
    }
}

- (void) requestUserLocation {
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager requestWhenInUseAuthorization];
}

@end
