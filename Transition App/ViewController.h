//
//  ViewController.h
//  Transition App
//
//  Created by Richard Szczerba on 22/05/15.
//  Copyright (c) 2015 Richard Szczerba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView* mapView;

- (IBAction)publicTransportClicked:(id)sender;
- (IBAction)bikeSharingClicked:(id)sender;
- (IBAction)privateBikeClicked:(id)sender;
- (IBAction)taxiClicked:(id)sender;
- (IBAction)carSharingClicked:(id)sender;


@end

