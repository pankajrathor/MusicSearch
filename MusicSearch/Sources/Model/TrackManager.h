//
//  TrackManager.h
//  TrackManager class manages the tracks model objects matching the search term. 
//
//  Created by Pankaj Rathor on 12/09/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Track.h"

@interface TrackManager : NSObject

// Shared instance of the class.
+ (instancetype) sharedInstance;

// Add the list of tracks to the track manager
- (void) addTrackList:(NSArray *) trackList;

// Get the number of tracks in the track manager
- (NSUInteger) trackCount;

// Get the track for particular index path
- (Track *) trackAtIndex:(NSUInteger) index;

// Get the index of the track in the list
- (NSUInteger) indexForTrack:(Track *) track;

// Get the track from the previewUrl
- (Track *) trackFromPreviewUrl:(NSString *) previewUrl;

// Remove all tracks from the Track Manager
- (void) removeTrackList;

@end
