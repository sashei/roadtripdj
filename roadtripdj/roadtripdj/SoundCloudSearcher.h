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

@interface SoundCloudSearcher : NSObject

@property Track *track;

-(void)handleCity:(NSString *)city;

@end
