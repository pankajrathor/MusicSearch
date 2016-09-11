//
//  TrackTests.m
//  MusicSearch
//
//  Created by Pankaj Rathor on 9/11/16.
//  Copyright © 2016 Pankaj Rathor. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Constants.h"
#import "Track.h"

@interface TrackTests : XCTestCase

@end

@implementation TrackTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

/*
 * We are passing a dictionary with all the fields filled.
 * Expected result is that all the fields should have valid data.
 */
- (void)testAccountInstantiationAndParsing {
    //Setup
    NSString *trackName = @"dummyName";
    NSString *artist = @"dummyArtist";
    NSString *previewURL = @"dummyURL";
    NSString *artWorkURL = @"dummyArtworkName";
    
    NSDictionary *dictionary = @{
                                 kTrackName : trackName,
                                 kArtist : artist,
                                 kPreviewUrl : previewURL,
                                 kArtworkUrl : artWorkURL
                                 };
    
    //Execute
    Track *track = [[Track alloc] initWithDictionary:dictionary];
    
    //Verify
    XCTAssertTrue([track.name isEqualToString:trackName]);
    XCTAssertTrue([track.artist isEqualToString:artist]);
    XCTAssertTrue([track.previewURL isEqualToString:previewURL]);
    XCTAssertTrue([track.artworkURL isEqualToString:artWorkURL]);
}

/*
 * We are not passing TrackName and Artist in the dictionary.
 * Expected result is that these two fields should be initialised to nil. Rest of the fields should have valid data
 */
- (void)testParsingWithPartialDataParsing {
    //Setup
    NSString *previewURL = @"dummyURL";
    NSString *artWorkURL = @"dummyArtworkName";
    
    NSDictionary *dictionary = @{
                                 kPreviewUrl : previewURL,
                                 kArtworkUrl : artWorkURL
                                 };
    
    //Execute
    Track *track = [[Track alloc] initWithDictionary:dictionary];
    
    //Verify
    XCTAssertNil(track.name);
    XCTAssertNil(track.artist);
    XCTAssertTrue([track.previewURL isEqualToString:previewURL]);
    XCTAssertTrue([track.artworkURL isEqualToString:artWorkURL]);
}

- (void)testPreviewLocalURL {
    //Setup
    Track *track = [[Track alloc] initWithDictionary:@{kPreviewUrl : @"/Users/Dummy/Applications"}];
    
    //Verify
    XCTAssertNil(track.previewLocalURL);
}


@end
