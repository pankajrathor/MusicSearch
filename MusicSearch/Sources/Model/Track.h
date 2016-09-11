//
//  Track.h
//  This class store details about a particular track. 
//
//  Created by Pankaj Rathor on 10/09/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Track : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *artist;
@property (strong, nonatomic) NSString *previewURL;
@property (strong, nonatomic) NSString *artworkURL;

- (BOOL) shouldDownloadFile;
- (NSURL*) previewLocalURL;

- (instancetype) initWithDictionary:(NSDictionary *)dictionary;
- (instancetype) initWithName:(NSString *)name artist:(NSString *)artist previewUrl:(NSString *)previewUrl artworkUrl:(NSString *)artworkURL;

@end
