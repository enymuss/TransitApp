//
//  ViewController.h
//  Transition App
//
//  Created by Richard Szczerba on 22/05/15.
//  Copyright (c) 2015 Richard Szczerba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) CLLocationManager *locationManager;

- (IBAction)allTapped:(id)sender;
- (IBAction)publicTransportTapped:(id)sender;
- (IBAction)bikeSharingTapped:(id)sender;
- (IBAction)privateBikeTapped:(id)sender;
- (IBAction)taxiTapped:(id)sender;
- (IBAction)carSharingTapped:(id)sender;

- (IBAction)currentLoctationTapped:(id)sender;


@end

