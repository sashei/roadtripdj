//
//  SHViewController.m
//  roadtripdj
//
//  Created by Sasha Heinen on 11/15/13.
//  Copyright (c) 2013 Sasha Heinen. All rights reserved.
//

#import "SHViewController.h"

@interface SHViewController ()

@end

@implementation SHViewController

- (id)init {
    self = [super init];
    if (self) {
        //NSLog(@"loading..");
        // Set up the location manager
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager startMonitoringSignificantLocationChanges];
        
        // Set up the geocoder
        self.geocoder = [[CLGeocoder alloc] init];
        // Create the cloud packet
        self.cloudPacket = [NSMutableDictionary new];
        //NSLog(@"Loaded!");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 * Get the new location from the location manager.
 * TODO: Store some number of old locations in case new location has no music?
 * TODO: Actually send the cloudPacket to the soundcloudsearcher, update the player, etc
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // The last object in the NSArray is the most recent location.
    self.currentLocation = [locations lastObject];
    
    // test that the horizontal accuracy does not indicate an invalid measurement

    if (self.currentLocation.horizontalAccuracy < 0) {
        NSLog(@"Location returned by manager is invalid.");
        return;
    }
    
    //NSLog(@"%f", [self.currentLocation horizontalAccuracy]);
    
    // Reverse geocode the location.
    [self.geocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        // For now, we just take the first placemark in the array if there is more than one.
        self.currentPlacemark = [placemarks objectAtIndex:0];
        NSLog([self.currentPlacemark locality]);
        
        // We put the locality into the cloudPacket
        [self.cloudPacket setValue:[self.currentPlacemark locality] forKey:@"locality"];
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Getting location failed!");
}

- (void)noMusicForLocality {
    NSLog(@"We couldn't find any music for this place!");
}

@end
