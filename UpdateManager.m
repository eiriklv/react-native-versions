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

@end
