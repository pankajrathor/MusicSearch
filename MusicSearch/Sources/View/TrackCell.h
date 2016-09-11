//
//  TrackCell.h
//  MusicSearch
//
//  Created by Pankaj Rathor on 10/09/16.
//  Copyright © 2016 Pankaj Rathor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Track.h"

@class TrackCell;

typedef void (^TrackCellDownloadButtonTappedBlock) (TrackCell *cell);

@interface TrackCell : UITableViewCell

@property(nonatomic,strong) TrackCellDownloadButtonTappedBlock downloadButtonTappedBlock;

- (void) setupTrackCell:(Track *) track;
- (void)hideOrShowDownloadButton:(BOOL)shouldHide;
- (void)hideOrShowProgressView:(BOOL)shouldHide;
- (void)setProgressValue:(float)progressValue;
- (NSString *)previewURL;

@end
