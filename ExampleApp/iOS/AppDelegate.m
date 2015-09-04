//#define DEBUG 0
//#define RCT_DEV 0
//#define RCT_DEBUG 0

#import "AppDelegate.h"
#import "RCTRootView.h"
#import "VersionManager.h"
#import "ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
  
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
                                               initialProperties:nil
                                                   launchOptions:launchOptions];
  
  [(VersionManager *)rootView.bridge.modules[@"VersionManager"] setDelegate:self];

  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [[UIViewController alloc] init];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  return YES;
}

/**
 * Override this method in order to load the new bundle as you please. This example
 * shows the bundle being loaded into a new RCTRootView, which in turn gets loaded
 * into a view controller that is set as the new rootViewController with a flip
 * transition animation.
 */
- (void)reloadAppWithBundlePath:(NSString *)bundlePath moduleName:(NSString *)moduleName {
  
  NSURL *JSBundleURL = [NSURL URLWithString:bundlePath];
  
  RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:JSBundleURL
                                                      moduleName:moduleName
                                               initialProperties:nil
                                                   launchOptions:nil];
  
  // The delegate needs to be set here since this is a new bridge.
  [(VersionManager *)rootView.bridge.modules[@"VersionManager"] setDelegate:self];
  
  ViewController *viewController = [[ViewController alloc] init];
  [viewController reloadWithRootView:rootView];
  
  [UIView transitionWithView:self.window
                    duration:0.4f
                     options:UIViewAnimationOptionTransitionFlipFromRight
                  animations:^{
                    self.window.rootViewController = viewController;
                  }
                  completion:NULL];
}

void uncaughtExceptionHandler(NSException *exception) {
  
  [VersionManager revertCurrentVersionToPrevious];
  
  // TODO: Log exceptions here...
}

@end
