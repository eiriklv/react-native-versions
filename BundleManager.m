#import "BundleManager.h"

@implementation BundleManager

- (NSString *)latestJSBundlePath {
  // 1. check documents/version/ for files and return the newest one
  // how would we sort the files? we cannot rely on the creation date, because
  // we could jump back to an older version, which we hadn't loaded before. The file
  // creation date would be never and it would be seen as latest version
  
  // 2. if no files are present, return the path for the main js file from the bundle
  return @"";
}

@end
