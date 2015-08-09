//
//  VersionChecker.m
//  ReactNativeVersionsIOS
//
//  Created by Dave Sibiski on 8/8/15.
//  Copyright (c) 2015 Reploy. All rights reserved.
//

#import "VersionChecker.h"

@implementation VersionChecker

+ (BOOL)safeToReloadVersionAtPath:(NSString *)path
                       moduleName:(NSString *)moduleName
                            error:(NSError **)error {
  
  if (!path || [path isEqualToString:@""]) {
    *error = [self createErrorWithDescription:@"The version path is invalid."
                                         code:VersionCheckerPathNotValidError];
    return NO;
  }
  
  if (!moduleName || [moduleName isEqualToString:@""]) {
    *error = [self createErrorWithDescription:@"The module name is invalid."
                                         code:VersionCheckerModuleNameNotValidError];
    return NO;
  }
  
  return NO;
}

+ (NSError *)createErrorWithDescription:(NSString *)description code:(int)code {
  
  NSDictionary *errorDetails = @{NSLocalizedDescriptionKey : description};
    
  return [NSError errorWithDomain:VersionCheckerErrorDomain
                             code:code
                         userInfo:errorDetails];
}

@end
