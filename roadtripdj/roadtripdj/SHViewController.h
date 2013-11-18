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
#import <AVFoundation/AVFoundation.h>
#import <SoundCloudSearcher.h>
#import <Reachability.h>

@interface SHViewController : UIViewController <CLLocationManagerDelegate, AVAudioPlayerDelegate, UIGestureRecognizerDelegate>

@property CLLocationManager *locationManager;
@property CLLocation *currentLocation;
@property CLGeocoder *geocoder;
@property CLPlacemark *currentPlacemark;
@property NSString *prevLocality;

@property Reachability *reachability;

@property AVAudioSession *session;
@property AVAudioPlayer *player;
@property NSMutableDictionary *cloudPacket; //data going to the soundcloud searcher
@property SoundCloudSearcher *cloud;
@property NSMutableDictionary *songData;

@property UISwipeGestureRecognizer *swipeRecognizer;

@property UILabel *welcomeLabel;
@property UILabel *cityLabel;
@property UILabel *songLabel;
@property UILabel *artistLabel;

@property CAShapeLayer *progressCircle;
@property CABasicAnimation *progressAnimation;

@property UIImageView *soundCloudLogo;

@property NSURL *artistPage;
@property NSURL *soundCloudHome;

// Called by the SoundCloudSearcher when no music is available for the last locality
- (void)noMusicForLocality;
- (void)dataReturned:(Track *)track;
- (void)reachabilityDidChange:(NSNotification *)notification;

//- (void)songDataReceived;

@end
