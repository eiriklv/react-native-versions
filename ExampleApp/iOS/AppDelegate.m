// #define RCT_DEV 0
// #define RCT_DEBUG 0

#import "AppDelegate.h"
#import "RCTRootView.h"
#import "VersionManager.h"

@implementation AppDelegate

@synthesize shouldRotate;

float const kFlipTransitionDuration = 0.4f;
int const kFlipTransitionType = UIViewAnimationOptionTransitionFlipFromRight;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

  NSURL *jsCodeLocation;

  #if RCT_DEV

    // for development

    jsCodeLocation = [NSURL URLWithString:@"http://localhost:8081/index.ios.bundle"];

  #else

    // for releases

    NSString *path = [VersionManager pathForCurrentVersion];

    if (path) {
      jsCodeLocation = [NSURL URLWithString:path];
    } else {
      jsCodeLocation = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
    }

  #endif

  RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                      moduleName:@"ExampleApp"
                                                   launchOptions:launchOptions];

  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [[UIViewController alloc] init];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  return YES;
}

@end
