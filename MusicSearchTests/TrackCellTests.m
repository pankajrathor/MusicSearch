//
//  TrackCellTests.m
//  MusicSearch
//
//  Created by Pankaj Rathor on 9/11/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TrackCell.h"
#import "SearchMusicViewController.h"
#import "Constants.h"

@interface TrackCell ()
    @property (weak, nonatomic) UILabel *songTitleLabel;
    @property (weak, nonatomic) UILabel *artistLabel;
    @property (weak, nonatomic) UIImageView *artworkImageView;
    @property (weak, nonatomic) UIProgressView *downloadProgressView;
    @property (weak, nonatomic) UIButton *downloadButton;
    @property (strong, nonatomic) Track *trackDetails;
@end

@interface SearchMusicViewController()

    @property (nonatomic) UITableView *tracksTableView;

@end

@interface TrackCellTests : XCTestCase
    @property (strong, nonatomic) TrackCell *sut;
@end

@implementation TrackCellTests

- (void) setUp {
    [super setUp];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    SearchMusicViewController *searchMusicViewController = (SearchMusicViewController *)[storyBoard instantiateViewControllerWithIdentifier:NSStringFromClass([SearchMusicViewController class])];
    [searchMusicViewController view];//Load View
    self.sut = (TrackCell *)[searchMusicViewController.tracksTableView dequeueReusableCellWithIdentifier:@"TrackCellIdentifier"];
}

- (void) tearDown {
    [super tearDown];
    self.sut = nil;
}

- (void) testUIInitialisation {
    //Setup
    NSString *trackName = @"dummyName";
    NSString *artist = @"dummyArtist";
    
    NSDictionary *dictionary = @{
                                 kTrackName : trackName,
                                 kArtist : artist
                                 };
    Track *track = [[Track alloc] initWithDictionary:dictionary];
    
    //Execute
    [self.sut setupTrackCell:track] ;
    
    //Verify
    XCTAssertTrue([self.sut.songTitleLabel.text isEqualToString:trackName]);
    XCTAssertTrue([self.sut.artistLabel.text isEqualToString:artist]);
}

- (void) hideOrShowProgressView {
    //Execute
    [self.sut hideProgressView:YES];
    
    //Verify
    XCTAssertTrue(self.sut.downloadProgressView.hidden);
}

- (void) testHideOrShowDownloadButton {
    //Execute
    [self.sut hideDownloadButton:YES];
    
    //Verify
    XCTAssertTrue(self.sut.downloadButton.hidden);
}

- (void) testSetProgressValue {
    //Execute
    [self.sut setProgressValue:0.5];
    
    //Verify
    XCTAssertEqual(self.sut.downloadProgressView.progress, 0.5);
}

- (void) testPreviewURL {
    Track *track = [[Track alloc] initWithDictionary:@{kPreviewUrl : @"/Users/dummy/Applications"}];
    [self.sut setupTrackCell:track];
    
    //Verify
    XCTAssertTrue([[self.sut previewURL] isEqualToString:@"/Users/dummy/Applications"]);
}

@end
