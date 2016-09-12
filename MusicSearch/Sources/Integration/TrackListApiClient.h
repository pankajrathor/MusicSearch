//
//  TrackListApiClient.h
//  This class downloads the list of matching results from the iTunes store. Search URL is https://itunes.apple.com/search?media=music&entity=song&term= 
//
//  Created by Pankaj Rathor on 10/09/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Track.h"

// Protocol for providing the search results to the delegate object.
@protocol TrackListApiClientDelegate <NSObject>

// Delegate method to provide the search results.
- (void) didRecieveTracksComplete;

// Delegate method in case there is an error retrieving the response.
- (void) didRecieveError:(NSError *) error;

@end

// This class is responsible for initiating the request to download the search result with the matching search term.
@interface TrackListApiClient : NSObject

// Delegate instance for sending the delegate messages
@property (weak, nonatomic) id<TrackListApiClientDelegate> delegate;

// Create a shared instance of the class.
+ (instancetype) sharedInstance;

// Method to initiate the request for searching tracks with the search text.
- (void) getTrackListWithSearchText:(NSString *) searchText;

// Method to Cancel the currently running search operation.
- (void) cancelSearchOperations;

@end
