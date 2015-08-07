#import "UpdateManager.h"
#import "UpdateDownloader.h"

@implementation UpdateManager

static NSString *kCurrentJSVersion = @"ReployCurrentJsVersion";

@synthesize bridge = _bridge;
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

RCT_EXPORT_METHOD(fetchVersionListAsync:(RCTPromiseResolveBlock)resolve
                              rejecter:(RCTPromiseRejectBlock)reject) {

  [[UpdateDownloader sharedInstance] downloadVersionList:^(NSError *err, NSString* versionList) {
    if (err) {
      reject(err);
    } else {
      resolve(versionList);
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
