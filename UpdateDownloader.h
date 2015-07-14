#import <Foundation/Foundation.h>

@interface UpdateDownloader : NSObject <NSURLSessionDelegate>

@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *appId;
@property (strong, nonatomic) NSString *bundleVersion;

+ (id) sharedInstance;
- (void) configure:(NSDictionary*)config;
- (void) downloadVersion:(NSString *)version Completion:(void (^)(NSError *, NSString *))completion;
- (void) downloadFileAtURL:(NSString*)urlPath ToPath:(NSString*)path Completion:(void(^)(NSError* err))completion;

@end
