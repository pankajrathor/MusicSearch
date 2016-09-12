//
//  TrackListApiClientTests.m
//  MusicSearch
//
//  Created by Pankaj Rathor on 9/11/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TrackListApiClient.h"

@interface TrackListApiClient ()

@property (strong, nonatomic) NSURLSession *trackListSession;
@property (strong, nonatomic) NSURLSessionDataTask *trackListDataTask;
@property (strong, nonatomic) NSMutableArray *trackList;

@end

@interface TrackListApiClientTests : XCTestCase<TrackListApiClientDelegate>
@property(nonatomic,strong)TrackListApiClient *sut;
@property(nonatomic,strong)XCTestExpectation *expectation;
@end

@implementation TrackListApiClientTests

- (void) setUp {
    [super setUp];
    self.sut = [TrackListApiClient sharedInstance];
    self.sut.delegate = self;
}

- (void) tearDown {
    [super tearDown];
    self.sut = nil;
}

- (void)testGetTrackListWithSearchText {
    //Setup
    self.expectation = [self expectationWithDescription:@"testing getTrackListWithSearchText method."];
    
    //Execute
    [self.sut getTrackListWithSearchText:@"ttt"];
    [self waitForExpectationsWithTimeout:3.0 handler:nil];
}


- (void) didRecieveTracks:(NSArray *) tracks {
    [self.expectation fulfill];
    XCTAssertNotNil(tracks);
}

- (void) didRecieveError:(NSError *) error {
//NOP.
}


@end
