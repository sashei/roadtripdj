//
//  SoundCloudSearcher.h
//  roadtripdj
//
//  Created by Sasha Heinen on 11/15/13.
//  Copyright (c) 2013 Sasha Heinen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Track.h"
#import "SCSoundCloud.h"
#import "SCAccount.h"
#import "SCRequest.h"
#import <stdlib.h>
#import "INETJSONData.h"
#import "INETData.h"

@interface SoundCloudSearcher : NSObject

@property NSString *city;
@property Track *track;

@property id target;
@property SEL action;

-(void)handleCity:(NSString *)city;

@end
