#import "UpdateDownloader.h"
#import "VersionManager.h"

@implementation VersionManager

NSString *const kCurrentJSVersion = @"currentJsVersion";
NSString *const VersionDirectory = @"versions";

@synthesize bridge = _bridge;

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

  return localPath;
}

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(configureUpdater:(NSDictionary*)config) {
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

RCT_EXPORT_METHOD(setCurrentJsVersion:(NSString *)version
                             resolver:(RCTPromiseResolveBlock)resolve
                             rejecter:(RCTPromiseRejectBlock)reject) {
  
  [[NSUserDefaults standardUserDefaults] setValue:version forKey:kCurrentJSVersion];
  resolve([[NSUserDefaults standardUserDefaults] objectForKey:kCurrentJSVersion]);
}

@end
