#import <Foundation/Foundation.h>

@interface RNVUpdateDownloader : NSObject <NSURLSessionDelegate>

@property (strong, nonatomic) NSString *appId;
@property (strong, nonatomic) NSString *apiId;
@property (strong, nonatomic) NSString *apiSecret;

@property (strong, nonatomic) NSString *binaryVersion;
@property (strong, nonatomic) NSString *currentJSVersion;

+ (RNVUpdateDownloader *)sharedInstance;
- (void)configure:(NSDictionary*)config;
- (void)downloadVersion:(NSString *)version Completion:(void (^)(NSError *err, NSString *path))completion;
- (void)discoverLatestVersion: (void (^)(NSError *err, NSDictionary *version))completion;
- (void)downloadFileAtURL:(NSString*)urlPath ToPath:(NSString*)path Completion:(void(^)(NSError* err))completion;
- (void)setUserDefaultsValueForKey:(NSString*)key value:(NSString *)value;
- (NSDictionary *)getValueFromUserDefaultsForKey:(NSString*)key;

@end
