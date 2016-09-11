//
//  FileHelper.h
//  Helper class which abstracts few convinient methods related to FileSystem
//
//  Created by Pankaj Rathor on 10/09/16.
//  Copyright © 2016 Pankaj Rathor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileHelper : NSObject

+ (instancetype) sharedHelper;

- (BOOL)shouldDownloadFileForURL:(NSString *)fileURLString;
- (NSString*)localPathForURL:(NSString *)fileURLString;

@end
