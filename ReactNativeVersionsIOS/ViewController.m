//
//  ViewController.m
//  RNPlayNative
//
//  Created by Robert Payne on 6/05/15.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)reloadWithRootView:(RCTRootView *)rootView {

  rootView.loadingView = [self spinner];
  rootView.loadingViewFadeDelay = 0.0;
  rootView.loadingViewFadeDuration = 0.15;
  rootView.frame = self.view.bounds;

  [self setView:rootView];
}

- (UIActivityIndicatorView *)spinner {
  
  UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] init];
  [spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
  [spinner setColor:[UIColor colorWithRed:113.0f/255.0f green:47.0f/255.0f blue:169.0f/255.0f alpha:1.0f]];
  [spinner startAnimating];
  return spinner;
}

@end
