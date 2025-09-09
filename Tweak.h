#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <substrate.h>
#import <MediaRemote/MediaRemote.h>
#import <spawn.h>
#import <sys/utsname.h>
#import <rootless.h>
#import <objc/runtime.h>
#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>

#import "UzUtil/UzLog/UzLog.h"

@interface FlutterMethodCall : NSObject
@property (nonatomic, readonly, nonnull) NSString *method;
@property (nonatomic, readonly, nullable) id arguments;
@end
typedef void (^FlutterResult)(id _Nullable result);
@interface SwiftHealthPlugin : NSObject
- (void)handleMethodCall:(FlutterMethodCall * _Nonnull)call
                  result:(FlutterResult _Nonnull)result;
@end

