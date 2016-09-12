//
//  TrackManager.m
//  TrackManager class manages the tracks model objects matching the search term.
//
//  Created by Pankaj Rathor on 12/09/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//

#import "TrackManager.h"

@interface TrackManager ()

// Maintain the track list in an array
@property (strong, nonatomic) NSArray *trackList;

@end

@implementation TrackManager

+ (instancetype) sharedInstance {
    // Create a static instance for this class
    static TrackManager *sharedInstance = nil;
    
    // dispatch_once implmentation to ensure only one instance of this class is created.
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TrackManager alloc] init];
    });
    
    // return the static instance
    return sharedInstance;
}

// Add the list of tracks to the track manager
- (void) addTrackList:(NSArray *) trackList {
    
    // Before
    [self removeTrackList];
    
    self.trackList = trackList;
    
}

// Get the number of tracks in the track manager
- (NSUInteger) trackCount {
    return (int)[self.trackList count];
}

// Get the track for particular index path
- (Track *) trackAtIndex:(NSUInteger) index {
    
    return self.trackList[index];
}

// Get the track from the previewUrl
- (Track *) trackFromPreviewUrl:(NSString *) previewUrl {
    
    NSPredicate *previewUrlPredicate = [NSPredicate predicateWithFormat:@"%@ == previewURL",previewUrl];
    
    Track *track = [self.trackList filteredArrayUsingPredicate:previewUrlPredicate].firstObject;
    
    return track;
}

// Get the index of the track
- (NSUInteger) indexForTrack:(Track *) track {
    return (int)[self.trackList indexOfObject:track];
}

// Remove all tracks from the Track Manager
- (void) removeTrackList {
    
    // Enumerate through each of the track and delete the preview files.
    [self.trackList enumerateObjectsUsingBlock:^(Track *track, NSUInteger idx, BOOL * stop) {
        [track deletePreviewFile];
    }];
    
    self.trackList = nil;
}

@end
