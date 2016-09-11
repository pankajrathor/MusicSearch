//
//  Utilities.m
//  MusicSearch
//
//  Created by Pankaj Rathor on 10/09/16.
//  Copyright © 2016 Pankaj Rathor. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+ (NSURL *) localPathForURL:(NSURL *) fileUrl {
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *fileName = fileUrl.lastPathComponent;
    
    NSString *absoluteFilePath = [NSString stringWithFormat:@"%@/%@", documentPath, fileName];
    
    return [NSURL fileURLWithPath:absoluteFilePath];
}

@end
