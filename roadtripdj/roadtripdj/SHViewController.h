//
//  SHViewController.h
//  roadtripdj
//
//  Created by Sasha Heinen on 11/15/13.
//  Copyright (c) 2013 Sasha Heinen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SoundCloudSearcher.h"

@interface SHViewController : UIViewController <CLLocationManagerDelegate>

@property CLLocationManager *locationManager;
@property CLLocation *currentLocation;
@property CLGeocoder *geocoder;
@property CLPlacemark *currentPlacemark;
@property NSMutableDictionary *cloudPacket; //data going to the soundcloud searcher
@property SoundCloudSearcher *cloud;

// Called by the SoundCloudSearcher when no music is available for the last locality
- (void)noMusicForLocality;



@end
