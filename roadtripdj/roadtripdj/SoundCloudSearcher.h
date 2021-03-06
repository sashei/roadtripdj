//
//  SoundCloudSearcher.h
//  roadtripdj
//
//  Created by Sasha Heinen and Rupert Deese on 11/15/13.
//  Copyright (c) 2013 Sasha Heinen and Rupert Deese. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Track.h"
#import "SCSoundCloud.h"
#import "SCAccount.h"
#import "SCRequest.h"
#import <stdlib.h>

@interface SoundCloudSearcher : NSObject

// For backgrounding.
@property (nonatomic, strong) NSDecimalNumber *previous;
@property (nonatomic, strong) NSDecimalNumber *current;
@property (nonatomic) NSUInteger position;
@property (nonatomic, strong) NSTimer *updateTimer;
@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;

@property NSString *city;
@property Track *track;

@property id target;
@property SEL action;

-(void)handleCity:(NSString *)city;

@end
