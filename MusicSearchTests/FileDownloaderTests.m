//
//  FileDownloaderTests.m
//  MusicSearch
//
//  Created by Pankaj Rathor on 9/11/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FileDownloader.h"

@interface FileDownloaderTests : XCTestCase<FileDownloaderDelegate>
@property(nonatomic,strong)FileDownloader *sut;
@property(nonatomic,strong)XCTestExpectation *expectation;
@end

@implementation FileDownloaderTests

- (void)setUp {
    [super setUp];
    self.sut = [[FileDownloader alloc] init];
    self.sut.delegate = self;
}

- (void)tearDown {
    [super tearDown];
    self.sut = nil;
}

- (void)testDownloadURL {
    //Setup
    NSString *url = @"http://a856.phobos.apple.com/us/r30/Music6/v4/95/30/d4/9530d4c0-d0f9-4c48-3780-87c4d50616f9/mzaf_1979732190213671487.plus.aac.p.m4a";
    self.expectation = [self expectationWithDescription:@"testing getSongListWithSearchText method."];
    
    //Execeute
    [self.sut downloadFileWithURL:[NSURL URLWithString:url]];
    [self waitForExpectationsWithTimeout:3.0 handler:nil];
}


- (void) fileDownloader:(FileDownloader *) downloader didFinishDownloadingToURL:(NSURL *)location {
    [self.expectation fulfill];
}

- (void) fileDownloader:(FileDownloader *) downloader totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    //NOP
}

- (void) fileDownloader:(FileDownloader *) downloader didCompleteWithError:(NSError *)error {
    //NOP
}

@end
