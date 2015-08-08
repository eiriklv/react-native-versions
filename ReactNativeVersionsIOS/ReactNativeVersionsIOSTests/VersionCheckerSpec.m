#import <XCTest/XCTest.h>
#import "Specta.h"

#define EXP_SHORTHAND
#import "Expecta.h"

#import "VersionChecker.h"

@interface VersionChecker (Test)
@end

SpecBegin(VersionChecker)

describe(@"VersionChecker", ^{

  it(@"passes", ^{
    
    expect(YES).to.beTruthy();
    
  });

});

SpecEnd