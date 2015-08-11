#import "UpdateDownloader.h"

@implementation UpdateDownloader

static NSString *kUpdaterData = @"ReployUpdaterData";
static NSString *kCurrentJSVersion = @"currentJsVersion";

static NSString *LATEST_VERSION = @"https://reploy.io/api/v1/apps/%@/js_versions/latest?apiId=%@&apiSecret=%@&binaryVersion=%@";
static NSString *SINGLE_VERSION_PATH = @"https://reploy.io/api/v1/apps/%@/js_versions/%@?apiId=%@&apiSecret=%@";
static NSString *LOCAL_DIR = @"versions";

+ (UpdateDownloader *)sharedInstance {

  static UpdateDownloader *sharedDownloader = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedDownloader = [[self alloc] init];
  });

  return sharedDownloader;
}

- (instancetype)init {

  if (self = [super init]) {
    self.binaryVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
  }
  return self;
}

- (void)configure:(NSDictionary*)config {

  self.appId = [config objectForKey:@"appId"];
  self.apiId = [config objectForKey:@"apiId"];
  self.apiSecret = [config objectForKey:@"apiSecret"];
}

- (void)discoverLatestVersion:(void (^)(NSError *err, NSDictionary *version))completion {

  NSString *versionPath = [NSString stringWithFormat:LATEST_VERSION, self.appId, self.apiId, self.apiSecret, self.binaryVersion];
  
  [self downloadURLContents:versionPath Completion:^(NSError *err, NSData *data) {
    NSError *error;
    NSDictionary *version = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if ([version objectForKey:@"errors"] != nil) {
      error = [NSError errorWithDomain:@"UpdateDownloader" code:1000 userInfo:nil];
    }
    completion(error, version);
  }];
}

- (void)downloadVersion:(NSString *)version Completion:(void (^)(NSError *err, NSString *path))completion {

  NSString *versionFile = [version stringByAppendingPathExtension:@"js"];
  NSString *remotePath = [NSString stringWithFormat:SINGLE_VERSION_PATH, self.appId, version, self.apiId, self.apiSecret];

  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsPath = [paths objectAtIndex:0];
  NSString *localPath = [[documentsPath stringByAppendingPathComponent:LOCAL_DIR]
                                        stringByAppendingPathComponent:versionFile];

  [self downloadFileAtURL:remotePath ToPath:localPath Completion:^(NSError *err) {
    completion(err, localPath);
  }];
}

- (void)downloadFileAtURL:(NSString *)urlPath ToPath:(NSString *)path Completion:(void (^)(NSError *err))completion {

  [self downloadURLContents:urlPath Completion:^(NSError *err, NSData *data) {
    if (err != nil) {
      return completion(err);
    }

    NSString *localPath = [path stringByDeletingLastPathComponent];
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager createDirectoryAtPath:localPath withIntermediateDirectories:YES attributes:nil error:nil];
    BOOL success = [manager createFileAtPath:path contents:data attributes:nil];

    if (!success) {
      return completion([NSError errorWithDomain:@"UpdateDownloader" code:1000 userInfo:nil]);
    }

    completion(nil);
  }];
}

- (void)downloadURLContents:(NSString*)urlPath Completion:(void (^)(NSError *err, NSData *data))completion {

  NSURL *url = [NSURL URLWithString:urlPath];
  NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
  NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:Nil];

  NSURLSessionDataTask *download = [session
    dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
      completion(error, data);
    }];
  [download resume];
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler{

  if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
    if([challenge.protectionSpace.host isEqualToString:@"api.staging.rnplay.org"]){
      NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
      completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
    } else {
      completionHandler(NSURLSessionAuthChallengeRejectProtectionSpace, nil);
    }
  }
}

#pragma mark - Helper methods

- (NSDictionary *)getValueFromUserDefaultsForKey:(NSString*)key {

  NSDictionary *defaults = [[NSUserDefaults standardUserDefaults] objectForKey:kUpdaterData];
  return [defaults objectForKey:key];
}

- (void)setUserDefaultsValueForKey:(NSString*)key value:(NSString *)value {

  NSMutableDictionary *defaults = [[NSUserDefaults standardUserDefaults] objectForKey:kUpdaterData];
  [[defaults objectForKey:key] setObject:value forKey:key];
  [[NSUserDefaults standardUserDefaults] setObject:defaults forKey:kUpdaterData];
}

@end
