#import <Foundation/Foundation.h>
#import "RCTBridgeModule.h"

#import "RNVVersionManagerDelegate.h"

@interface RNVVersionManager : NSObject <RCTBridgeModule>

@property (nonatomic, weak) id<RNVVersionManagerDelegate> delegate;

+ (NSString *)pathForCurrentVersion;
+ (void)revertCurrentVersionToPrevious;

@end
