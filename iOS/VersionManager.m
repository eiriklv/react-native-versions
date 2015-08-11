#import "UpdateDownloader.h"
#import "VersionManager.h"

@implementation VersionManager

NSString *const kPreviousJSVersion = @"previousJsVersion";
NSString *const kCurrentJSVersion = @"currentJsVersion";
NSString *const VersionDirectory = @"versions";

@synthesize bridge = _bridge;
@synthesize delegate = _delegate;

+ (NSString *)pathForCurrentVersion {

  NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentJSVersion];

  if (!version) {
    return false;
  }

  NSString *versionFile = [version stringByAppendingPathExtension:@"js"];

  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsPath = [paths objectAtIndex:0];
  NSString *localPath = [[documentsPath stringByAppendingPathComponent:VersionDirectory]
                                        stringByAppendingPathComponent:versionFile];
  
  // Here we need to remove the `previousJsVersion` so that some random exception won't revert the version.
  // Should probably move this somewhere else, I don't really like having this here, but I also didn't want
  // it in the user's AppDelegate.
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPreviousJSVersion];

  return localPath;
}

+ (void)revertCurrentVersionToPrevious {
  
  NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
  NSString *previousJSVersion = [ud objectForKey:@"previousJsVersion"];
  
  // If the `previousJsVersion` doesn't exist, then this is not a crash when trying to update, don't
  // reset the version back to the previous.
  if (previousJSVersion) {
    if ([previousJSVersion isEqualToString:@"FIRST_VERSION"]) {
      // If the previous version was the very first version, `currentJsVersion` would have been `nil`
      // so here we simply set it back to `nil`.
      previousJSVersion = nil;
    }
    
    [ud setValue:previousJSVersion forKey:@"currentJsVersion"];
    [ud removeObjectForKey:@"previousJsVersion"];
    [ud synchronize];
  }
}

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(configure:(NSDictionary*)config) {
  UpdateDownloader *downloader = [UpdateDownloader sharedInstance];
  [downloader configure:config];
}

RCT_EXPORT_METHOD(downloadVersionAsync:(NSString *)version
                              resolver:(RCTPromiseResolveBlock)resolve
                              rejecter:(RCTPromiseRejectBlock)reject) {

  [[UpdateDownloader sharedInstance] downloadVersion:version Completion:^(NSError *err, NSString* localPath) {
    if (err) {
      reject(err);
    } else {
      resolve(localPath);
    }
  }];
}

RCT_EXPORT_METHOD(discoverLatestVersionAsync:(RCTPromiseResolveBlock)resolve
                                    rejecter:(RCTPromiseRejectBlock)reject) {

  [[UpdateDownloader sharedInstance] discoverLatestVersion:^(NSError *err, NSDictionary* version) {
    if (err) {
      reject(err);
    } else {
      resolve(version);
    }
  }];
}

RCT_EXPORT_METHOD(getCurrentJsVersion:(RCTPromiseResolveBlock)resolve
                             rejecter:(RCTPromiseRejectBlock)reject) {

  NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentJSVersion];
  resolve(version);
}

RCT_EXPORT_METHOD(loadJsVersion:(NSString *)version
                     bundlePath:(NSString *)bundlePath
                     moduleName:(NSString *)moduleName
                       resolver:(RCTPromiseResolveBlock)resolve
                       rejecter:(RCTPromiseRejectBlock)reject) {
  
  [self setPreviousVersion];
  [self setCurrentVersion:version];
  
  if ([self.delegate respondsToSelector:@selector(reloadAppWithBundlePath:moduleName:)]) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.delegate reloadAppWithBundlePath:bundlePath moduleName:moduleName];
    });
  }
  
  resolve(version);
}

- (void)setPreviousVersion {
  
  NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
  NSString *currentJSVersion = [ud objectForKey:kCurrentJSVersion];
  
  // If the `currentJsVersion` is `nil`, it means we are at the very first version.
  if (currentJSVersion == nil) {
    currentJSVersion = @"FIRST_VERSION";
  }
  
  // Here we set a `previousJsVersion` to the currentVersion. This will allow us to revert back in case the
  // app that is getting loaded here has an exception.
  [ud setValue:currentJSVersion forKey:kPreviousJSVersion];
  [ud synchronize];
}

- (void)setCurrentVersion:(NSString *)version {
  
  // Here we are optimistically setting the `currentJsVersion` to the version of the latest update downloaded.
  // If there aren't any problems, then it will stand.
  NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
  [ud setValue:version forKey:kCurrentJSVersion];
  [ud synchronize];
}

@end
