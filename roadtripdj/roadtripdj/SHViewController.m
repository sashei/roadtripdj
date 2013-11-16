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
        
        // view stuff
        // UIColors
        UIColor *peaColor = [UIColor colorWithRed:(88.0/255.0) green:(165.0/255.0) blue:(123.0/255.0) alpha:1.0];
        
        self.view.backgroundColor = peaColor;
        
        // welcome label
        int welcomeX = self.view.bounds.size.width *.05;
        int welcomeY = self.view.bounds.size.height *.05;
        int welcomeSizeX = self.view.bounds.size.width *.9;
        int welcomeSizeY = self.view.bounds.size.height*.1;
        CGRect welcomeFrame = CGRectMake(welcomeX, welcomeY, welcomeSizeX, welcomeSizeY);
        
        _welcomeLabel = [[UILabel alloc] initWithFrame:welcomeFrame];
        [_welcomeLabel setText:@"Welcome to"];
        [_welcomeLabel setTextColor:[UIColor whiteColor]];
        [_welcomeLabel setTextAlignment:NSTextAlignmentCenter];
        [_welcomeLabel setFont:[UIFont fontWithName:@"Avenir-Roman" size:20]];
        
        [self.view addSubview:_welcomeLabel];
        
        // city text
        int cityX = self.view.bounds.size.width *.05;
        int cityY = welcomeSizeY;
        int citySizeX = self.view.bounds.size.width *.9;
        int citySizeY = self.view.bounds.size.height *.15;
        CGRect cityFrame = CGRectMake(cityX, cityY, citySizeX, citySizeY);
        
        _cityLabel = [[UILabel alloc] initWithFrame:cityFrame];
        [_cityLabel setTextColor:[UIColor whiteColor]];
        [_cityLabel setTextAlignment:NSTextAlignmentCenter];
        [_cityLabel setFont:[UIFont fontWithName:@"Avenir-Roman" size:35]];
        
        [self.view addSubview:_cityLabel];
        
        // song name
        int songX = self.view.bounds.size.width *.05;
        int songY = self.view.bounds.size.height *.8;
        int songSizeX = self.view.bounds.size.width *.9;
        int songSizeY = self.view.bounds.size.height *.07;
        CGRect songFrame = CGRectMake(songX, songY, songSizeX, songSizeY);
        
        _songLabel = [[UILabel alloc] initWithFrame:songFrame];
        [_songLabel setTextColor:[UIColor whiteColor]];
        [_songLabel setTextAlignment:NSTextAlignmentCenter];
        [_songLabel setFont:[UIFont fontWithName:@"Avenir-Roman" size:20]];
        
        [self.view addSubview:_songLabel];
        
        // artist name
        int artX = self.view.bounds.size.width *.05;
        int artY = self.view.bounds.size.height *.87;
        int artSizeX = self.view.bounds.size.width *.9;
        int artSizeY = self.view.bounds.size.height *.075;
        CGRect artFrame = CGRectMake(artX, artY, artSizeX, artSizeY);
        
        _artistLabel = [[UILabel alloc] initWithFrame:artFrame];
        [_artistLabel setTextColor:[UIColor whiteColor]];
        [_artistLabel setTextAlignment:NSTextAlignmentCenter];
        [_artistLabel setFont:[UIFont fontWithName:@"Avenir-Roman" size:25]];
        [_artistLabel setUserInteractionEnabled:YES];
        [_artistLabel setTag:0];
        
        [self.view addSubview:_artistLabel];
        
        int logoSizeX = self.view.bounds.size.width *.25;
        int logoSizeY = logoSizeX;
        int logoX = CGRectGetMidX(self.view.frame) - logoSizeX *.5;
        int logoY = CGRectGetMidY(self.view.frame) - logoSizeX *.5;
        CGRect logoFrame = CGRectMake(logoX, logoY, logoSizeX, logoSizeY);
        
        
        // Set up the location manager
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager startMonitoringSignificantLocationChanges];
        
        // Set up the geocoder
        self.geocoder = [[CLGeocoder alloc] init];
        // Create the cloud packet
        self.cloudPacket = [NSMutableDictionary new];
        
        // Set up the soundcloud searcher
        self.cloud = [SoundCloudSearcher new];
        _cloud.target = self;
        _cloud.action = @selector(dataReturned:);

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

#pragma mark Location Manager Interactions
/*
 * Get the new location from the location manager.
 * TODO: Store some number of old locations in case new location has no music?
 * TODO: Actually send the cloudPacket to the soundcloudsearcher, update the player, etc
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // The last object in the NSArray is the most recent location.
    self.currentLocation = [locations lastObject];
    
    // Test that the horizontal accuracy does not indicate an invalid measurement
    if (self.currentLocation.horizontalAccuracy < 0) {
        NSLog(@"Location returned by manager is invalid.");
        return;
    }
    
    
    // Reverse geocode the location.
    [self.geocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        // For now, we just take the first placemark in the array if there is more than one.
        self.currentPlacemark = [placemarks objectAtIndex:0];
        // We put the locality into the cloudPacket
        [self.cloudPacket setValue:[self.currentPlacemark locality] forKey:@"locality"];
        
        [_cityLabel setText:[[self.currentPlacemark locality] uppercaseString]];
        
        if (_player == Nil) {
            [_cloud handleCity:[_cloudPacket objectForKey:@"locality"]];
        }
    }];
}


/*
 * Called by the soundcloud searcher after a new song has been found.
 * Starts playing the song, and updates fields
 */
- (void)dataReturned:(Track *)track {
    
    [_songLabel setText:[track.trackInformation objectForKey:@"title"]];
    [_artistLabel setText:[track.artistInformation objectForKey:@"full_name"]];
    
    NSError *playerError;
    _player = [[AVAudioPlayer alloc] initWithData:track.data error:&playerError];
    _player.delegate = self;

    _player.volume = 1.0;
    NSLog(@"%f", _player.duration);
    
    [_player prepareToPlay];
    [_player play];
    [self drawCircleWithDuration:[track.trackInformation objectForKey:@"duration"]];

    
    //if ([_player isPlaying])
    //    NSLog(@"LIFTOFF");
}

-(void)drawCircleWithDuration:(NSNumber *)duration
{
    int radius = 120;
    CAShapeLayer *circle = [CAShapeLayer layer];

    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
                                             cornerRadius:radius].CGPath;
    // Center the shape in self.view
    circle.position = CGPointMake(CGRectGetMidX(self.view.frame)-radius,
                                  CGRectGetMidY(self.view.frame)-radius);
    
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = [UIColor whiteColor].CGColor;
    circle.lineWidth = 4;
    
    [self.view.layer addSublayer:circle];
    
    // Configure animation
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration            = [duration doubleValue]/1000.0;
    drawAnimation.repeatCount         = 1.0;
    drawAnimation.removedOnCompletion = YES;
    drawAnimation.delegate = self;
    [drawAnimation setValue:circle forKey:@"parentLayer"];
    
    // Animate from no part of the stroke being drawn to the entire stroke being drawn
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
    
    // Experiment with timing to get the appearence to look the way you want
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    // Add the animation to the circle
    [circle addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
    
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    CALayer *layer = [theAnimation valueForKey:@"parentLayer"];
    if( layer )
    {
        [layer removeFromSuperlayer];
    }
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Getting location failed!");
}

#pragma mark AV Audio Player interactions

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    // Request another song from the soundcloud searcher, using the new location
    [_cloud handleCity:[_cloudPacket objectForKey:@"locality"]];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    NSLog(@"Decode error from av player");
}


- (void)noMusicForLocality {
    NSLog(@"We couldn't find any music for this place!");
}

@end
