//
//  VersionChecker.h
//  ReactNativeVersionsIOS
//
//  Created by Dave Sibiski on 8/8/15.
//  Copyright (c) 2015 Reploy. All rights reserved.
//

#import "VersionCheckerErrors.h"

#import <Foundation/Foundation.h>

@interface VersionChecker : NSObject

+ (BOOL)safeToReloadVersionAtPath:(NSString *)path
                       moduleName:(NSString *)moduleName
                            error:(NSError **)error;

@end
