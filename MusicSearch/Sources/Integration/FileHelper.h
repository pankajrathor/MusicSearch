//
//  FileHelper.h
//  Helper class which abstracts few convinient methods related to FileSystem
//
//  Created by Pankaj Rathor on 10/09/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileHelper : NSObject

// Single instance of FileHelper is shared
+ (instancetype) sharedHelper;

// Tells whether the file should be downloaded or not
- (BOOL) shouldDownloadFileForURL:(NSString *)fileURLString;

// Get the local path for the file
- (NSString*) localPathForURL:(NSString *)fileURLString;

// Removes the file at the specified path
- (BOOL) removeItemAtPath:(NSString *)path;

@end
