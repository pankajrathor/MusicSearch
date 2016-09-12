//
//  TrackListActivityTests.m
//  MusicSearch
//
//  Created by Pankaj Rathor on 9/11/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TrackListActivity.h"

@interface TrackListActivity ()

@property (strong, nonatomic) NSURLSession *songListSession;
@property (strong, nonatomic) NSURLSessionDataTask *songListDataTask;
@property (strong, nonatomic) NSMutableArray *songList;

@end

@interface TrackListActivityTests : XCTestCase<TrackListActivityDelegate>
@property(nonatomic,strong)TrackListActivity *sut;
@property(nonatomic,strong)XCTestExpectation *expectation;
@end

@implementation TrackListActivityTests

- (void)setUp {
    [super setUp];
    self.sut = [TrackListActivity sharedInstance];
    self.sut.delegate = self;
}

- (void)tearDown {
    [super tearDown];
    self.sut = nil;
}

- (void)testGetSongListWithSearchText {
    //Setup
    self.expectation = [self expectationWithDescription:@"testing getSongListWithSearchText method."];
    
    //Execute
    [self.sut getSongListWithSearchText:@"ttt"];
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
