//
//  SHViewController.m
//  roadtripdj
//
//  Created by Sasha Heinen and Rupert Deese on 11/15/13.
//  Copyright (c) 2013 Sasha Heinen and Rupert Deese. All rights reserved.
//

#import "SHViewController.h"

@interface SHViewController ()

@end

@implementation SHViewController

- (id)init {
    self = [super init];
    if (self) {
        
        //****************************************** VIEW AND UI INITIALIZATION
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
        [_welcomeLabel setTextColor:[UIColor whiteColor]];
        [_welcomeLabel setTextAlignment:NSTextAlignmentCenter];
        [_welcomeLabel setFont:[UIFont fontWithName:@"Avenir-Roman" size:20]];
        [_welcomeLabel setBackgroundColor:[UIColor clearColor]];
        
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
        [_cityLabel setText:@"LOADING"];
        [_cityLabel setFont:[UIFont fontWithName:@"Avenir-Roman" size:35]];
        [_cityLabel setBackgroundColor:[UIColor clearColor]];
        
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
        [_songLabel setBackgroundColor:[UIColor clearColor]];
        
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
        [_artistLabel setBackgroundColor:[UIColor clearColor]];
        
        [self.view addSubview:_artistLabel];
        
        // soundcloud logo
        int logoSizeX = self.view.bounds.size.width *.4;
        int logoSizeY = logoSizeX;
        int logoX = CGRectGetMidX(self.view.frame) - logoSizeX *.5;
        int logoY = CGRectGetMidY(self.view.frame) - logoSizeX *.5;
        CGRect logoFrame = CGRectMake(logoX, logoY, logoSizeX, logoSizeY);
        
        _soundCloudLogo = [[UIImageView alloc] initWithFrame:logoFrame];
        [_soundCloudLogo setBackgroundColor:[UIColor clearColor]];
        NSString *imagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"sc_logo.png"];
        _soundCloudLogo.image = [UIImage imageWithContentsOfFile:imagePath];
        [_soundCloudLogo setContentMode:UIViewContentModeScaleAspectFit];
        [_soundCloudLogo setUserInteractionEnabled:YES];
        [_soundCloudLogo setTag:1];
        
        [self.view addSubview:_soundCloudLogo];
        
        _soundCloudHome = [NSURL URLWithString:@"http://www.soundcloud.com"];
        
        // gesture recognizer initialization
        _leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        [_leftSwipe setDelegate:self];
        _leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.view addGestureRecognizer:_leftSwipe];
        
        _rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        [_rightSwipe setDelegate:self];
        _rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:_rightSwipe];
        
        [self setStopLabels];
        
        //****************************************** END VIEW AND UI INITIALIZATION
        
        // For backgrounding music and using lock screen controls.
        if(&UIApplicationWillEnterForegroundNotification != nil)
        {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationReopened) name:UIApplicationWillEnterForegroundNotification object:nil];
        }
        
        NSError *trash;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&trash];
        NSLog(@"The error is: %@", trash);
        [[AVAudioSession sharedInstance] setActive: YES error: &trash];
        [[AVAudioSession sharedInstance] setDelegate:self];
        NSLog(@"The error is: %@", trash);
        
        // Set up the location manager
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager startMonitoringSignificantLocationChanges];
        _canLocate = true;
        //_prevLocality = @"";
        
        // Set up the geocoder
        self.geocoder = [[CLGeocoder alloc] init];
        // Create the cloud packet
        self.cloudPacket = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        // Set up the soundcloud searcher
        _cloud = [SoundCloudSearcher new];
        _cloud.target = self;
        _cloud.action = @selector(dataReturned:);
        
        // Initialize Reachability
        _reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
        
        __unsafe_unretained typeof(self) weakSelf = self;
        _reachability.reachableBlock = ^(Reachability *reachability) {
            [weakSelf didBecomeReachable];
            [weakSelf.locationManager startMonitoringSignificantLocationChanges];
        };
        _reachability.unreachableBlock = ^(Reachability *reachability) {
            [weakSelf didBecomeUnreachable];
            [weakSelf.locationManager stopMonitoringSignificantLocationChanges];
        };
        // Start Monitoring
        [_reachability startNotifier];
//        }
//        else {
//            [self goOffline];
//            _canLocate = false;
//        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //NSLog(@"is this even being called");
    //Once the view has loaded then we can register to begin recieving controls and we can become the first responder
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //End recieving events
    //NSLog(@"View disappearing!");
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}

/*
 * Handles reappearance of UI when the application reenters the foreground.
 */
-(void) applicationReopened
{
    //NSLog(@"entered dat foreground!");

    if (_player.playing) {
        float percentageFinished = _player.currentTime/_player.duration;
        float dDuration = (_player.duration - _player.currentTime)*1000;
        NSNumber *duration = [NSNumber numberWithFloat:dDuration];
        [self drawCircleWithDuration:duration fromCompletion:percentageFinished];
    }
    [_locationManager startMonitoringSignificantLocationChanges];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    if (!_player.isPlaying) {
        [_locationManager stopMonitoringSignificantLocationChanges];
    }
}

/*
 * Called when app regains network connectivity.
 */
- (void) didBecomeReachable {
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    _reachable = true;
    if (!_player.isPlaying && _canLocate) {
        [self setStopLabels];
    }
}

/*
 * Called when app loses network connectivity.
 */
- (void) didBecomeUnreachable {
    if (![_player isPlaying]) {
        [self goOffline];
        [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
        [self resignFirstResponder];
    }
    _reachable = false;
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
    _canLocate = true;
    if (!_player.isPlaying && _reachable) {
        [self setStopLabels];
    }
    
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
        
        [_welcomeLabel setText:@"Welcome to"];
        [_cityLabel setText:[[self.currentPlacemark locality] uppercaseString]];
        
//        if (_player == Nil ) {
//            _isGettingSong = true;
//            [_cloud handleCity:[_cloudPacket objectForKey:@"locality"]];
//            [self drawLoadingCircle];
//        }
//        else if (![_player isPlaying]) {
//            [self drawLoadingCircle];
//            [self playNextSong];
//        }
    }];
    
    return;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"getting location failed");
    _canLocate = false;
    if (!_player.isPlaying) {
        [self goOffline];
        [_locationManager stopMonitoringSignificantLocationChanges];
    }
}

#pragma mark Sound Cloud Searcher selector function
/*
 * Called by the soundcloud searcher after a new song has been found.
 * Starts playing the song, and updates fields
 */
- (void)dataReturned:(Track *)track {
    NSLog(@"Data returning");
    [_songLabel setText:[track.trackInformation objectForKey:@"title"]];
    [_artistLabel setText:[track.artistInformation objectForKey:@"full_name"]];
    _artistPage = [NSURL URLWithString:[track.artistInformation objectForKey:@"permalink_url"]];
    
    NSError *playerError;
    _player = [[AVAudioPlayer alloc] initWithData:track.data error:&playerError];
    NSLog(@"The player initializes with error: %@", playerError);
    _player.delegate = self;
    
    _player.volume = 1.0;
    
    [_player prepareToPlay];
    [_player play];
    [self drawCircleWithDuration:[track.trackInformation objectForKey:@"duration"] fromCompletion:0.0f];
    _isGettingSong = false;
    
    // Update now playing center
    if ([MPNowPlayingInfoCenter class])  {
        NSDictionary *currentlyPlayingTrackInfo = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:_songLabel.text, _artistLabel.text, [_currentPlacemark locality], [NSNumber numberWithDouble:_player.duration], [NSNumber numberWithDouble:_player.currentTime], [NSNumber numberWithFloat:1.0], nil] forKeys:[NSArray arrayWithObjects:MPMediaItemPropertyTitle, MPMediaItemPropertyArtist, MPMediaItemPropertyAlbumTitle, MPMediaItemPropertyPlaybackDuration, MPNowPlayingInfoPropertyElapsedPlaybackTime, MPNowPlayingInfoPropertyPlaybackRate, nil]];
        [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = currentlyPlayingTrackInfo;
    }
    
    return;
}

#pragma mark AV Audio Player interactions
/*
 * Called when the song is done, loads the next song.
 */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"Player is finished playing.");
    
//    if (_prevLocality != [_cloudPacket objectForKey:@"locality"]) {
//        [_cityLabel setText:[[_cloudPacket objectForKey:@"locality"] uppercaseString]];
//        _prevLocality = [_cloudPacket objectForKey:@"locality"];
//    }
    
    if (_reachable && _canLocate) {
        // Request another song from the soundcloud searcher, using the new location
        [self playNextSong];
        
    }
    else {
        [self goOffline];
    }
    
    return;
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    NSLog(@"Decode error from av player");
}

- (void) playNextSong {
    NSLog(@"From playNextSong: getting the next song");
    [_artistLabel setText:@"Loading"];
    [_songLabel setText:@""];
    _isGettingSong = true;
    [_cloud handleCity:[_cloudPacket objectForKey:@"locality"]];
    
    _artistPage = nil;
    
    if ([MPNowPlayingInfoCenter class])  {
        NSDictionary *currentlyPlayingTrackInfo = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"Loading", @"", [_currentPlacemark locality], [NSNumber numberWithDouble:0.0], [NSNumber numberWithDouble:0.0], [NSNumber numberWithFloat:1.0], nil] forKeys:[NSArray arrayWithObjects:MPMediaItemPropertyTitle, MPMediaItemPropertyArtist, MPMediaItemPropertyAlbumTitle, MPMediaItemPropertyPlaybackDuration, MPNowPlayingInfoPropertyElapsedPlaybackTime, MPNowPlayingInfoPropertyPlaybackRate, nil]];
        [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = currentlyPlayingTrackInfo;
    }
}

- (void) goOffline {
    [_welcomeLabel setText:@""];
    [_cityLabel setText:@"OFFLINE"];
    [_artistLabel setText:@""];
    [_player stop];
    [_songLabel setText:@"No connectivity."];
    [self killProgressAnimation];
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = nil;
}

- (void) skipTrack {
    if (_reachable && _canLocate) {
        if (!_isGettingSong) {
            if (!_player.isPlaying) {
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [_locationManager startMonitoringSignificantLocationChanges];
                [self becomeFirstResponder];
            }
            [self playNextSong];
            
            // Update the UI to the loading state
            [_player stop];
            [self killProgressAnimation];
            
            float percentageFinished = _player.currentTime/_player.duration;
            [self drawCircleWithDuration:[NSNumber numberWithFloat:3000.0] fromCompletion:percentageFinished];
        }
    }
    else {
        [self goOffline];
    }
}

- (void) stopMusic {
    if (!_isGettingSong && _player.isPlaying) {
        [self setStopLabels];
        [_player stop];
        [self killProgressAnimation];
        [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
        [_locationManager stopMonitoringSignificantLocationChanges];
        [self resignFirstResponder];
        [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = nil;
    }
}

- (void)noMusicForLocality {
    NSLog(@"We couldn't find any music for this place!");
}

# pragma mark Backgrounding
- (BOOL)canBecomeFirstResponder {
    return YES;
}

// Lock screen remote control actions.
- (void) remoteControlReceivedWithEvent: (UIEvent*) event
{
    if (event.type == UIEventTypeRemoteControl) {
        
        switch (event.subtype) {
                
            case UIEventSubtypeRemoteControlPause:
                [self stopMusic];
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
                [self skipTrack];
                break;
                
            default:
                break;
        }
    }
}


#pragma mark UI Helper functions.
/*
 * Get the next song for the user!
 */
- (void)handleGesture:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self skipTrack];
    }
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        [self stopMusic];
    }

    return;
}

/*
 * Create touch surface for links.
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    if (CGRectContainsPoint([_artistLabel frame], [touch locationInView:self.view]))
    {
        if (![[UIApplication sharedApplication] openURL:_artistPage])
            NSLog(@"%@%@",@"Failed to open url:",[_artistPage description]);
    } else if (CGRectContainsPoint([_soundCloudLogo frame], [touch locationInView:self.view])){
        if (![[UIApplication sharedApplication] openURL:_soundCloudHome])
            NSLog(@"%@%@",@"Failed to open url:",[_soundCloudHome description]);
    }
    
    return;
}

/*
 * Draw the circular song progress/loading bar.
 */
- (void)drawCircleWithDuration:(NSNumber *)duration fromCompletion:(float)percentage
{
    [self killProgressAnimation];
    
    int radius = 120;
    _progressCircle = [CAShapeLayer layer];
    
    _progressCircle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
                                                      cornerRadius:radius].CGPath;
    // Center the shape in self.view
    _progressCircle.position = CGPointMake(CGRectGetMidX(self.view.frame)-radius,
                                           CGRectGetMidY(self.view.frame)-radius);
    
    _progressCircle.fillColor = [UIColor clearColor].CGColor;
    _progressCircle.strokeColor = [UIColor whiteColor].CGColor;
    _progressCircle.lineWidth = 4;
    
    [self.view.layer addSublayer:_progressCircle];
    
    // Configure animation
    _progressAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    _progressAnimation.duration            = [duration doubleValue]/1000.0;
    _progressAnimation.repeatCount         = 1.0;
    _progressAnimation.removedOnCompletion = YES;
    _progressAnimation.delegate = self;
    [_progressAnimation setValue:_progressCircle forKey:@"parentLayer"];
    
    // Animate from no part of the stroke being drawn to the entire stroke being drawn
    _progressAnimation.fromValue = [NSNumber numberWithFloat:percentage];
    _progressAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
    
    // Experiment with timing to get the appearence to look the way you want
    _progressAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    // Add the animation to the circle
    [_progressCircle addAnimation:_progressAnimation forKey:@"drawCircleAnimation"];
    
    return;
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    CALayer *layer = [theAnimation valueForKey:@"parentLayer"];
    if( layer )
    {
        [layer removeFromSuperlayer];
    }
    
    if(flag && [_artistLabel.text isEqualToString:@"Loading"])
    {
        [self drawLoadingCircle];
    }
    
    return;
}

/*
 * Kills the song progress/loading circle.
 */
- (void)killProgressAnimation
{
    CALayer *layer = [_progressAnimation valueForKey:@"parentLayer"];
    if( layer )
    {
        [layer removeFromSuperlayer];
    }
}

/*
 * Draws the generic 5 second loading progress bar.
 */
- (void)drawLoadingCircle
{
    [self drawCircleWithDuration:[NSNumber numberWithFloat:5000.0f] fromCompletion:0.0f];
}

- (void)setStopLabels {
    [_artistLabel setText:@"Swipe right to stop"];
    [_songLabel setText:@"Swipe left to play or skip"];
}

@end
