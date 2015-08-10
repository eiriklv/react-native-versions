//
//  AppReloader.m
//  RNPlayNative
//
//  Created by Dave Sibiski on 6/2/15.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

#import "AppReloader.h"
#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppReloader

/**
 *  var AppReloader = require('NativeModules').AppReloader;
 *  AppReloader.reloadAppWithURLString('https://example.com/index.ios.bundle', 'App')
 */

+ (void)reloadAppWithVersion:(NSString *)version
                  bundlePath:(NSString *)bundlePath
                 moduleNamed:(NSString *)moduleName {
  
  AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  NSURL *JSBundleURL = [NSURL URLWithString:bundlePath];
  
  ViewController *appViewController = [[ViewController alloc] init];
  [appViewController reloadWithJSBundleURL:JSBundleURL moduleNamed:moduleName];
  
  [UIView transitionWithView:delegate.window
                    duration:kFlipTransitionDuration
                     options:kFlipTransitionType
                  animations:^{
                    delegate.window.rootViewController = appViewController;
                  }
                  completion:NULL];
}

@end
