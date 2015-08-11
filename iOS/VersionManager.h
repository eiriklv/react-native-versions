#import <Foundation/Foundation.h>
#import "RCTBridgeModule.h"

#import "VersionManagerDelegate.h"

extern NSString *const kUpdaterData;
extern NSString *const kCurrentJsVersion;
extern NSString *const kPreviousJSVersion;
extern NSString *const VersionDirectory;

@interface VersionManager : NSObject <RCTBridgeModule>

@property (nonatomic, weak) id<VersionManagerDelegate> delegate;

+ (NSString *)pathForCurrentVersion;
+ (void)revertCurrentVersionToPrevious;

@end
