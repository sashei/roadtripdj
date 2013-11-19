//
//  Track.h
//  roadtripdj
//
//  Created by Sasha Heinen and Rupert Deese on 11/15/13.
//  Copyright (c) 2013 Sasha Heinen and Rupert Deese. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Track : NSObject

@property NSMutableDictionary *trackInformation;
@property NSMutableDictionary *artistInformation;
@property NSData *data;

@end
