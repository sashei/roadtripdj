//
//  SHViewController.h
//  roadtripdj
//
//  Created by Sasha Heinen and Rupert Deese on 11/15/13.
//  Copyright (c) 2013 Sasha Heinen and Rupert Deese. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SoundCloudSearcher.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <SoundCloudSearcher.h>
#import <Reachability.h>

@interface SHViewController : UIViewController <CLLocationManagerDelegate, AVAudioPlayerDelegate, UIGestureRecognizerDelegate>

@property CLLocationManager *locationManager;
@property CLLocation *currentLocation;
@property CLGeocoder *geocoder;
@property CLPlacemark *currentPlacemark;
@property NSString *prevLocality;

@property Reachability *reachability;
@property BOOL reachable;

@property AVAudioSession *session;
@property AVAudioPlayer *player;
@property BOOL isGettingSong;

@property NSMutableDictionary *cloudPacket; //data going to the soundcloud searcher
@property SoundCloudSearcher *cloud;
@property NSMutableDictionary *songData;

@property UISwipeGestureRecognizer *leftSwipe;
@property UISwipeGestureRecognizer *rightSwipe;

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
- (void) didBecomeUnreachable;
- (void) didBecomeReachable;

//- (void)songDataReceived;

@end
