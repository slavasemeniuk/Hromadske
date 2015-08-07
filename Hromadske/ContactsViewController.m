//
//  ContactsViewController.m
//  Hromadske
//
//  Created by Admin on 19.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "ContactsViewController.h"
#import "Contacts.h"
#import <QuartzCore/QuartzCore.h>
#import <GoogleMaps/GoogleMaps.h>

@interface ContactsViewController ()
@property (weak, nonatomic) IBOutlet UILabel* adress;
@property (weak, nonatomic) IBOutlet UILabel* email;
@property (weak, nonatomic) IBOutlet UILabel* phone;
@property (weak, nonatomic) IBOutlet UIView* mapView;
@end

@implementation ContactsViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setUpMap];
}

- (void)setUpMap
{
    GMSCameraPosition* camera = [GMSCameraPosition cameraWithLatitude:49.445570 longitude:32.062412 zoom:18];
    GMSMapView* googleMapView = [GMSMapView mapWithFrame:_mapView.bounds camera:camera];

    GMSMarker* marker = [[GMSMarker alloc] init];
    marker.position = camera.target;
    marker.snippet = @"ГромадськеТВ";
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.map = googleMapView;
    [_mapView addSubview:googleMapView];
}

@end
