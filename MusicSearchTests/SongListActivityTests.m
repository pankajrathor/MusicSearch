//
//  SongListActivityTests.m
//  MusicSearch
//
//  Created by Pankaj Rathor on 9/11/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SongListActivity.h"

@interface SongListActivity ()

@property (strong, nonatomic) NSURLSession *songListSession;
@property (strong, nonatomic) NSURLSessionDataTask *songListDataTask;
@property (strong, nonatomic) NSMutableArray *songList;

@end

@interface SongListActivityTests : XCTestCase<SongListActivityDelegate>
@property(nonatomic,strong)SongListActivity *sut;
@property(nonatomic,strong)XCTestExpectation *expectation;
@end

@implementation SongListActivityTests

- (void)setUp {
    [super setUp];
    self.sut = [SongListActivity sharedInstance];
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
