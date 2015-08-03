#import "UpdateManager.h"
#import "UpdateDownloader.h"

@implementation UpdateManager

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

RCT_EXPORT_METHOD(currentJSVersion:(RCTPromiseResolveBlock)resolve
                              rejecter:(RCTPromiseRejectBlock)reject) {


  resolve((UpdateDownloader *)[UpdateDownloader sharedInstance].currentJSVersion);
}

RCT_EXPORT_METHOD(loadJSBundleFromPath: (NSString *) path
                              resolver:(RCTPromiseResolveBlock)resolve
                              rejecter:(RCTPromiseRejectBlock)reject) {


  resolve((UpdateDownloader *)[UpdateDownloader sharedInstance].currentJSVersion);
}



@end
