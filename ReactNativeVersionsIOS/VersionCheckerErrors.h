//
//  VersionCheckerErrors.h
//  ReactNativeVersionsIOS
//
//  Created by Dave Sibiski on 8/8/15.
//  Copyright (c) 2015 Reploy. All rights reserved.
//

#ifndef ReactNativeVersionsIOS_VersionCheckerErrors_h
#define ReactNativeVersionsIOS_VersionCheckerErrors_h

#import <Foundation/Foundation.h>

static NSString *VersionCheckerErrorDomain = @"com.reploy.ReactNativeVersionsIOS.VersionChecker.ErrorDomain";

enum {
  VersionCheckerPathNotValidError,
  VersionCheckerModuleNameNotValidError
};

#endif
