//
//  VersionManagerDelegate.h
//  ExampleApp
//
//  Created by Dave Sibiski on 8/11/15.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

@class VersionManager;

@protocol VersionManagerDelegate <NSObject>
@optional

- (void)reloadAppWithBundlePath:(NSString *)bundlePath moduleName:(NSString *)moduleName;

@end