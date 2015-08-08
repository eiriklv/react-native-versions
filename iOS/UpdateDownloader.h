#import <Foundation/Foundation.h>

@interface UpdateDownloader : NSObject <NSURLSessionDelegate>

@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *appId;
@property (strong, nonatomic) NSString *binaryVersion;
@property (strong, nonatomic) NSString *currentJSVersion;

+ (UpdateDownloader *)sharedInstance;
- (void)configure:(NSDictionary*)config;
- (void)downloadVersion:(NSString *)version Completion:(void (^)(NSError *err, NSString *path))completion;
- (void)discoverLatestVersion: (void (^)(NSError *err, NSDictionary *version))completion;
- (void)downloadFileAtURL:(NSString*)urlPath ToPath:(NSString*)path Completion:(void(^)(NSError* err))completion;
- (void)setUserDefaultsValueForKey:(NSString*)key value:(NSString *)value;
- (NSDictionary *)getValueFromUserDefaultsForKey:(NSString*)key;

@end
