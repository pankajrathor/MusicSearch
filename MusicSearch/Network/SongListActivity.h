//
//  SongListActivity.h
//  MusicSearch
//
//  Created by Pankaj Rathor on 10/09/16.
//  Copyright © 2016 Pankaj Rathor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Track.h"

@protocol SongListActivityDelegate <NSObject>

- (void) didRecieveTracks:(NSArray *) tracks;

@end

@interface SongListActivity : NSObject

+(instancetype) sharedInstance;

@property (weak, nonatomic) id<SongListActivityDelegate> delegate;

- (void) getSongListWithSearchText:(NSString *) searchText;

@end
