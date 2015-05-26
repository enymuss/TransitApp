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

@interface ViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView* mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;

- (IBAction)publicTransportClicked:(id)sender;
- (IBAction)bikeSharingClicked:(id)sender;
- (IBAction)privateBikeClicked:(id)sender;
- (IBAction)taxiClicked:(id)sender;
- (IBAction)carSharingClicked:(id)sender;
- (IBAction)allClicked:(id)sender;

- (IBAction)currentLoctationClicked:(id)sender;


@end

