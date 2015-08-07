#import <Foundation/Foundation.h>
#import "RCTBridgeModule.h"

extern NSString *const kUpdaterData;
extern NSString *const kCurrentJsVersion;
extern NSString *const VersionDirectory;

@interface VersionManager : NSObject <RCTBridgeModule>

+ (NSString *) pathForCurrentVersion;

@end
