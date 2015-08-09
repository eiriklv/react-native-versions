#import <XCTest/XCTest.h>
#import "Specta.h"

#define EXP_SHORTHAND
#import "Expecta.h"

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

#import "VersionChecker.h"

@interface VersionChecker (Test)
@end

SpecBegin(VersionChecker)

describe(@"VersionChecker", ^{
  
  describe(@"safeToReloadVersionAtPath:moduleName:error", ^{
    
    context(@"with bad arguments", ^{
      
      it(@"creates an error for a nil version path", ^{
        
        NSError *err;
        
        [VersionChecker safeToReloadVersionAtPath:nil moduleName:anything() error:&err];
        
        expect(err.domain).to.equal(VersionCheckerErrorDomain);
        expect(err.code).to.equal(VersionCheckerPathNotValidError);
        
      });
      
      it(@"creates an error for a blank version path", ^{
        
        NSError *err;
        
        [VersionChecker safeToReloadVersionAtPath:@"" moduleName:anything() error:&err];
        
        expect(err.domain).to.equal(VersionCheckerErrorDomain);
        expect(err.code).to.equal(VersionCheckerPathNotValidError);
        
      });
      
      it(@"creates an error for a nil module name", ^{
        
        NSError *err;
        
        [VersionChecker safeToReloadVersionAtPath:@"AnyPath" moduleName:nil error:&err];
        
        expect(err.domain).to.equal(VersionCheckerErrorDomain);
        expect(err.code).to.equal(VersionCheckerModuleNameNotValidError);
        
      });
      
      it(@"creates an error for a blank module name", ^{
        
        NSError *err;
        
        [VersionChecker safeToReloadVersionAtPath:@"AnyPath" moduleName:@"" error:&err];
        
        expect(err.domain).to.equal(VersionCheckerErrorDomain);
        expect(err.code).to.equal(VersionCheckerModuleNameNotValidError);
        
      });
      
    });
    
  });

});

SpecEnd