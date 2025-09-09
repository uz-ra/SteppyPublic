#import <Foundation/Foundation.h>

@interface UzFileManager : NSObject
+ (NSString *)dataDirForBundleID:(NSString *)bundleID;
+ (NSString *)bundleDirForBundleID:(NSString *)bundleID;
+ (void)overwriteXML:(NSString *)inPath : (NSString *)forKey : (id)withData;
+ (void)overwriteJSON:(NSString *)inPath : (NSString *)keyPath : (id)withData;
@end