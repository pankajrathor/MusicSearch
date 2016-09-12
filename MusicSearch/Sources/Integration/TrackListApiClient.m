//
//  TrackListApiClient.m
//  This class downloads the list of matching results from the iTunes store. Search URL is https://itunes.apple.com/search?media=music&entity=song&term= 
//
//  Created by Pankaj Rathor on 10/09/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//

#import "TrackListApiClient.h"
#import "Constants.h"
#import "Track.h"
#import "TrackManager.h"

@interface TrackListApiClient ()

// Property to hold the NSURLSession object
@property (strong, nonatomic) NSURLSession *trackListSession;

// Property to hold the NSURLSessionDataTask to fetch the search results
@property (strong, nonatomic) NSURLSessionDataTask *trackListDataTask;

// Property to hold the list of tracks.
@property (strong, nonatomic) NSMutableArray *trackList;

@end

@implementation TrackListApiClient

+ (instancetype) sharedInstance {
    // Create a static instance for this class
    static TrackListApiClient *sharedInstance = nil;
    
    // dispatch_once implmentation to ensure only one instance of this class is created.
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TrackListApiClient alloc] init];
        // setup the NSURLSession
        [sharedInstance initializeSession];
    });
    
    // return the static instance
    return sharedInstance;
}

- (void) initializeSession {
    // Create NSURLSession with default Session configuration.
    self.trackListSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    // Initialize the trackList
    self.trackList = [[NSMutableArray alloc] init];
}

- (void) cancelSearchOperations {
    // Cancel the current running data task.
    if (self.trackListDataTask.state == NSURLSessionTaskStateRunning) {
        [self.trackListDataTask cancel];
    }
}

- (void) getTrackListWithSearchText:(NSString *) searchText {
    
    // Check if the search string is nil or empty
    if ((searchText != nil) && (searchText.length > 0)) {
        
        [self cancelSearchOperations];
        
        // URL Encoding will be required for the search term
        NSCharacterSet *expectedCharSet = [NSCharacterSet URLQueryAllowedCharacterSet];
        NSString *querySearchParameter = [searchText stringByAddingPercentEncodingWithAllowedCharacters:expectedCharSet];
        
        // Create a mutable string from the base url
        NSMutableString *searchUrlString = [NSMutableString stringWithString:iTunesUrlString];
        // Append the search term to the base url
        [searchUrlString appendString:querySearchParameter];
        
        // Create an NSURL out of the search URL string
        NSURL *searchUrl = [NSURL URLWithString:searchUrlString];
        
        __weak typeof(self) weakSelf = self;
        // Create a data task for intiating the request.
        self.trackListDataTask = [self.trackListSession dataTaskWithURL:searchUrl completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
            
            // Check if there is an error while getting the response.
            if (error == nil) {
                
                // Check for the status code if its 200 OK.
                if ([(NSHTTPURLResponse *)response statusCode] == 200) {
                    
                    // Parse the response data and save it in
                    [weakSelf createtrackListFromData:data];
                    
                    // Update the track list in the TrackManager
                    [[TrackManager sharedManager] addTrackList:weakSelf.trackList];
                    
                    // Check if the delegate object is valid.
                    if (weakSelf.delegate) {
                        if ([weakSelf.delegate respondsToSelector:@selector(didRecieveTracksComplete)]) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [weakSelf.delegate didRecieveTracksComplete];
                            });
                        }
                    }
                }
                else {
                    // Status code is not correct and hence we cannot proceed further.
                    NSLog(@"HTTP Status code is not OK: %d", (int)[(NSHTTPURLResponse *)response statusCode]);
                }
            }
            else {
                NSLog(@"Error retrieving track list: %@", error.localizedDescription);
                
                // If the search was cancelled, do not throw the error to the delegate.
                if (error.code == NSURLErrorCancelled) {
                    NSLog(@"Cancelled error");
                }
                else {
                    // Pass on the error information to the delegate
                    if (weakSelf.delegate) {
                        if ([weakSelf.delegate respondsToSelector:@selector(didRecieveError:)]) {
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [weakSelf.delegate didRecieveError:error];
                            });
                        }
                    }
                }
            }
        }];
        
        [self.trackListDataTask resume];
    }
}

// Method to parse the response NSData and store the Track object in an array.
- (void) createtrackListFromData:(NSData *) data {
    
    // Empty the track list. We have got new track list.
    [self.trackList removeAllObjects];
    
    // Error object for parsing JSON
    NSError *jsonParseError = nil;
    
    // Using NSJSONSerialization, convert the data to dictionary
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonParseError];
    
    // Check for any JSON parsing error.
    if (jsonParseError == nil) {
        
        // Get the array of searched tracks
        NSArray *trackArray = responseDictionary[@"results"];
        
        if (trackArray != nil && trackArray.count != 0) {
            
            // Iterate through the Array to get track Details dictionary for each result.
            [trackArray enumerateObjectsUsingBlock:^(NSDictionary *trackDetailsDictionary, NSUInteger idx, BOOL * _Nonnull stop) {
                Track *track = [[Track alloc] initWithDictionary:trackDetailsDictionary];
                [self.trackList addObject:track];
            }];
        }
        else {
            NSLog(@"No matching track found for the search.");
        }
            
    }
    else {
        NSLog(@"There was error parsing response: %@", jsonParseError.localizedDescription);
    }
}

@end
