#import <Foundation/Foundation.h>
#import "RCTBridgeModule.h"

@interface UpdateDownloader : NSObject <RCTBridgeModule>

+ (void) downloadFileAtURL:(NSString*)urlPath ToPath:(NSString*)path Completion:(void(^)(NSError* err))completion;

@end
